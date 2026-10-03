'use strict';
const test = require('node:test');
const assert = require('node:assert/strict');
const {verifyAndGrant, retryPurchaseAcknowledgement, reconcileNotification, hash,
  PACKAGE_NAME, validateRequest, readPlayNotification} = require('../purchase_policy');
const {requirePurchaseAccount} = require('../purchase_account');
function fixture(receipt = {}) {
  const rows = new Map([['users/alice', {deletionPending: false}], ['users/bob', {deletionPending: false}]]); let acknowledgements = 0; let failAck = false; let transactionFails = false;
  const jobs = []; let queueFails = false;
  const ref = path => ({path, collection: name => ref(`${path}/${name}`), doc: id => ref(`${path}/${id}`),
    get: async () => snapshot(path)});
  const snapshot = path => ({exists: rows.has(path), data: () => rows.get(path)});
  const db = {collection: name => ref(name), runTransaction: async callback => {
    const writes = [];
    const tx = {get: async reference => snapshot(reference.path),
      set: (reference, value) => writes.push([reference.path, value]),
      update: (reference, value) => writes.push([reference.path, value])};
    const result = await callback(tx);
    if (transactionFails) throw Error('simulated storage outage');
    for (const [key, value] of writes) rows.set(key, {...rows.get(key), ...value});
    return result;
  }};
  const current = {purchaseState: 0, acknowledgementState: 0, consumptionState: 0, quantity: 1,
    obfuscatedExternalAccountId: hash('alice'), ...receipt};
  const publisher = {purchases: {products: {get: async () => ({data: current}),
    acknowledge: async () => {if (failAck) throw Error('simulated network outage synthetic-purchase-token'); acknowledgements++; current.acknowledgementState = 1;}}}};
  const input = {uid: 'alice', data: {packageName: PACKAGE_NAME, productId: 'cosmetic_theme_neon', purchaseToken: 'synthetic-purchase-token'}, db, publisher, timestamp: () => 123,
    enqueueAcknowledgement: async job => {if (queueFails) throw Error('simulated queue outage'); jobs.push(job);}};
  return {input, rows, current, jobs, set queueFails(v) {queueFails = v;},
    set failAck(v) {failAck = v;}, set transactionFails(v) {transactionFails = v;}, get acknowledgements() {return acknowledgements;}};
}
test('reject unknown products and packages before any publisher access', () => {
  assert.throws(() => validateRequest({packageName: 'other.app', productId: 'cosmetic_theme_neon', purchaseToken: 'synthetic-purchase-token'}));
  assert.throws(() => validateRequest({packageName: PACKAGE_NAME, productId: '__proto__', purchaseToken: 'synthetic-purchase-token'}));
});
test('malformed RTDN payloads are discarded without exposing parse errors', () => {
  const rawToken = 'synthetic-purchase-token';
  const broken = {data: {message: {get json() {throw Error(rawToken);}}}};
  assert.equal(readPlayNotification(broken), null);
  assert.equal(readPlayNotification({data: {message: {json: [rawToken]}}}), null);
  assert.equal(readPlayNotification({data: {message: {json: rawToken}}}), null);
  assert.equal(readPlayNotification({data: {message: {json: {
    packageName: PACKAGE_NAME,
    oneTimeProductNotification: {purchaseToken: rawToken},
  }}}}).oneTimeProductNotification.purchaseToken, rawToken);
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
test('acknowledgement failure is retried by the server after the app exits', async () => {
  const f = fixture(); f.failAck = true;
  assert.equal((await verifyAndGrant(f.input)).isValid, true);
  assert.equal(f.rows.size, 4); assert.equal(f.jobs.length, 1);
  const worker = {...f.input, ...f.jobs[0]};
  await assert.rejects(retryPurchaseAcknowledgement(worker), error =>
    error.message === 'Purchase acknowledgement is temporarily unavailable.');
  f.failAck = false;
  await retryPurchaseAcknowledgement(worker);
  await retryPurchaseAcknowledgement(worker);
  assert.equal(f.rows.size, 4); assert.equal(f.acknowledgements, 1);
  assert.equal(f.jobs.length, 1); // Recovery never recursively enqueues.
});

test('queue failure cannot create an unprotected durable grant', async () => {
  const f = fixture(); f.queueFails = true;
  await assert.rejects(verifyAndGrant(f.input));
  assert.equal(f.rows.size, 2); assert.equal(f.acknowledgements, 0);
});

test('queued recovery survives a crash before the original grant commits', async () => {
  const f = fixture(); f.transactionFails = true;
  await assert.rejects(verifyAndGrant(f.input));
  assert.equal(f.jobs.length, 1); assert.equal(f.rows.size, 2);
  f.transactionFails = false;
  await retryPurchaseAcknowledgement({...f.input, ...f.jobs[0]});
  assert.equal(f.rows.size, 4); assert.equal(f.acknowledgements, 1);
});

test('recovery terminates for deleting accounts and revokes refunded purchases', async () => {
  for (const terminal of ['deleting', 'deleted', 'refunded']) {
    const f = fixture(); f.failAck = true; await verifyAndGrant(f.input);
    if (terminal === 'deleting') f.rows.set('users/alice', {deletionPending: true});
    if (terminal === 'deleted') f.rows.delete('users/alice');
    if (terminal === 'refunded') f.current.purchaseState = 1;
    const result = await retryPurchaseAcknowledgement({...f.input, ...f.jobs[0]});
    assert.equal(result.isValid, false); assert.equal(f.acknowledgements, 0);
    if (terminal === 'refunded') {
      assert.equal(f.rows.get('users/alice/entitlements/cosmetic_theme_neon').active, false);
    }
  }
});

test('delayed recovery for an old purchase preserves the replacement grant', async () => {
  const f = fixture(); f.failAck = true; await verifyAndGrant(f.input);
  const replacement = 'replacement-purchase-token';
  await verifyAndGrant({...f.input, data: {...f.input.data, purchaseToken: replacement}});
  f.failAck = false;
  await retryPurchaseAcknowledgement({...f.input, ...f.jobs[0]});
  const grant = f.rows.get('users/alice/entitlements/cosmetic_theme_neon');
  assert.equal(grant.purchaseKey, hash(replacement));
  assert.equal(grant.active, true); assert.equal(f.acknowledgements, 1);
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
    voidedPurchaseNotification: {purchaseToken: f.input.data.purchaseToken,
      productType: 2, refundType: 1}}});
  assert.equal(f.rows.get('users/alice/entitlements/cosmetic_theme_neon').active, true);
});

