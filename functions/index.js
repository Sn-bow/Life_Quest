'use strict';
const {onCall, HttpsError} = require('firebase-functions/v2/https');
const {onMessagePublished} = require('firebase-functions/v2/pubsub');
const {onDocumentCreated} = require('firebase-functions/v2/firestore');
const {google} = require('googleapis');
const {initializeApp, getApp} = require('firebase-admin/app');
const {getFirestore, FieldValue} = require('firebase-admin/firestore');
const {getAuth} = require('firebase-admin/auth');
const {getStorage} = require('firebase-admin/storage');
const {AccountDeletionError, requestDeletion, completeDeletion} = require('./account_deletion');
const {PurchasePolicyError, verifyAndGrant, reconcileNotification} = require('./purchase_policy');
initializeApp();
// Application Default Credentials: grant the runtime service account access in
// Play Console. Never download or embed a service-account private JSON key.
const auth = new google.auth.GoogleAuth({scopes: ['https://www.googleapis.com/auth/androidpublisher']});
const publisher = google.androidpublisher({version: 'v3', auth});
const dependencies = {publisher, db: getFirestore(), timestamp: () => FieldValue.serverTimestamp()};

exports.verifyPurchase = onCall({enforceAppCheck: true, maxInstances: 3, timeoutSeconds: 30, memory: '256MiB'}, async request => {
  if (!request.auth) throw new HttpsError('unauthenticated', 'Sign in to verify purchases.');
  try {
    return await verifyAndGrant({uid: request.auth.uid, data: request.data, ...dependencies});
  } catch (error) {
    if (error instanceof PurchasePolicyError) throw new HttpsError(error.code, error.message);
    // Raw Google errors may contain purchase tokens. Do not log them.
    const status = Number(error.code ?? error.response?.status);
    if ([400, 404, 410].includes(status)) throw new HttpsError('invalid-argument', 'Purchase could not be verified.');
    throw new HttpsError('unavailable', 'Verification is temporarily unavailable. Please restore purchases later.');
  }
});

// Configure Play Console RTDN to publish to this topic before enabling sales.
exports.onPlayPurchaseNotification = onMessagePublished({topic: 'lifequest-play-billing-events',
  retry: true, maxInstances: 2, timeoutSeconds: 30, memory: '256MiB'}, async event => {
  const notification = event.data.message.json;
  await reconcileNotification({notification, ...dependencies});
});

exports.requestAccountDeletion = onCall({enforceAppCheck: true, maxInstances: 2,
  timeoutSeconds: 30, memory: '256MiB'}, async request => {
  try {
    return await requestDeletion({uid: request.auth?.uid,
      authTime: request.auth?.token?.auth_time, nowMillis: Date.now(), ...dependencies});
  } catch (error) {
    if (error instanceof AccountDeletionError) throw new HttpsError(error.code, error.message);
    throw new HttpsError('unavailable', 'The request could not be saved. Please try again.');
  }
});

exports.onAccountDeletionRequested = onDocumentCreated({document: 'accountDeletions/{uid}',
  retry: true, maxInstances: 2, timeoutSeconds: 540, memory: '256MiB'}, async event => {
  try {
    await completeDeletion({uid: event.params.uid, db: dependencies.db,
      auth: getAuth(), timestamp: dependencies.timestamp, nowMillis: Date.now(),
      deleteFiles: async uid => {
        const bucketName = getApp().options.storageBucket;
        if (!bucketName) return; // No default upload bucket was configured.
        try {
          await getStorage().bucket(bucketName).deleteFiles({prefix: `users/${uid}/`});
        } catch (error) {
          if (Number(error.code) !== 404) throw error;
        }
      },
    });
  } catch (_) {
    // Sanitized failures still trigger automatic retries. Alert on failures and
    // stale pending jobs before production; do not log account content.
    throw new Error('Account deletion is incomplete and must be retried.');
  }
});
