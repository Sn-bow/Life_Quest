'use strict';
const test = require('node:test');
const assert = require('node:assert/strict');
const {submitAiReport} = require('../ai_reports');
function fixture() {
  const rows = new Map(); let writes = 0;
  const ref = path => ({path, doc: id => ref(`${path}/${id}`), collection: id => ref(`${path}/${id}`)});
  const db = {collection: ref, runTransaction: async callback => {
    const pending = [];
    await callback({get: async r => ({exists: rows.has(r.path), data: () => rows.get(r.path)}),
      set: (r, d) => pending.push([r.path, d])});
    for (const [p, d] of pending) { rows.set(p, d); ++writes; }
  }};
  return {rows, get writes() {return writes;}, input: {uid: 'anonymous-or-google', db,
    timestamp: () => 123, nowMillis: 1800000000000,
    data: {schema: 1, model: 'gemma-4-e2b', title: '한 쪽 읽기', instruction: '책 한 쪽을 읽어요.', reason: '작은 시작', locale: 'ko'}}};
}
test('only reviewed fields are stored, with server timestamps and 90 day expiry', async () => {
  const f = fixture(); const result = await submitAiReport(f.input);
  assert.equal(result.accepted, true); assert.match(result.reportId, /^[a-f0-9]{64}$/);
  assert.equal(result.ownerUid, f.input.uid);
  const stored = f.rows.get(`users/${f.input.uid}/aiReports/${result.reportId}`);
  assert.deepEqual(Object.keys(stored).sort(), ['schema', 'model', 'title', 'instruction', 'reason', 'locale', 'reportedAt', 'expiresAt'].sort());
  assert.equal(stored.expiresAt.getTime(), f.input.nowMillis + 90 * 86400000);
  assert.equal(f.rows.has(`users/${f.input.uid}`), false);
});
test('lost-response retry preserves receipt, retention and quota, including when quota is full', async () => {
  const f = fixture(); const first = await submitAiReport(f.input);
  f.rows.set(`users/${f.input.uid}/_private/aiReportQuota`, {windowStart: f.input.nowMillis, count: 20});
  assert.deepEqual(await submitAiReport({...f.input, nowMillis: f.input.nowMillis + 1000}), first);
  assert.equal(f.writes, 2);
});
test('invalid payload, undisclosed fields, unsupported models/locales and anonymous missing auth are rejected', async () => {
  const f = fixture();
  for (const data of [null, [], {...f.input.data, goal: 'private'}, {...f.input.data, title: ' '},
    {...f.input.data, model: 'unreviewed'}, {...f.input.data, locale: 'xx'},
    {...f.input.data, instruction: '가'.repeat(81)}, {...f.input.data, reason: '😀'.repeat(61)}]) {
    await assert.rejects(submitAiReport({...f.input, data}), {code: 'invalid-argument'});
  }
  await assert.rejects(submitAiReport({...f.input, uid: undefined}), {code: 'unauthenticated'});
  assert.equal(f.writes, 0);
});
test('per-identity quota caps unique reports and resets after a day', async () => {
  const f = fixture();
  for (let i = 0; i < 20; ++i) await submitAiReport({...f.input, data: {...f.input.data, title: `Report ${i}`}});
  await assert.rejects(submitAiReport(f.input), {code: 'resource-exhausted'});
  await submitAiReport({...f.input, nowMillis: f.input.nowMillis + 86400000});
  assert.equal(f.rows.get(`users/${f.input.uid}/_private/aiReportQuota`).count, 1);
});
test('deleted or deleting identities cannot submit or recreate their records', async () => {
  for (const path of ['accountDeletions/', 'users/']) {
    const f = fixture(); f.rows.set(path + f.input.uid, {deletionPending: true});
    await assert.rejects(submitAiReport(f.input), {code: 'failed-precondition'});
    assert.equal(f.writes, 0);
  }
});
test('a failure before transaction commit cannot claim accepted receipt', async () => {
  const f = fixture(); f.input.db.runTransaction = async () => { throw Error('offline'); };
  await assert.rejects(submitAiReport(f.input)); assert.equal(f.writes, 0);
});