test('full one-time refund revokes the status pack even when the Play lookup is stale', async () => {
  const f = fixture();
  f.input.data.productId = 'status_window_plus_01';
  const result = await verifyAndGrant(f.input);
  assert.deepEqual(result, {isValid: true, entitlementId: 'status_window_plus_01'});
  const path = 'users/alice/entitlements/status_window_plus_01';
  assert.equal(f.rows.get(path).active, true);
  assert.equal(f.rows.size, 4); // One entitlement, no XP or other reward writes.
  const notification = {packageName: PACKAGE_NAME,
    voidedPurchaseNotification: {purchaseToken: f.input.data.purchaseToken,
      productType: 2, refundType: 1}};
  await reconcileNotification({...f.input, notification});
  assert.equal(f.rows.get(path).active, false);
  assert.equal(f.current.purchaseState, 0); // Play lookup intentionally remains stale.
  assert.deepEqual(await verifyAndGrant(f.input), {isValid: false});
  assert.equal(f.rows.get(path).active, false);
  assert.equal(f.jobs.length, 1); // A revoked token schedules no new recovery job.
  await reconcileNotification({...f.input, notification: {packageName: PACKAGE_NAME,
    oneTimeProductNotification: {purchaseToken: f.input.data.purchaseToken,
      sku: 'status_window_plus_01', notificationType: 1}}});
  assert.equal(f.rows.get(path).active, false); // Old events cannot reopen access.
});

