'use strict';
const {test, before, beforeEach, after} = require('node:test');
const {readFileSync} = require('node:fs');
const {initializeTestEnvironment, assertFails, assertSucceeds} = require('@firebase/rules-unit-testing');
const {ref, uploadBytes, getBytes, deleteObject} = require('firebase/storage');
const {doc, setDoc} = require('firebase/firestore');
let env;
before(async () => {
  if (!process.env.FIRESTORE_EMULATOR_HOST?.startsWith('127.0.0.1:') ||
      !process.env.FIREBASE_STORAGE_EMULATOR_HOST?.startsWith('127.0.0.1:')) {
    throw Error('Local Firestore and Storage emulators required.');
  }
  env = await initializeTestEnvironment({projectId: 'demo-lifequest-rules',
    firestore: {host: '127.0.0.1', port: 8080, rules: readFileSync('../firestore.rules', 'utf8')},
    storage: {host: '127.0.0.1', port: 9199, rules: readFileSync('../storage.rules', 'utf8')},
  });
});
beforeEach(async () => {await env.clearFirestore(); await env.clearStorage();});
after(async () => env?.cleanup());
const file = uid => ref(env.authenticatedContext(uid).storage(), 'users/alice/profile.jpg');
const image = () => new Uint8Array([137, 80, 78, 71]); // Synthetic rules input only.
test('profile files are private, size limited, and restricted to images', async () => {
  await assertSucceeds(uploadBytes(file('alice'), image(), {contentType: 'image/png'}));
  await assertSucceeds(getBytes(file('alice')));
  await assertFails(getBytes(file('bob')));
  await assertFails(uploadBytes(file('bob'), image(), {contentType: 'image/png'}));
  await assertFails(uploadBytes(file('alice'), image(), {contentType: 'text/plain'}));
  await assertFails(uploadBytes(file('alice'), new Uint8Array(2 * 1024 * 1024), {contentType: 'image/png'}));
});
test('deletion tombstone blocks old tokens from uploading files again', async () => {
  await assertSucceeds(uploadBytes(file('alice'), image(), {contentType: 'image/png'}));
  await env.withSecurityRulesDisabled(c => setDoc(doc(c.firestore(), 'accountDeletions/alice'), {state: 'pending'}));
  await assertFails(uploadBytes(file('alice'), image(), {contentType: 'image/png'}));
  await assertFails(getBytes(file('alice')));
  await assertFails(deleteObject(file('alice'))); // Admin cleanup owns this stage.
});
