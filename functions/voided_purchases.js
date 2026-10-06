'use strict';
const {PACKAGE_NAME, reconcileNotification} = require('./purchase_policy');

const LOOKBACK_DAYS = 28;
const MAX_PAGES = 20;

/** The Play API only exposes voids from the past 30 days. Re-read an
 * overlapping 28-day window daily so a missed RTDN or a short scheduler
 * outage cannot leave a refunded one-time entitlement active forever.
 * No raw token is stored: reconcileNotification hashes it before lookup.
 */
async function reconcileVoidedPurchases({publisher, nowMillis, db, timestamp}) {
  if (!Number.isFinite(nowMillis) || nowMillis <= 0) {
    throw new Error('A valid scan time is required.');
  }
  const seen = new Set();
  let pageToken;
  let count = 0;
  for (let page = 0; page < MAX_PAGES; page++) {
    const {data} = await publisher.purchases.voidedpurchases.list({
      packageName: PACKAGE_NAME,
      startTime: String(nowMillis - LOOKBACK_DAYS * 24 * 60 * 60 * 1000),
      type: 0, // In-app products only; this app sells no subscriptions.
      includeQuantityBasedPartialRefund: false,
      maxResults: 1000,
      ...(pageToken ? {token: pageToken} : {}),
    });
    for (const purchase of data?.voidedPurchases ?? []) {
      const token = purchase?.purchaseToken;
      if (typeof token !== 'string' || token.length < 16 || token.length > 4096 ||
          purchase.voidedQuantity != null || seen.has(token)) continue;
      seen.add(token);
      await reconcileNotification({notification: {packageName: PACKAGE_NAME,
        voidedPurchaseNotification: {purchaseToken: token, productType: 2, refundType: 1}},
      db, timestamp});
      count++;
    }
    pageToken = data?.tokenPagination?.nextPageToken;
    if (!pageToken) return {reconciled: count};
  }
  // A truncated run must fail visibly; do not claim the entire scan succeeded.
  throw new Error('Voided purchase reconciliation exceeded its page limit.');
}

module.exports = {LOOKBACK_DAYS, MAX_PAGES, reconcileVoidedPurchases};
