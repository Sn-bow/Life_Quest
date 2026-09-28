'use strict';
const {createHash} = require('node:crypto');
const PACKAGE_NAME = 'com.lifequest.app';
const PRODUCTS = Object.freeze({
  remove_ads_4900: 'remove_ads',
  cosmetic_theme_neon: 'theme_neon_cyberpunk',
  cosmetic_theme_gold: 'theme_royal_gold',
  cosmetic_title_fire: 'title_effect_fire',
  cosmetic_title_sparkle: 'title_effect_sparkle',
  cosmetic_combat_lightning: 'combat_effect_lightning',
  story_neon_archive_01: 'story_neon_archive_01',
  story_tide_postoffice_01: 'story_tide_postoffice_01',
  status_window_plus_01: 'status_window_plus_01',
});
const hash = value => createHash('sha256').update(value).digest('hex');
class PurchasePolicyError extends Error {
  constructor(code, message) { super(message); this.code = code; }
}
function readPlayNotification(event) {
  try {
    const notification = event?.data?.message?.json;
    return notification && typeof notification === 'object' &&
      !Array.isArray(notification) ? notification : null;
  } catch (_) {
    // A malformed Pub/Sub body can make the Firebase JSON getter throw.
    // It is not a Play event and must not leak its body into function logs.
    return null;
  }
}
function validateRequest(data) {
  if (!data || typeof data !== 'object' || data.packageName !== PACKAGE_NAME ||
      !Object.hasOwn(PRODUCTS, data.productId) || typeof data.purchaseToken !== 'string' ||
      data.purchaseToken.length < 16 || data.purchaseToken.length > 4096) {
    throw new PurchasePolicyError('invalid-argument', 'Invalid product or purchase.');
  }
  return {productId: data.productId, token: data.purchaseToken};
}

/** Validates with Google first, durably queues recovery, then grants once.
 * Acknowledgement happens only after the durable grant. No token/receipt logs.
 * Publisher/db/time are injected so adversarial and interrupted cases are testable.
 */
async function verifyAndGrant({uid, data, publisher, db, timestamp,
  enqueueAcknowledgement, acknowledgementTask = false}) {
  if (!uid) throw new PurchasePolicyError('unauthenticated', 'Sign in to verify purchases.');
  const {productId, token} = validateRequest(data);
  const {data: receipt} = await publisher.purchases.products.get({packageName: PACKAGE_NAME, productId, token});
  if (receipt.productId != null && receipt.productId !== productId) {
    throw new PurchasePolicyError('failed-precondition', 'The Play product does not match.');
  }
  if (receipt.purchaseState !== 0) return {isValid: false}; // Never grant pending/cancelled purchases.
  if (receipt.obfuscatedExternalAccountId !== hash(uid)) {
    throw new PurchasePolicyError('permission-denied', 'This purchase belongs to another app account.');
  }
  if (receipt.consumptionState === 1 || (receipt.quantity != null && receipt.quantity !== 1)) {
    throw new PurchasePolicyError('failed-precondition', 'Unsupported purchase state.');
  }
  const key = hash(token);
  const tokenRef = db.collection('purchaseTokens').doc(key);
  // A Play API response can lag a voided-purchase notification. A token
  // already revoked by that notification must never grant access again.
  const tokenSnapshot = await tokenRef.get();
  if (tokenSnapshot.exists && tokenSnapshot.data().state === 'revoked') {
    return {isValid: false};
  }
  // Queue before committing: a process crash after the grant cannot leave a
  // paid purchase dependent on the app reopening. Failure here grants nothing.
  if (receipt.acknowledgementState !== 1 && !acknowledgementTask) {
    await enqueueAcknowledgement({uid, data: {packageName: PACKAGE_NAME,
      productId, purchaseToken: token}});
  }
  const userRef = db.collection('users').doc(uid);
  const grantRef = userRef.collection('entitlements').doc(productId);
  const granted = await db.runTransaction(async tx => {
    const userDoc = await tx.get(userRef);
    if (!userDoc.exists || userDoc.data().deletionPending === true) {
      throw new PurchasePolicyError('failed-precondition', 'This app account is not available for purchases.');
    }
    const tokenDoc = await tx.get(tokenRef);
    const grantDoc = await tx.get(grantRef);
    const previous = tokenDoc.data();
    if (previous?.state === 'revoked') return false;
    if (previous && (previous.uid !== uid || previous.productId !== productId)) {
      throw new PurchasePolicyError('permission-denied', 'Purchase token is already bound.');
    }
    tx.set(tokenRef, {uid, productId, purchaseKey: key, state: 'purchased', verifiedAt: timestamp()}, {merge: true});
    // A delayed worker for an older token must preserve a replacement grant.
    if (!acknowledgementTask || !grantDoc.exists || grantDoc.data().purchaseKey === key) {
      tx.set(grantRef, {productId, entitlementId: PRODUCTS[productId], active: true,
        source: 'google_play', purchaseKey: key, verifiedAt: timestamp(),
        ...(!grantDoc.exists ? {grantedAt: timestamp()} : {})}, {merge: true});
    }
    return true;
  });
  if (!granted) return {isValid: false};
  // The private task owns retries even if the app exits or this response is lost.
  if (receipt.acknowledgementState !== 1) {
    try {
      await publisher.purchases.products.acknowledge({packageName: PACKAGE_NAME, productId, token, requestBody: {}});
    } catch (error) {
      if (acknowledgementTask) throw error;
    }
  }
  return {isValid: true, entitlementId: PRODUCTS[productId]};
}

/** Only an IAM-protected task handler may invoke this mode. Revalidate every
 * attempt; retries never recursively enqueue or award consumable rewards. */
