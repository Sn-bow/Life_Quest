'use strict';
const test = require('node:test');
const assert = require('node:assert/strict');
const {ensurePurchaseAccount, requirePurchaseAccount} = require('../purchase_account');
const {hash} = require('../purchase_policy');
function fixture(entries = []) {
  const rows = new Map(entries);
  let writes = 0;
  const ref = path => ({path, doc: id => ref(`${path}/${id}`),
    get: async () => ({exists: rows.has(path), data: () => rows.get(path)})});
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
  assert.deepEqual(f.rows.get(`purchaseAccountIds/${hash('alice')}`), {uid: 'alice', createdAt: 123});
  await ensurePurchaseAccount({...f.input, timestamp: () => 999});
  assert.equal(f.writes, 2);
});
test('existing legacy profile is preserved while adding only the recovery index', async () => {
  const original = {character: {gold: 23, name: 'Existing'}, dailyQuests: ['private']};
  const f = fixture([['users/alice', original]]);
  await ensurePurchaseAccount(f.input);
  assert.equal(f.rows.get('users/alice'), original);
  assert.deepEqual(f.rows.get(`purchaseAccountIds/${hash('alice')}`), {uid: 'alice', createdAt: 123});
  assert.equal(f.writes, 1);
});
test('an account hash already bound to another uid cannot be overwritten', async () => {
  const f = fixture([[`purchaseAccountIds/${hash('alice')}`, {uid: 'bob'}]]);
  await assert.rejects(ensurePurchaseAccount(f.input), {code: 'failed-precondition'});
  assert.equal(f.writes, 0);
});
test('verification requires a mapped Google account with an active user', async () => {
  const f = fixture([['users/alice', {accountKind: 'purchaseOnly'}],
    [`purchaseAccountIds/${hash('alice')}`, {uid: 'alice'}]]);
  await requirePurchaseAccount(f.input);
  for (const provider of ['anonymous', 'password', undefined]) {
    await assert.rejects(requirePurchaseAccount({...f.input, provider}), {code: 'unauthenticated'});
  }
  f.rows.set(`purchaseAccountIds/${hash('alice')}`, {uid: 'bob'});
  await assert.rejects(requirePurchaseAccount(f.input), {code: 'failed-precondition'});
  f.rows.delete(`purchaseAccountIds/${hash('alice')}`);
  await assert.rejects(requirePurchaseAccount(f.input), {code: 'failed-precondition'});
});
test('existing email profile can buy only after Google is linked to the same Firebase UID', async () => {
  const original = {character: {level: 7, name: 'Existing'}};
  const f = fixture([['users/alice', original]]);
  const linked = {uid: 'alice', providerData: [{providerId: 'password'}, {providerId: 'google.com'}]};
  const loadAuthUser = async uid => {assert.equal(uid, 'alice'); return linked;};
  await ensurePurchaseAccount({...f.input, provider: 'password', loadAuthUser});
  assert.equal(f.rows.get('users/alice'), original);
  await requirePurchaseAccount({...f.input, provider: 'password', loadAuthUser});
  await assert.rejects(requirePurchaseAccount({...f.input, provider: 'password',
    loadAuthUser: async () => ({uid: 'alice', providerData: [{providerId: 'password'}]})}),
  {code: 'unauthenticated'});
  await assert.rejects(requirePurchaseAccount({...f.input, provider: 'password',
    loadAuthUser: async () => ({uid: 'bob', providerData: [{providerId: 'google.com'}]})}),
  {code: 'unauthenticated'});
});
test('deletion marker and pending/deleted user close the verification account', async () => {
  for (const change of [
    rows => rows.set('accountDeletions/alice', {state: 'pending'}),
    rows => rows.set('users/alice', {deletionPending: true}),
    rows => rows.delete('users/alice'),
  ]) {
    const f = fixture([['users/alice', {accountKind: 'purchaseOnly'}],
      [`purchaseAccountIds/${hash('alice')}`, {uid: 'alice'}]]);
    change(f.rows);
    await assert.rejects(requirePurchaseAccount(f.input), {code: 'failed-precondition'});
  }
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
