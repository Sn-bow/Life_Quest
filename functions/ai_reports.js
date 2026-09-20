'use strict';
const {createHash} = require('node:crypto');
const RETENTION_DAYS = 90;
const DAY = 86400000;
class AiReportError extends Error {
  constructor(code, message) { super(message); this.code = code; }
}

async function submitAiReport({uid, data, nowMillis, db, timestamp}) {
  if (typeof uid !== 'string' || !uid || uid.includes('/')) {
    throw new AiReportError('unauthenticated', 'A report identity is required.');
  }
  const keys = ['schema', 'model', 'title', 'instruction', 'reason', 'locale'];
  const validText = (value, limit) => typeof value === 'string' && value.trim().length > 0 && [...value].length <= limit;
  if (!data || Array.isArray(data) || Object.keys(data).length !== keys.length ||
      !Object.keys(data).every(k => keys.includes(k)) || data.schema !== 1 ||
      data.model !== 'gemma-4-e2b' || !validText(data.title, 25) ||
      !validText(data.instruction, 80) || !validText(data.reason, 60) ||
      !['ko', 'en', 'ja', 'zh'].includes(data.locale)) {
    throw new AiReportError('invalid-argument', 'Only the reviewed quest text can be reported.');
  }
  const reviewed = Object.fromEntries(keys.map(k => [k, data[k]]));
  // Same identity + same reviewed output is one report, including retries after
  // a lost response. Receipt IDs do not expose the text or a plain account ID.
  const reportId = createHash('sha256').update(uid + '\n' + JSON.stringify(reviewed)).digest('hex');
  const root = db.collection('users').doc(uid);
  const report = root.collection('aiReports').doc(reportId);
  const quota = root.collection('_private').doc('aiReportQuota');
  const deletion = db.collection('accountDeletions').doc(uid);
  await db.runTransaction(async tx => {
    const [previous, limit, job, user] = await Promise.all([tx.get(report), tx.get(quota), tx.get(deletion), tx.get(root)]);
    if (job.exists || user.data()?.deletionPending === true) {
      throw new AiReportError('failed-precondition', 'Account deletion is in progress.');
    }
    if (previous.exists) return;
    const recent = limit.exists && nowMillis - limit.data().windowStart < DAY;
    const count = recent ? limit.data().count : 0;
    if (count >= 20) throw new AiReportError('resource-exhausted', 'Please try again tomorrow.');
    tx.set(report, {...reviewed, reportedAt: timestamp(), expiresAt: new Date(nowMillis + RETENTION_DAYS * DAY)});
    tx.set(quota, {windowStart: recent ? limit.data().windowStart : nowMillis, count: count + 1,
      expiresAt: new Date(nowMillis + RETENTION_DAYS * DAY)});
  });
  return {accepted: true, reportId, ownerUid: uid};
}
module.exports = {AiReportError, submitAiReport, RETENTION_DAYS};
