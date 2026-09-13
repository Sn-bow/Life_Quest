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
});
const hash = value => createHash('sha256').update(value).digest('hex');
class PurchasePolicyError extends Error {
  constructor(code, message) { super(message); this.code = code; }
}
function validateRequest(data) {
  if (!data || typeof data !== 'object' || data.packageName !== PACKAGE_NAME ||
      !Object.hasOwn(PRODUCTS, data.productId) || typeof data.purchaseToken !== 'string' ||
      data.purchaseToken.length < 16 || data.purchaseToken.length > 4096) {
    throw new PurchasePolicyError('invalid-argument', 'Invalid product or purchase.');
  }
  return {productId: data.productId, token: data.purchaseToken};
}

/** Validates with Google first, atomically binds the token and grants once.
 * Acknowledgement happens only after the durable grant. No token/receipt logs.
 * Publisher/db/time are injected so adversarial and interrupted cases are testable.
 */
async function verifyAndGrant({uid, data, publisher, db, timestamp}) {
  if (!uid) throw new PurchasePolicyError('unauthenticated', 'Sign in to verify purchases.');
  const {productId, token} = validateRequest(data);
  const {data: receipt} = await publisher.purchases.products.get({packageName: PACKAGE_NAME, productId, token});
  if (receipt.purchaseState !== 0) return {isValid: false}; // Never grant pending/cancelled purchases.
  if (receipt.obfuscatedExternalAccountId !== hash(uid)) {
    throw new PurchasePolicyError('permission-denied', 'This purchase belongs to another app account.');
  }
  if (receipt.consumptionState === 1 || (receipt.quantity != null && receipt.quantity !== 1)) {
    throw new PurchasePolicyError('failed-precondition', 'Unsupported purchase state.');
  }
  const key = hash(token);
  const tokenRef = db.collection('purchaseTokens').doc(key);
  const userRef = db.collection('users').doc(uid);
  const grantRef = userRef.collection('entitlements').doc(productId);
  await db.runTransaction(async tx => {
    const userDoc = await tx.get(userRef);
    if (!userDoc.exists || userDoc.data().deletionPending === true) {
      throw new PurchasePolicyError('failed-precondition', 'This app account is not available for purchases.');
    }
    const tokenDoc = await tx.get(tokenRef);
    const grantDoc = await tx.get(grantRef);
    const previous = tokenDoc.data();
    if (previous && (previous.uid !== uid || previous.productId !== productId)) {
      throw new PurchasePolicyError('permission-denied', 'Purchase token is already bound.');
    }
    tx.set(tokenRef, {uid, productId, purchaseKey: key, state: 'purchased', verifiedAt: timestamp()}, {merge: true});
    tx.set(grantRef, {productId, entitlementId: PRODUCTS[productId], active: true,
      source: 'google_play', purchaseKey: key, verifiedAt: timestamp(),
      ...(!grantDoc.exists ? {grantedAt: timestamp()} : {})}, {merge: true});
  });
  // Retry is safe if this call or the response is interrupted. The entitlement
  // already exists and the next verification cannot grant any consumable reward.
  if (receipt.acknowledgementState !== 1) {
    await publisher.purchases.products.acknowledge({packageName: PACKAGE_NAME, productId, token, requestBody: {}});
  }
  return {isValid: true, entitlementId: PRODUCTS[productId]};
}

/** Process only authenticated Play RTDN deliveries from the configured topic. */
async function reconcileNotification({notification, publisher, db, timestamp}) {
  if (notification?.packageName !== PACKAGE_NAME) return;
  const event = notification.oneTimeProductNotification ?? notification.voidedPurchaseNotification;
  if (!event || typeof event.purchaseToken !== 'string') return;
  const key = hash(event.purchaseToken);
  const tokenRef = db.collection('purchaseTokens').doc(key);
  const tokenDoc = await tokenRef.get();
  if (!tokenDoc.exists) return; // It has not been claimed by this app.
  const owner = tokenDoc.data();
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
  const grantRef = db.collection('users').doc(owner.uid).collection('entitlements').doc(owner.productId);
  await db.runTransaction(async tx => {
    const grant = await tx.get(grantRef);
    // An older revoked purchase must not revoke a later replacement purchase.
    if (grant.exists && grant.data().purchaseKey === key) {
      tx.update(grantRef, {active: receipt.purchaseState === 0, verifiedAt: timestamp()});
    }
    tx.update(tokenRef, {state: receipt.purchaseState === 0 ? 'purchased' : 'revoked', verifiedAt: timestamp()});
  });
}
module.exports = {PACKAGE_NAME, PRODUCTS, PurchasePolicyError, hash, validateRequest, verifyAndGrant, reconcileNotification};
