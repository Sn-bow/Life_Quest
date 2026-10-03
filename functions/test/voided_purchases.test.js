'use strict';
const test = require('node:test');
const assert = require('node:assert/strict');
const {hash, PACKAGE_NAME} = require('../purchase_policy');
const {LOOKBACK_DAYS, MAX_PAGES, reconcileVoidedPurchases} = require('../voided_purchases');

function fixture(pages) {
  const rows = new Map();
  const requests = [];
  const ref = path => ({path, doc: id => ref(`${path}/${id}`),
    collection: name => ref(`${path}/${name}`)});
  const snapshot = path => ({exists: rows.has(path), data: () => rows.get(path)});
  const db = {collection: ref, runTransaction: async callback => {
    const writes = [];
    await callback({get: async r => snapshot(r.path),
      set: (r, value) => writes.push([r.path, value]),
      update: (r, value) => writes.push([r.path, value])});
    for (const [path, value] of writes) rows.set(path, {...rows.get(path), ...value});
  }};
  const publisher = {purchases: {voidedpurchases: {list: async options => {
    requests.push(options);
    return {data: pages[requests.length - 1]};
  }}}};
  return {rows, requests, input: {publisher, db, timestamp: () => 123,
    nowMillis: Date.UTC(2026, 8, 28)}};
}

test('the daily scan revokes missed full refunds and paginates with a 28-day overlap', async () => {
  const token = 'status-pack-purchase-token';
  const key = hash(token);
  const f = fixture([
    {voidedPurchases: [{purchaseToken: token}], tokenPagination: {nextPageToken: 'page-2'}},
    {voidedPurchases: [{purchaseToken: token}, {purchaseToken: 'short'},
      {purchaseToken: 'partial-purchase-token', voidedQuantity: 1}]},
  ]);
  f.rows.set(`purchaseTokens/${key}`, {uid: 'alice', productId: 'status_window_plus_01',
    state: 'purchased'});
  const grant = 'users/alice/entitlements/status_window_plus_01';
  f.rows.set(grant, {purchaseKey: key, active: true});
  assert.deepEqual(await reconcileVoidedPurchases(f.input), {reconciled: 1});
  assert.equal(f.rows.get(grant).active, false);
  assert.equal(f.rows.get(`purchaseTokens/${key}`).state, 'revoked');
  assert.equal(f.rows.has(`purchaseTokens/${hash('partial-purchase-token')}`), false);
  assert.equal(f.requests[0].packageName, PACKAGE_NAME);
  assert.equal(f.requests[0].type, 0);
  assert.equal(f.requests[0].includeQuantityBasedPartialRefund, false);
  assert.equal(f.requests[0].maxResults, 1000);
  assert.equal(f.requests[0].startTime,
    String(f.input.nowMillis - LOOKBACK_DAYS * 24 * 60 * 60 * 1000));
  assert.equal(f.requests[1].token, 'page-2');
  assert.equal(JSON.stringify([...f.rows.values()]).includes(token), false);
});

test('an older refunded token cannot revoke a replacement pack', async () => {
  const old = 'old-status-pack-token';
  const replacement = 'new-status-pack-token';
  const f = fixture([{voidedPurchases: [{purchaseToken: old}]}]);
  f.rows.set(`purchaseTokens/${hash(old)}`, {uid: 'alice',
    productId: 'status_window_plus_01', state: 'purchased'});
  const grant = 'users/alice/entitlements/status_window_plus_01';
  f.rows.set(grant, {purchaseKey: hash(replacement), active: true});
  await reconcileVoidedPurchases(f.input);
  assert.equal(f.rows.get(grant).active, true);
  assert.equal(f.rows.get(`purchaseTokens/${hash(old)}`).state, 'revoked');
});

test('overlapping scans do not rewrite a token already revoked', async () => {
  const token = 'refunded-status-pack-token';
  const key = `purchaseTokens/${hash(token)}`;
  const f = fixture([{voidedPurchases: [{purchaseToken: token}]},
    {voidedPurchases: [{purchaseToken: token}]}]);
  f.rows.set(key, {uid: 'alice', productId: 'status_window_plus_01',
    state: 'purchased'});
  await reconcileVoidedPurchases(f.input);
  const original = f.rows.get(key);
  await reconcileVoidedPurchases({...f.input, timestamp: () => 999});
  assert.deepEqual(f.rows.get(key), original);
});

test('a scan reports pagination overflow instead of silently claiming success', async () => {
  const pages = Array.from({length: MAX_PAGES}, () =>
    ({voidedPurchases: [], tokenPagination: {nextPageToken: 'more'}}));
  const f = fixture(pages);
  await assert.rejects(reconcileVoidedPurchases(f.input), /page limit/);
  assert.equal(f.requests.length, MAX_PAGES);
});