test('Complete grant is durable, restored idempotently and revoked on full refund', async () => {
  const f = fixture();
  const productId = 'quest_journeys_complete_01';
  f.input.data.productId = productId;
  assert.deepEqual(await verifyAndGrant(f.input), {isValid: true, entitlementId: productId});
  assert.deepEqual(await verifyAndGrant(f.input), {isValid: true, entitlementId: productId});
  const path = `users/alice/entitlements/${productId}`;
  assert.equal(f.rows.get(path).active, true);
  await reconcileNotification({...f.input, notification: {packageName: PACKAGE_NAME,
    voidedPurchaseNotification: {purchaseToken: f.input.data.purchaseToken,
      productType: 2, refundType: 1}}});
  assert.equal(f.rows.get(path).active, false);
  assert.deepEqual(await verifyAndGrant(f.input), {isValid: false});
});

test('unrelated or partial voided notifications do not revoke a one-time pack', async () => {
  const f = fixture();
  f.input.data.productId = 'status_window_plus_01';
  await verifyAndGrant(f.input);
  const path = 'users/alice/entitlements/status_window_plus_01';
  for (const [productType, refundType] of [[1, 1], [2, 2]]) {
    await reconcileNotification({...f.input, notification: {packageName: PACKAGE_NAME,
      voidedPurchaseNotification: {purchaseToken: f.input.data.purchaseToken,
        productType, refundType}}});
    assert.equal(f.rows.get(path).active, true);
  }
});

test('Play RTDN validates an unclaimed status pack and recovers it after app exit', async () => {
  const f = fixture();
  const identity = `purchaseAccountIds/${hash('alice')}`;
  f.rows.set(identity, {uid: 'alice', createdAt: 123});
  const notification = {packageName: PACKAGE_NAME, oneTimeProductNotification: {
    purchaseToken: f.input.data.purchaseToken,
    sku: 'status_window_plus_01', notificationType: 1,
  }};
  await reconcileNotification({...f.input, notification});
  const grant = f.rows.get('users/alice/entitlements/status_window_plus_01');
  assert.equal(grant.active, true);
  assert.equal(grant.entitlementId, 'status_window_plus_01');
  assert.equal(f.acknowledgements, 1);
  assert.equal(f.jobs.length, 1); // Recovery is durable before the grant.
});

test('RTDN cannot grant an unclaimed token from an unbound or forged account hash', async () => {
  const notice = {packageName: PACKAGE_NAME, oneTimeProductNotification: {
    purchaseToken: 'synthetic-purchase-token',
    sku: 'status_window_plus_01', notificationType: 1,
  }};
  const unbound = fixture();
  await reconcileNotification({...unbound.input, notification: notice});
  assert.equal(unbound.rows.size, 2);
  assert.equal(unbound.acknowledgements, 0);
  const forged = fixture();
  forged.rows.set(`purchaseAccountIds/${hash('alice')}`, {uid: 'bob'});
  await reconcileNotification({...forged.input, notification: notice});
  assert.equal(forged.rows.has('users/bob/entitlements/status_window_plus_01'), false);
  assert.equal(forged.acknowledgements, 0);
  const pending = fixture({purchaseState: 2});
  pending.rows.set(`purchaseAccountIds/${hash('alice')}`, {uid: 'alice'});
  await reconcileNotification({...pending.input, notification: notice});
  assert.equal(pending.rows.has('users/alice/entitlements/status_window_plus_01'), false);
});

test('a refund before token claim leaves a tombstone and blocks stale purchase events', async () => {
  const f = fixture();
  const token = f.input.data.purchaseToken;
  await reconcileNotification({...f.input, notification: {packageName: PACKAGE_NAME,
    voidedPurchaseNotification: {purchaseToken: token, productType: 2, refundType: 1}}});
  assert.deepEqual(f.rows.get(`purchaseTokens/${hash(token)}`), {state: 'revoked', verifiedAt: 123});
  assert.deepEqual(await verifyAndGrant({...f.input, data: {...f.input.data,
    productId: 'status_window_plus_01'}}), {isValid: false});
  f.rows.set(`purchaseAccountIds/${hash('alice')}`, {uid: 'alice'});
  await reconcileNotification({...f.input, notification: {packageName: PACKAGE_NAME,
    oneTimeProductNotification: {purchaseToken: token, sku: 'status_window_plus_01',
      notificationType: 1}}});
  assert.equal(f.rows.has('users/alice/entitlements/status_window_plus_01'), false);
  assert.equal(f.acknowledgements, 0);
  assert.equal(f.jobs.length, 0);
});

