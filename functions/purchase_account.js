'use strict';

class PurchaseAccountError extends Error {
  constructor(code, message) { super(message); this.code = code; }
}

// Authentication is enough for purchases. Never accept a device profile, goal,
// name, email or personalization history as a callable argument.
async function ensurePurchaseAccount({uid, provider, db, timestamp}) {
  if (typeof uid !== 'string' || !uid || uid.includes('/') || provider !== 'google.com') {
    throw new PurchaseAccountError('unauthenticated', 'A Google purchase account is required.');
  }
  const user = db.collection('users').doc(uid);
  const deletion = db.collection('accountDeletions').doc(uid);
  await db.runTransaction(async tx => {
    const [existing, job] = await Promise.all([tx.get(user), tx.get(deletion)]);
    if (job.exists || existing.data()?.deletionPending === true) {
      throw new PurchaseAccountError('failed-precondition', 'Account deletion has been requested.');
    }
    // Existing legacy cloud profiles are neither copied nor overwritten.
    if (!existing.exists) tx.set(user, {accountKind: 'purchaseOnly', createdAt: timestamp()});
  });
  return {ready: true};
}

module.exports = {PurchaseAccountError, ensurePurchaseAccount};
