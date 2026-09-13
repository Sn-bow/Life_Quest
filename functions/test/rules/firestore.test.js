'use strict';
const {test, before, after, beforeEach} = require('node:test');
const {readFileSync} = require('node:fs');
const {initializeTestEnvironment, assertFails, assertSucceeds} = require('@firebase/rules-unit-testing');
const {doc, setDoc, getDoc, updateDoc, deleteDoc, serverTimestamp} = require('firebase/firestore');
let env;
before(async () => {
  if (!process.env.FIRESTORE_EMULATOR_HOST?.startsWith('127.0.0.1:')) throw Error('Local emulator required.');
  env = await initializeTestEnvironment({projectId: 'demo-lifequest-rules', firestore: {
    host: '127.0.0.1', port: 8080, rules: readFileSync('../firestore.rules', 'utf8'),
  }});
});
beforeEach(async () => env.clearFirestore());
after(async () => env?.cleanup());
const owner = () => env.authenticatedContext('alice').firestore();
const other = () => env.authenticatedContext('bob').firestore();
const payload = () => ({schema: 1, model: 'gemma-4-e2b', title: '한 쪽 읽기', instruction: '편한 책 한 쪽을 읽어요.', reason: '작게 시작해요.', locale: 'ko', reportedAt: serverTimestamp()});

test('private progress is restricted to its owner, with valid progress on create/update', async () => {
  const a = owner(); const path = 'users/alice';
  await assertFails(setDoc(doc(env.unauthenticatedContext().firestore(), path), {character: {gold: 0, level: 1}}));
  await assertFails(setDoc(doc(a, path), {character: {gold: -1, level: 1}}));
  await assertSucceeds(setDoc(doc(a, path), {character: {gold: 0, level: 1}}));
  await assertFails(getDoc(doc(other(), path)));
  await assertFails(updateDoc(doc(a, path), {'character.level': 0}));
  await assertFails(deleteDoc(doc(a, path)));
});
test('AI reports permit only reviewed fields, server time and supported locale', async () => {
  const report = doc(owner(), 'users/alice/aiReports/report');
  await assertSucceeds(setDoc(report, payload()));
  await assertFails(updateDoc(report, {title: 'edited'}));
  await assertFails(getDoc(doc(other(), report.path)));
  await assertSucceeds(deleteDoc(report));
  for (const invalid of [{...payload(), goal: 'must not be sent'}, {...payload(), title: ''},
    {...payload(), locale: 'unknown'}, {...payload(), instruction: 'x'.repeat(400)}, {...payload(), reportedAt: new Date(0)}]) {
    await assertFails(setDoc(report, invalid));
  }
});
test('anonymous report identity can submit its own reviewed report only', async () => {
  const anon = env.authenticatedContext('report-only', {firebase: {sign_in_provider: 'anonymous'}}).firestore();
  await assertSucceeds(setDoc(doc(anon, 'users/report-only/aiReports/r'), payload()));
  await assertFails(setDoc(doc(anon, 'users/alice/aiReports/r'), payload()));
});
test('paid rights cannot be forged or modified by the client', async () => {
  const path = 'users/alice/entitlements/cosmetic_theme_neon';
  await assertFails(setDoc(doc(owner(), path), {active: true}));
  await env.withSecurityRulesDisabled(async c => setDoc(doc(c.firestore(), path), {active: true}));
  await assertSucceeds(getDoc(doc(owner(), path)));
  await assertFails(getDoc(doc(other(), path)));
  await assertFails(updateDoc(doc(owner(), path), {active: false}));
  await assertFails(deleteDoc(doc(owner(), path)));
});
test('purchase-token ledger is inaccessible even to authenticated clients', async () => {
  const path = 'purchaseTokens/synthetic-token-hash';
  await assertFails(setDoc(doc(owner(), path), {uid: 'alice'}));
  await env.withSecurityRulesDisabled(async c => setDoc(doc(c.firestore(), path), {uid: 'alice'}));
  await assertFails(getDoc(doc(owner(), path)));
  await assertFails(deleteDoc(doc(owner(), path)));
});

test('a deletion request prevents recreation, new reports and forged cancellation', async () => {
  const a = owner();
  await assertFails(setDoc(doc(a, 'accountDeletions/alice'), {state: 'pending'}));
  await assertFails(setDoc(doc(a, 'users/alice'), {deletionPending: true}));
  await env.withSecurityRulesDisabled(async c => {
    await setDoc(doc(c.firestore(), 'accountDeletions/alice'), {state: 'pending'});
    await setDoc(doc(c.firestore(), 'users/alice'), {deletionPending: true});
  });
  await assertFails(updateDoc(doc(a, 'users/alice'), {deletionPending: false}));
  await assertFails(setDoc(doc(a, 'users/alice'), {character: {gold: 0, level: 1}}));
  await assertFails(setDoc(doc(a, 'users/alice/aiReports/r'), payload()));
  await assertFails(setDoc(doc(a, 'users/alice/_meta/new'), {value: 1}));
  await assertFails(deleteDoc(doc(a, 'accountDeletions/alice')));
  await env.withSecurityRulesDisabled(async c => deleteDoc(doc(c.firestore(), 'users/alice')));
  await assertFails(setDoc(doc(a, 'users/alice'), {character: {gold: 0, level: 1}}));
});
