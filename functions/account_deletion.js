'use strict';
class AccountDeletionError extends Error {
  constructor(code, message) { super(message); this.code = code; }
}

/** A durable request, independent of the app staying open or connected. */
async function requestDeletion({uid, authTime, nowMillis, db, timestamp}) {
  if (!uid || typeof uid !== 'string' || uid.includes('/')) {
    throw new AccountDeletionError('unauthenticated', 'Sign in to delete your account.');
  }
  const ageSeconds = nowMillis / 1000 - authTime;
  if (!Number.isFinite(ageSeconds) || ageSeconds < -30 || ageSeconds > 300) {
    throw new AccountDeletionError('failed-precondition', 'Sign in again before deleting your account.');
  }
  const jobRef = db.collection('accountDeletions').doc(uid);
  const userRef = db.collection('users').doc(uid);
  await db.runTransaction(async tx => {
    const previous = await tx.get(jobRef);
    if (previous.exists) return; // An interrupted response cannot create a second job.
    tx.set(jobRef, {state: 'pending', requestedAt: timestamp()});
    tx.set(userRef, {deletionPending: true}, {merge: true});
  });
  return {accepted: true};
}

/** At-least-once delivery is safe at every step. Auth is removed last.
 * No profile, receipt, email or raw token is retained in the deletion marker.
 */
async function completeDeletion({uid, db, auth, deleteFiles, timestamp, nowMillis}) {
  const jobRef = db.collection('accountDeletions').doc(uid);
  const job = await jobRef.get();
  if (!job.exists || job.data().state === 'complete') return;
  await deleteFiles(uid);
  // The deletion marker blocks client writes while this subtree is removed.
  await db.recursiveDelete(db.collection('users').doc(uid));
  const tokens = db.collection('purchaseTokens').where('uid', '==', uid).limit(100);
  while (true) {
    const page = await tokens.get();
    if (page.empty) break;
    const batch = db.batch();
    for (const doc of page.docs) batch.delete(doc.ref);
    await batch.commit();
  }
  try {
    await auth.deleteUser(uid);
  } catch (error) {
    if (error.code !== 'auth/user-not-found') throw error;
  }
  // Retain the non-content tombstone beyond the ID-token lifetime. TTL is
  // configured in firestore.indexes.json; pending jobs never expire silently.
  await jobRef.set({state: 'complete', completedAt: timestamp(),
    expiresAt: new Date(nowMillis + 7 * 24 * 60 * 60 * 1000)}, {merge: true});
}

module.exports = {AccountDeletionError, requestDeletion, completeDeletion};
