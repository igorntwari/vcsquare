#!/usr/bin/env node
// Seeds the fixed collections: categories, pickupHubs, officialHandles and
// communities, from the JSON files in ./data.
//
// Emulator (default, safe):
//   firebase emulators:start          # in another terminal, from the repo root
//   npm run seed                      # from tool/seed
//
// Live project (needs a service account key; ask the project owner):
//   GOOGLE_APPLICATION_CREDENTIALS=/path/to/key.json npm run seed -- --live
//
// Documents are upserted by id, so running it twice is safe. Documents that
// are not in the JSON files are left alone.
import { readFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

import { applicationDefault, initializeApp } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';

const PROJECT_ID = 'vcsquared-131f0';
const EMULATOR_HOST = '127.0.0.1:8080'; // firebase.json -> emulators.firestore
const COLLECTIONS = ['categories', 'pickupHubs', 'officialHandles', 'communities'];

const live = process.argv.includes('--live');
const here = dirname(fileURLToPath(import.meta.url));

if (live) {
  if (!process.env.GOOGLE_APPLICATION_CREDENTIALS) {
    console.error(
      'Refusing to seed the live project without GOOGLE_APPLICATION_CREDENTIALS.\n' +
        'Download a service account key from Firebase Console -> Project settings ->\n' +
        'Service accounts, and never commit it.',
    );
    process.exit(1);
  }
  delete process.env.FIRESTORE_EMULATOR_HOST;
  initializeApp({ credential: applicationDefault(), projectId: PROJECT_ID });
  console.log(`Seeding LIVE project ${PROJECT_ID}`);
} else {
  process.env.FIRESTORE_EMULATOR_HOST ??= EMULATOR_HOST;
  initializeApp({ projectId: PROJECT_ID });
  console.log(`Seeding emulator at ${process.env.FIRESTORE_EMULATOR_HOST}`);
}

const db = getFirestore();

for (const collection of COLLECTIONS) {
  const docs = JSON.parse(readFileSync(join(here, 'data', `${collection}.json`), 'utf8'));
  const batch = db.batch();
  for (const [id, data] of Object.entries(docs)) {
    batch.set(db.collection(collection).doc(id), data);
  }
  await batch.commit();
  console.log(`  ${collection}: ${Object.keys(docs).length} documents`);
}

console.log('Done.');
