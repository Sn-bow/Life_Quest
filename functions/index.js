'use strict';
const {onCall, HttpsError} = require('firebase-functions/v2/https');
const {onMessagePublished} = require('firebase-functions/v2/pubsub');
const {onDocumentCreated} = require('firebase-functions/v2/firestore');
const {onTaskDispatched} = require('firebase-functions/v2/tasks');
const {onSchedule} = require('firebase-functions/v2/scheduler');
const {google} = require('googleapis');
const {initializeApp, getApp} = require('firebase-admin/app');
const {getFirestore, FieldValue} = require('firebase-admin/firestore');
const {getAuth} = require('firebase-admin/auth');
const {getStorage} = require('firebase-admin/storage');
const {getFunctions} = require('firebase-admin/functions');
const {AccountDeletionError, requestDeletion, completeDeletion, requestAnonymousReportDeletion} = require('./account_deletion');
const {PurchasePolicyError, verifyAndGrant, retryPurchaseAcknowledgement,
  reconcileNotification, readPlayNotification} = require('./purchase_policy');
const {PurchaseAccountError, ensurePurchaseAccount, requirePurchaseAccount} = require('./purchase_account');
const {AiReportError, submitAiReport} = require('./ai_reports');
const {reconcileVoidedPurchases} = require('./voided_purchases');
initializeApp();
// Application Default Credentials: grant the runtime service account access in
// Play Console. Never download or embed a service-account private JSON key.
const auth = new google.auth.GoogleAuth({scopes: ['https://www.googleapis.com/auth/androidpublisher']});
const publisher = google.androidpublisher({version: 'v3', auth});
const dependencies = {publisher, db: getFirestore(), timestamp: () => FieldValue.serverTimestamp()};
const enqueuePlayAcknowledgement = job => getFunctions().taskQueue('acknowledgePlayPurchase')
  .enqueue(job, {scheduleDelaySeconds: 60, dispatchDeadlineSeconds: 60});

exports.submitAiReport = onCall({enforceAppCheck: true, maxInstances: 2,
  timeoutSeconds: 30, memory: '256MiB'}, async request => {
  try {
    return await submitAiReport({uid: request.auth?.uid, data: request.data,
      nowMillis: Date.now(), ...dependencies});
  } catch (error) {
    if (error instanceof AiReportError) throw new HttpsError(error.code, error.message);
    // Reviewed output may contain personal information; never log it.
    throw new HttpsError('unavailable', 'Report receipt could not be confirmed. Please try again.');
  }
});

exports.ensurePurchaseAccount = onCall({enforceAppCheck: true, maxInstances: 2,
  timeoutSeconds: 30, memory: '256MiB'}, async request => {
  try {
    return await ensurePurchaseAccount({uid: request.auth?.uid,
      provider: request.auth?.token?.firebase?.sign_in_provider,
      loadAuthUser: uid => getAuth().getUser(uid), ...dependencies});
  } catch (error) {
    if (error instanceof PurchaseAccountError) throw new HttpsError(error.code, error.message);
    throw new HttpsError('unavailable', 'The purchase account could not be prepared. Please try again.');
  }
});

exports.verifyPurchase = onCall({enforceAppCheck: true, maxInstances: 3, timeoutSeconds: 30, memory: '256MiB'}, async request => {
  if (!request.auth) throw new HttpsError('unauthenticated', 'Sign in to verify purchases.');
  try {
    await requirePurchaseAccount({uid: request.auth.uid,
      provider: request.auth.token?.firebase?.sign_in_provider,
      db: dependencies.db, loadAuthUser: uid => getAuth().getUser(uid)});
    return await verifyAndGrant({uid: request.auth.uid, data: request.data, ...dependencies,
      enqueueAcknowledgement: enqueuePlayAcknowledgement});
  } catch (error) {
    if (error instanceof PurchasePolicyError || error instanceof PurchaseAccountError) {
      throw new HttpsError(error.code, error.message);
    }
    // Raw Google errors may contain purchase tokens. Do not log them.
    const status = Number(error.code ?? error.response?.status);
    if ([400, 404, 410].includes(status)) throw new HttpsError('invalid-argument', 'Purchase could not be verified.');
    throw new HttpsError('unavailable', 'Verification is temporarily unavailable. Please restore purchases later.');
  }
});

// Cloud Tasks + runtime IAM only. Never expose the recovery handler publicly.
exports.acknowledgePlayPurchase = onTaskDispatched({invoker: 'private',
  retryConfig: {maxAttempts: 300, minBackoffSeconds: 60, maxBackoffSeconds: 600,
    maxDoublings: 4, maxRetrySeconds: 172800},
  rateLimits: {maxConcurrentDispatches: 2, maxDispatchesPerSecond: 2},
  maxInstances: 2, timeoutSeconds: 60, memory: '256MiB'}, async request => {
  await retryPurchaseAcknowledgement({uid: request.data?.uid,
    data: request.data?.data, ...dependencies});
});

// Configure Play Console RTDN to publish to this topic before enabling sales.
exports.onPlayPurchaseNotification = onMessagePublished({topic: 'lifequest-play-billing-events',
  retry: true, maxInstances: 2, timeoutSeconds: 30, memory: '256MiB'}, async event => {
  const notification = readPlayNotification(event);
  if (!notification) return;
  try {
    await reconcileNotification({notification, ...dependencies,
      enqueueAcknowledgement: enqueuePlayAcknowledgement});
  } catch (_) {
    // Google API failures can include raw purchase tokens in request URLs.
    throw new Error('Play purchase notification could not be reconciled.');
  }
});

// RTDN is the immediate path; this overlapping scan repairs missed full
// one-time refunds without retaining plaintext purchase tokens in Firestore.
exports.reconcilePlayVoidedPurchases = onSchedule({schedule: '0 3 * * *',
  timeZone: 'Etc/UTC', retryCount: 3, maxInstances: 1,
  timeoutSeconds: 300, memory: '256MiB'}, async () => {
  try {
    await reconcileVoidedPurchases({publisher, nowMillis: Date.now(), ...dependencies});
  } catch (_) {
    throw new Error('Voided purchase reconciliation failed.');
  }
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

exports.requestReportIdentityDeletion = onCall({enforceAppCheck: true, maxInstances: 2,
  timeoutSeconds: 30, memory: '256MiB'}, async request => {
  try {
    return await requestAnonymousReportDeletion({uid: request.auth?.uid,
      provider: request.auth?.token?.firebase?.sign_in_provider,
      loadAuthUser: uid => getAuth().getUser(uid),
      nowMillis: Date.now(), ...dependencies});
  } catch (error) {
    if (error instanceof AccountDeletionError) throw new HttpsError(error.code, error.message);
    throw new HttpsError('unavailable', 'The deletion request could not be saved. Please try again.');
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
