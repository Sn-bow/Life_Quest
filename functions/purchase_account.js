'use strict';
const {hash} = require('./purchase_policy');

class PurchaseAccountError extends Error {
  constructor(code, message) { super(message); this.code = code; }
}

async function requireGoogleIdentity({uid, provider, loadAuthUser}) {
  if (typeof uid !== 'string' || !uid || uid.includes('/') ||
      !['google.com', 'password'].includes(provider)) {
    throw new PurchaseAccountError('unauthenticated', 'A linked Google purchase account is required.');
  }
  if (provider === 'google.com') return;
  // A password user may link Google to the SAME Firebase UID and later sign
  // in with either method. The signed ID token identifies the UID; Admin Auth
  // confirms the Google provider is still linked on the server.
  let user;
  try { user = await loadAuthUser?.(uid); } catch (_) {
    throw new PurchaseAccountError('unauthenticated', 'The purchase identity could not be verified.');
  }
  if (user?.uid !== uid || !user.providerData?.some(p => p.providerId === 'google.com')) {
    throw new PurchaseAccountError('unauthenticated', 'Link Google to this account before purchasing.');
  }
}

/** Check the callable's authenticated Google identity before any Play lookup.
 * The mapping is server-only. Deletion blocks both this check and the later
 * transactional grant, including when deletion races with Google API I/O.
 */
async function requirePurchaseAccount({uid, provider, db, loadAuthUser}) {
  await requireGoogleIdentity({uid, provider, loadAuthUser});
  const [user, deletion, identity] = await Promise.all([
    db.collection('users').doc(uid).get(),
    db.collection('accountDeletions').doc(uid).get(),
    db.collection('purchaseAccountIds').doc(hash(uid)).get(),
  ]);
  if (!user.exists || user.data()?.deletionPending === true || deletion.exists ||
      !identity.exists || identity.data()?.uid !== uid) {
    throw new PurchaseAccountError('failed-precondition', 'The purchase account is not ready.');
  }
}

// Authentication is enough for purchases. Never accept a device profile, goal,
// name, email or personalization history as a callable argument.
async function ensurePurchaseAccount({uid, provider, db, timestamp, loadAuthUser}) {
  await requireGoogleIdentity({uid, provider, loadAuthUser});
  const user = db.collection('users').doc(uid);
  const deletion = db.collection('accountDeletions').doc(uid);
  // Play RTDN carries the account hash, not the Firebase UID. Keep this
  // server-only lookup so a purchase can be acknowledged if the app exits
  // before its verification callback runs. Account deletion removes it.
  const playIdentity = db.collection('purchaseAccountIds').doc(hash(uid));
  await db.runTransaction(async tx => {
    const [existing, job, identity] = await Promise.all([
      tx.get(user), tx.get(deletion), tx.get(playIdentity),
    ]);
    if (job.exists || existing.data()?.deletionPending === true) {
      throw new PurchaseAccountError('failed-precondition', 'Account deletion has been requested.');
    }
    if (identity.exists && identity.data()?.uid !== uid) {
      throw new PurchaseAccountError('failed-precondition', 'The purchase identity is unavailable.');
    }
    // Existing legacy cloud profiles are neither copied nor overwritten.
    if (!existing.exists) tx.set(user, {accountKind: 'purchaseOnly', createdAt: timestamp()});
    if (!identity.exists) tx.set(playIdentity, {uid, createdAt: timestamp()});
  });
  return {ready: true};
}

module.exports = {PurchaseAccountError, ensurePurchaseAccount, requirePurchaseAccount};
