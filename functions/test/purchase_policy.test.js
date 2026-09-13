'use strict';
const test = require('node:test');
const assert = require('node:assert/strict');
const {verifyAndGrant, reconcileNotification, hash, PACKAGE_NAME, validateRequest} = require('../purchase_policy');
function fixture(receipt = {}) {
  const rows = new Map([['users/alice', {deletionPending: false}], ['users/bob', {deletionPending: false}]]); let acknowledgements = 0; let failAck = false; let transactionFails = false;
  const ref = path => ({path, collection: name => ref(`${path}/${name}`), doc: id => ref(`${path}/${id}`),
    get: async () => snapshot(path)});
  const snapshot = path => ({exists: rows.has(path), data: () => rows.get(path)});
  const db = {collection: name => ref(name), runTransaction: async callback => {
    const writes = [];
    const tx = {get: async reference => snapshot(reference.path),
      set: (reference, value) => writes.push([reference.path, value]),
      update: (reference, value) => writes.push([reference.path, value])};
    await callback(tx);
    if (transactionFails) throw Error('simulated storage outage');
    for (const [key, value] of writes) rows.set(key, {...rows.get(key), ...value});
  }};
  const current = {purchaseState: 0, acknowledgementState: 0, consumptionState: 0, quantity: 1,
    obfuscatedExternalAccountId: hash('alice'), ...receipt};
  const publisher = {purchases: {products: {get: async () => ({data: current}),
    acknowledge: async () => {if (failAck) throw Error('simulated network outage'); acknowledgements++;}}}};
  const input = {uid: 'alice', data: {packageName: PACKAGE_NAME, productId: 'cosmetic_theme_neon', purchaseToken: 'synthetic-purchase-token'}, db, publisher, timestamp: () => 123};
  return {input, rows, current, set failAck(v) {failAck = v;}, set transactionFails(v) {transactionFails = v;}, get acknowledgements() {return acknowledgements;}};
}
test('reject unknown products and packages before any publisher access', () => {
  assert.throws(() => validateRequest({packageName: 'other.app', productId: 'cosmetic_theme_neon', purchaseToken: 'synthetic-purchase-token'}));
  assert.throws(() => validateRequest({packageName: PACKAGE_NAME, productId: '__proto__', purchaseToken: 'synthetic-purchase-token'}));
});
test('pending, cancelled, consumed and mismatched-account receipts never grant', async () => {
  for (const purchaseState of [1, 2, undefined]) {
    const f = fixture({purchaseState}); assert.deepEqual(await verifyAndGrant(f.input), {isValid: false});
    assert.equal(f.rows.size, 2); assert.equal(f.acknowledgements, 0);
  }
  for (const value of [{consumptionState: 1}, {obfuscatedExternalAccountId: hash('bob')}, {quantity: 2}]) {
    const f = fixture(value); await assert.rejects(verifyAndGrant(f.input)); assert.equal(f.rows.size, 2);
  }
});
test('grant is durable and idempotent before acknowledgement', async () => {
  const f = fixture(); await verifyAndGrant(f.input); f.current.acknowledgementState = 1;
  await verifyAndGrant(f.input); assert.equal(f.rows.size, 4); assert.equal(f.acknowledgements, 1);
  assert.equal(f.rows.get('users/alice/entitlements/cosmetic_theme_neon').active, true);
  assert.equal(JSON.stringify([...f.rows.values()]).includes('synthetic-purchase-token'), false);
});
test('never acknowledge after a failed durable grant', async () => {
  const f = fixture(); f.transactionFails = true; await assert.rejects(verifyAndGrant(f.input));
  assert.equal(f.rows.size, 2); assert.equal(f.acknowledgements, 0);
});
test('acknowledgement failure is safely retried without duplicate entitlements', async () => {
  const f = fixture(); f.failAck = true; await assert.rejects(verifyAndGrant(f.input));
  assert.equal(f.rows.size, 4); f.failAck = false; await verifyAndGrant(f.input);
  assert.equal(f.rows.size, 4); assert.equal(f.acknowledgements, 1);
});
test('token cannot be claimed by another app account even with a forged account field', async () => {
  const f = fixture(); await verifyAndGrant(f.input); f.current.obfuscatedExternalAccountId = hash('bob');
  await assert.rejects(verifyAndGrant({...f.input, uid: 'bob'}));
  assert.equal(f.rows.has('users/bob/entitlements/cosmetic_theme_neon'), false);
});
test('refund notification revokes entitlement and ignores notifications for other apps', async () => {
  const f = fixture(); await verifyAndGrant(f.input); f.current.purchaseState = 1;
  const notification = {packageName: PACKAGE_NAME, oneTimeProductNotification: {purchaseToken: f.input.data.purchaseToken}};
  await reconcileNotification({...f.input, notification: {...notification, packageName: 'other.app'}});
  assert.equal(f.rows.get('users/alice/entitlements/cosmetic_theme_neon').active, true);
  await reconcileNotification({...f.input, notification});
  assert.equal(f.rows.get('users/alice/entitlements/cosmetic_theme_neon').active, false);
});
test('old refund cannot revoke a replacement token', async () => {
  const f = fixture(); await verifyAndGrant(f.input);
  await verifyAndGrant({...f.input, data: {...f.input.data, purchaseToken: 'replacement-purchase-token'}});
  f.current.purchaseState = 1;
  await reconcileNotification({...f.input, notification: {packageName: PACKAGE_NAME,
    voidedPurchaseNotification: {purchaseToken: f.input.data.purchaseToken}}});
  assert.equal(f.rows.get('users/alice/entitlements/cosmetic_theme_neon').active, true);
});

test('deleted or deleting app accounts cannot be granted or acknowledged', async () => {
  for (const deleted of [false, true]) {
    const f = fixture();
    if (deleted) f.rows.delete('users/alice');
    else f.rows.set('users/alice', {deletionPending: true});
    await assert.rejects(verifyAndGrant(f.input));
    assert.equal(f.rows.has('users/alice/entitlements/cosmetic_theme_neon'), false);
    assert.equal(f.acknowledgements, 0);
  }
});
test('expired receipt revokes, while temporary Google failure is retried', async () => {
  for (const code of [404, 410, 503]) {
    const f = fixture(); await verifyAndGrant(f.input);
    f.input.publisher.purchases.products.get = async () => { throw Object.assign(new Error('synthetic'), {code}); };
    const event = {notification: {packageName: PACKAGE_NAME, oneTimeProductNotification: {purchaseToken: f.input.data.purchaseToken}}, ...f.input};
    if (code === 503) await assert.rejects(reconcileNotification(event));
    else await reconcileNotification(event);
    assert.equal(f.rows.get('users/alice/entitlements/cosmetic_theme_neon').active, code === 503);
  }
});