test('a canceled pending RTDN cannot become a grant through a stale Purchased lookup', async () => {
  const f = fixture();
  const token = f.input.data.purchaseToken;
  f.rows.set(`purchaseAccountIds/${hash('alice')}`, {uid: 'alice'});
  await reconcileNotification({...f.input, notification: {packageName: PACKAGE_NAME,
    oneTimeProductNotification: {purchaseToken: token,
      sku: 'status_window_plus_01', notificationType: 2}}});
  assert.equal(f.rows.get(`purchaseTokens/${hash(token)}`).state, 'revoked');
  await reconcileNotification({...f.input, notification: {packageName: PACKAGE_NAME,
    oneTimeProductNotification: {purchaseToken: token,
      sku: 'status_window_plus_01', notificationType: 1}}});
  assert.deepEqual(await verifyAndGrant({...f.input, data: {...f.input.data,
    productId: 'status_window_plus_01'}}), {isValid: false});
  assert.equal(f.rows.has('users/alice/entitlements/status_window_plus_01'), false);
  assert.equal(f.acknowledgements, 0);
});

test('a cancellation for a different SKU cannot revoke an existing token', async () => {
  const f = fixture();
  f.input.data.productId = 'status_window_plus_01';
  await verifyAndGrant(f.input);
  await reconcileNotification({...f.input, notification: {packageName: PACKAGE_NAME,
    oneTimeProductNotification: {purchaseToken: f.input.data.purchaseToken,
      sku: 'story_tide_postoffice_01', notificationType: 2}}});
  assert.equal(f.rows.get('users/alice/entitlements/status_window_plus_01').active, true);
  assert.equal(f.rows.get(`purchaseTokens/${hash(f.input.data.purchaseToken)}`).state, 'purchased');
});

test('refund racing after Play get but before grant wins transactionally', async () => {
  const f = fixture();
  f.input.data.productId = 'status_window_plus_01';
  let reachedQueue;
  const queued = new Promise(resolve => {reachedQueue = resolve;});
  let releaseQueue;
  const holdQueue = new Promise(resolve => {releaseQueue = resolve;});
  const verification = verifyAndGrant({...f.input, enqueueAcknowledgement: async () => {
    reachedQueue();
    await holdQueue;
  }});
  await queued; // Play returned Purchased; pre-read still saw no token.
  await reconcileNotification({...f.input, notification: {packageName: PACKAGE_NAME,
    voidedPurchaseNotification: {purchaseToken: f.input.data.purchaseToken,
      productType: 2, refundType: 1}}});
  releaseQueue();
  assert.deepEqual(await verification, {isValid: false});
  assert.equal(f.rows.has('users/alice/entitlements/status_window_plus_01'), false);
  assert.equal(f.acknowledgements, 0);
});

test('account deletion after callable account check still blocks the transactional grant', async () => {
  const f = fixture();
  f.rows.set(`purchaseAccountIds/${hash('alice')}`, {uid: 'alice'});
  await requirePurchaseAccount({...f.input, provider: 'google.com'});
  f.rows.set('users/alice', {deletionPending: true});
  await assert.rejects(verifyAndGrant(f.input), {code: 'failed-precondition'});
  assert.equal(f.rows.has('users/alice/entitlements/cosmetic_theme_neon'), false);
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


test('Tide pack grants one durable bundle and a refund revokes the same bundle', async () => {
  const f = fixture();
  f.input.data.productId = 'story_tide_postoffice_01';
  const result = await verifyAndGrant(f.input);
  assert.deepEqual(result, {isValid: true, entitlementId: 'story_tide_postoffice_01'});
  const path = 'users/alice/entitlements/story_tide_postoffice_01';
  assert.equal(f.rows.get(path).active, true);
  assert.equal(f.rows.size, 4); // One user grant and one token binding, no stat rewards.
  f.current.purchaseState = 1;
  await reconcileNotification({...f.input, notification: {
    packageName: PACKAGE_NAME,
    oneTimeProductNotification: {purchaseToken: f.input.data.purchaseToken},
  }});
  assert.equal(f.rows.get(path).active, false);
});