async function retryPurchaseAcknowledgement(dependencies) {
  const revokeIfClaimed = () => reconcileNotification({...dependencies,
    notification: {packageName: PACKAGE_NAME,
      oneTimeProductNotification: {purchaseToken: dependencies.data?.purchaseToken}}});
  try {
    const result = await verifyAndGrant({...dependencies, acknowledgementTask: true});
    if (!result.isValid) await revokeIfClaimed();
    return result;
  } catch (error) {
    if (error instanceof PurchasePolicyError) return {isValid: false};
    const status = Number(error.code ?? error.response?.status);
    if ([404, 410].includes(status)) {
      await revokeIfClaimed();
      return {isValid: false};
    }
    if (status === 400) return {isValid: false};
    // Raw publisher errors may contain purchase tokens in request URLs.
    throw new Error('Purchase acknowledgement is temporarily unavailable.');
  }
}

/** Process only authenticated Play RTDN deliveries from the configured topic. */
async function reconcileNotification({notification, publisher, db, timestamp,
  enqueueAcknowledgement}) {
  if (notification?.packageName !== PACKAGE_NAME) return;
  const voided = notification.voidedPurchaseNotification;
  // The current catalog sells single-quantity, nonconsumable Play products.
  // A full refund of a one-time product is final even when products.get still
  // briefly reports Purchased; other product/refund types are not ours.
  if (voided && (voided.productType !== 2 || voided.refundType !== 1)) return;
  const event = notification.oneTimeProductNotification ?? voided;
  if (!event || typeof event.purchaseToken !== 'string') return;
  const key = hash(event.purchaseToken);
  const tokenRef = db.collection('purchaseTokens').doc(key);
  const cancelled = !voided && event.notificationType === 2 &&
    Object.hasOwn(PRODUCTS, event.sku);
  if (!voided && event.notificationType === 2 && !cancelled) return;
  if (voided || cancelled) {
    // A full refund or canceled pending transaction can arrive before the
    // app's verification request or purchase RTDN. Record a token-hash
    // tombstone atomically, without needing a UID.
    // If a grant raced with this event, revoke that exact token in the same
    // transaction. A later Play lookup cannot clear the tombstone.
    await db.runTransaction(async tx => {
      const currentToken = await tx.get(tokenRef);
      const owner = currentToken.data();
      if (owner?.state === 'revoked') return;
      if (cancelled && owner?.productId && owner.productId !== event.sku) return;
      if (owner?.uid && owner.productId) {
        const grantRef = db.collection('users').doc(owner.uid)
          .collection('entitlements').doc(owner.productId);
        const grant = await tx.get(grantRef);
        if (grant.exists && grant.data().purchaseKey === key) {
          tx.update(grantRef, {active: false, verifiedAt: timestamp()});
        }
      }
      tx.set(tokenRef, {state: 'revoked', verifiedAt: timestamp()}, {merge: true});
    });
    return;
  }
  const tokenDoc = await tokenRef.get();
  if (!tokenDoc.exists) {
    // The app may exit just after Play completes checkout. Locate the account
    // solely through Google's validated receipt and the server-only mapping;
    // notification fields alone never authorize a new grant.
    if (event.notificationType !== 1 || !Object.hasOwn(PRODUCTS, event.sku)) return;
    const {data: receipt} = await publisher.purchases.products.get({
      packageName: PACKAGE_NAME, productId: event.sku, token: event.purchaseToken,
    });
    if ((receipt.productId != null && receipt.productId !== event.sku) ||
        receipt.purchaseState !== 0 ||
        typeof receipt.obfuscatedExternalAccountId !== 'string' ||
        !/^[a-f0-9]{64}$/.test(receipt.obfuscatedExternalAccountId)) return;
    const identity = await db.collection('purchaseAccountIds')
      .doc(receipt.obfuscatedExternalAccountId).get();
    const uid = identity.data()?.uid;
    if (!identity.exists || typeof uid !== 'string' || hash(uid) !== receipt.obfuscatedExternalAccountId) return;
    await verifyAndGrant({uid, data: {packageName: PACKAGE_NAME,
      productId: event.sku, purchaseToken: event.purchaseToken},
    publisher, db, timestamp, enqueueAcknowledgement});
    return;
  }
  const owner = tokenDoc.data();
  if (owner.state === 'revoked') return;
  let receipt;
  try {
    ({data: receipt} = await publisher.purchases.products.get({
      packageName: PACKAGE_NAME, productId: owner.productId, token: event.purchaseToken,
    }));
  } catch (error) {
    const status = Number(error.code ?? error.response?.status);
    if ([404, 410].includes(status)) receipt = {purchaseState: 1};
    else throw new Error('Purchase notification verification is temporarily unavailable.');
  }
  const active = receipt.purchaseState === 0;
  const grantRef = db.collection('users').doc(owner.uid).collection('entitlements').doc(owner.productId);
  await db.runTransaction(async tx => {
    const currentToken = await tx.get(tokenRef);
    const grant = await tx.get(grantRef);
    // An out-of-order PURCHASED notification cannot reactivate a token after
    // its refund has already been recorded.
    const remainsActive = active && currentToken.data()?.state !== 'revoked';
    // An older revoked purchase must not revoke a later replacement purchase.
    if (grant.exists && grant.data().purchaseKey === key) {
      tx.update(grantRef, {active: remainsActive, verifiedAt: timestamp()});
    }
    tx.update(tokenRef, {state: remainsActive ? 'purchased' : 'revoked', verifiedAt: timestamp()});
  });
}
module.exports = {PACKAGE_NAME, PRODUCTS, PurchasePolicyError, hash, validateRequest,
  readPlayNotification,
  verifyAndGrant, retryPurchaseAcknowledgement, reconcileNotification};
