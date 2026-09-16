'use strict';
const test = require('node:test');
const assert = require('node:assert/strict');
const {ensurePurchaseAccount} = require('../purchase_account');
function fixture(entries = []) {
  const rows = new Map(entries);
  let writes = 0;
  const ref = path => ({path, doc: id => ref(`${path}/${id}`)});
  const db = {collection: ref, runTransaction: async callback => {
    const pending = [];
    await callback({get: async r => ({exists: rows.has(r.path), data: () => rows.get(r.path)}),
      set: (r, d) => pending.push([r.path, d])});
    for (const [path, data] of pending) { rows.set(path, data); ++writes; }
  }};
  return {rows, get writes() { return writes; }, input: {
    uid: 'alice', provider: 'google.com', db, timestamp: () => 123,
  }};
}
test('purchase account creation stores only purpose and timestamp; retry is idempotent', async () => {
  const f = fixture();
  assert.deepEqual(await ensurePurchaseAccount({...f.input, data: {goal: 'never copy', email: 'private'}}), {ready: true});
  assert.deepEqual(f.rows.get('users/alice'), {accountKind: 'purchaseOnly', createdAt: 123});
  await ensurePurchaseAccount({...f.input, timestamp: () => 999});
  assert.equal(f.writes, 1);
});
test('existing legacy profile is preserved without writes', async () => {
  const original = {character: {gold: 23, name: 'Existing'}, dailyQuests: ['private']};
  const f = fixture([['users/alice', original]]);
  await ensurePurchaseAccount(f.input);
  assert.equal(f.rows.get('users/alice'), original);
  assert.equal(f.writes, 0);
});
test('anonymous, absent, wrong-provider and malformed identities cannot create accounts', async () => {
  for (const override of [{uid: null}, {uid: ''}, {uid: 'a/b'}, {provider: 'anonymous'}, {provider: 'password'}]) {
    const f = fixture();
    await assert.rejects(ensurePurchaseAccount({...f.input, ...override}), {code: 'unauthenticated'});
    assert.equal(f.writes, 0);
  }
});
test('pending/completed deletion markers and pending profile prohibit recreation', async () => {
  for (const entries of [[['accountDeletions/alice', {state: 'pending'}]],
    [['accountDeletions/alice', {state: 'complete'}]], [['users/alice', {deletionPending: true}]]]) {
    const f = fixture(entries);
    await assert.rejects(ensurePurchaseAccount(f.input), {code: 'failed-precondition'});
    assert.equal(f.writes, 0);
  }
});
