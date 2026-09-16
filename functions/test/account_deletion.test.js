'use strict';
const test = require('node:test');
const assert = require('node:assert/strict');
const {requestDeletion, completeDeletion} = require('../account_deletion');

function fixture() {
  const rows = new Map([
    ['users/alice', {character: {name: 'Synthetic', level: 1, gold: 0}}],
    ['users/alice/aiReports/r', {title: 'Synthetic report'}],
    ['users/alice/entitlements/theme', {active: true}],
    ['purchaseTokens/a', {uid: 'alice'}], ['purchaseTokens/b', {uid: 'bob'}],
    ['users/bob', {character: {name: 'Other'}}],
  ]);
  let failStorage = false, failData = false, authError = null;
  const calls = [];
  const snapshot = path => ({exists: rows.has(path), data: () => rows.get(path), ref: ref(path)});
  const ref = path => ({path,
    doc: id => ref(`${path}/${id}`),
    get: async () => snapshot(path),
    set: async (data, options) => rows.set(path, options?.merge ? {...rows.get(path), ...data} : data),
    where: (field, op, value) => ({limit: size => ({get: async () => {
      const docs = [...rows.entries()].filter(([k, v]) => k.startsWith(`${path}/`) && v[field] === value).slice(0, size).map(([k]) => snapshot(k));
      return {empty: docs.length === 0, docs};
    }})}),
  });
  const db = {collection: ref,
    runTransaction: async callback => {
      const writes = [];
      await callback({get: r => r.get(), set: (r, d, o) => writes.push(() => r.set(d, o))});
      for (const write of writes) await write();
    },
    recursiveDelete: async r => {
      calls.push('data');
      for (const key of [...rows.keys()]) {
        if (key === r.path || key.startsWith(`${r.path}/`)) {
          rows.delete(key);
          if (failData) throw Error('partial data failure');
        }
      }
    },
    batch: () => {
      const removals = [];
      return {delete: r => removals.push(r.path), commit: async () => removals.forEach(k => rows.delete(k))};
    },
  };
  const nowMillis = 1800000000000;
  const input = {uid: 'alice', authTime: nowMillis / 1000, nowMillis, db, timestamp: () => 123,
    deleteFiles: async uid => {assert.equal(uid, 'alice'); calls.push('storage'); if (failStorage) throw Error('storage failure');},
    auth: {deleteUser: async uid => {
      assert.equal(uid, 'alice'); calls.push('auth');
      assert.equal([...rows.keys()].some(k => k.startsWith('users/alice')), false);
      assert.equal(rows.has('purchaseTokens/a'), false);
      if (authError) throw Object.assign(Error('auth failure'), {code: authError});
    }},
  };
  return {input, rows, calls, set failStorage(v) {failStorage = v;}, set failData(v) {failData = v;}, set authError(v) {authError = v;}};
}

test('only a recent authenticated session can request deletion', async () => {
  for (const override of [{uid: null}, {authTime: undefined}, {authTime: 0}, {authTime: 1800000400}]) {
    const f = fixture();
    await assert.rejects(requestDeletion({...f.input, ...override}));
    assert.equal(f.rows.has('accountDeletions/alice'), false);
    assert.equal(f.rows.get('users/alice').deletionPending, undefined);
  }
});
test('a retried request is durable, idempotent, and does not delete data in the callable', async () => {
  const f = fixture();
  assert.deepEqual(await requestDeletion(f.input), {accepted: true});
  await requestDeletion({...f.input, timestamp: () => 999});
  assert.equal(f.rows.get('accountDeletions/alice').requestedAt, 123);
  assert.equal(f.rows.get('users/alice').deletionPending, true);
  assert.equal(f.rows.get('users/alice').character.name, 'Synthetic');
  assert.deepEqual(f.calls, []);
});
test('cleanup removes only the requesting account, including reports and purchase ownership', async () => {
  const f = fixture(); await requestDeletion(f.input); await completeDeletion(f.input);
  assert.deepEqual(f.calls, ['storage', 'data', 'auth']);
  assert.equal(f.rows.has('users/bob'), true);
  assert.equal(f.rows.has('purchaseTokens/b'), true);
  const marker = f.rows.get('accountDeletions/alice');
  assert.equal(marker.state, 'complete');
  assert.equal(marker.expiresAt.getTime(), f.input.nowMillis + 7 * 86400000);
  await completeDeletion(f.input); // Duplicate event does no work.
  assert.equal(f.calls.length, 3);
});
test('storage and partial database failures leave a retryable request and keep auth', async () => {
  for (const phase of ['failStorage', 'failData']) {
    const f = fixture(); await requestDeletion(f.input); f[phase] = true;
    await assert.rejects(completeDeletion(f.input));
    assert.equal(f.rows.get('accountDeletions/alice').state, 'pending');
    assert.equal(f.calls.includes('auth'), false);
    f[phase] = false; await completeDeletion(f.input);
    assert.equal(f.rows.get('accountDeletions/alice').state, 'complete');
  }
});
test('missing auth is idempotent, other auth failures remain pending until retried', async () => {
  for (const code of ['auth/user-not-found', 'auth/internal-error']) {
    const f = fixture(); await requestDeletion(f.input); f.authError = code;
    if (code === 'auth/user-not-found') await completeDeletion(f.input);
    else {
      await assert.rejects(completeDeletion(f.input));
      assert.equal(f.rows.get('accountDeletions/alice').state, 'pending');
      f.authError = null; await completeDeletion(f.input);
    }
    assert.equal(f.rows.get('accountDeletions/alice').state, 'complete');
  }
});

test('anonymous report deletion never bypasses permanent-account reauthentication', async () => {
  const {requestAnonymousReportDeletion} = require('../account_deletion');
  for (const provider of ['google.com', 'password', undefined]) {
    const f = fixture();
    await assert.rejects(requestAnonymousReportDeletion({...f.input, provider}), {code: 'permission-denied'});
    assert.equal(f.rows.has('accountDeletions/alice'), false);
  }
  const f = fixture();
  await assert.rejects(requestAnonymousReportDeletion({...f.input, provider: 'anonymous',
    loadAuthUser: async () => ({uid: 'alice', providerData: [{providerId: 'google.com'}]})}), {code: 'permission-denied'});
  assert.deepEqual(await requestAnonymousReportDeletion({...f.input, provider: 'anonymous', authTime: 0,
    loadAuthUser: async () => ({uid: 'alice', providerData: []})}), {accepted: true});
  assert.equal(f.rows.get('accountDeletions/alice').state, 'pending');
});
