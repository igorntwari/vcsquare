// firestore.rules against the emulator. Run: npm install && npm test (Java 21+).
import { readFileSync } from 'node:fs';
import { after, before, beforeEach, describe, test } from 'node:test';

import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} from '@firebase/rules-unit-testing';
import {
  deleteDoc,
  doc,
  getDoc,
  increment,
  serverTimestamp,
  setDoc,
  updateDoc,
} from 'firebase/firestore';

let env;

const as = (uid, email, verified = true) =>
  env
    .authenticatedContext(uid, { email, email_verified: verified })
    .firestore();

const member = () => as('amara', 'a.kamau@alustudent.com');
const unverified = () => as('nadia', 'n.uwase@alustudent.com', false);
const outsider = () => as('eve', 'eve@gmail.com');

// Matches FirebaseAuthRepository.newUserDoc.
const newUserDoc = (email, overrides = {}) => ({
  name: 'Nadia Uwase',
  handle: '@n.uwase',
  type: 'student',
  avatarPath: null,
  cohort: null,
  isVerified: false,
  isOnline: false,
  email,
  emailDomain: '@alustudent.com',
  createdAt: serverTimestamp(),
  roleTag: '',
  campus: '',
  program: '',
  bio: '',
  ...overrides,
});

before(async () => {
  env = await initializeTestEnvironment({
    projectId: 'demo-vsquare',
    firestore: { rules: readFileSync('../../firestore.rules', 'utf8') },
  });
});

after(() => env.cleanup());

beforeEach(async () => {
  await env.clearFirestore();
  await env.withSecurityRulesDisabled(async (context) => {
    const db = context.firestore();
    await setDoc(doc(db, 'users/amara'), {
      name: 'Amara Kamau',
      handle: '@amara.builds',
      email: 'a.kamau@alustudent.com',
      followerCount: 280,
      bio: 'Hello',
    });
    await setDoc(doc(db, 'users/amara/peerSuggestions/kofi'), { mutualCount: 3 });
    await setDoc(doc(db, 'posts/p1'), { authorId: 'kofi', likeCount: 3, commentCount: 0 });
  });
});

describe('who can see anything', () => {
  test('verified ALU members read shared data', async () => {
    await assertSucceeds(getDoc(doc(member(), 'posts/p1')));
  });

  test('unverified accounts read nothing shared', async () => {
    await assertFails(getDoc(doc(unverified(), 'posts/p1')));
    await assertFails(getDoc(doc(unverified(), 'users/amara')));
  });

  test('non-ALU accounts read nothing, even when verified', async () => {
    await assertFails(getDoc(doc(outsider(), 'posts/p1')));
  });

  test('an unverified account can read its own profile', async () => {
    await env.withSecurityRulesDisabled((context) =>
      setDoc(doc(context.firestore(), 'users/nadia'), { name: 'Nadia' }),
    );
    await assertSucceeds(getDoc(doc(unverified(), 'users/nadia')));
  });
});

describe('creating a profile', () => {
  test('the owner can create it at sign-up, before verifying', async () => {
    await assertSucceeds(
      setDoc(doc(unverified(), 'users/nadia'), newUserDoc('n.uwase@alustudent.com')),
    );
  });

  test('not with someone else\'s email', async () => {
    await assertFails(
      setDoc(doc(unverified(), 'users/nadia'), newUserDoc('a.kamau@alustudent.com')),
    );
  });

  test('not pre-verified, and not with counters', async () => {
    const email = 'n.uwase@alustudent.com';
    await assertFails(
      setDoc(doc(unverified(), 'users/nadia'), newUserDoc(email, { isVerified: true })),
    );
    await assertFails(
      setDoc(doc(unverified(), 'users/nadia'), newUserDoc(email, { followerCount: 999 })),
    );
  });

  test('not for another uid, and not for non-ALU emails', async () => {
    await assertFails(
      setDoc(doc(unverified(), 'users/someone'), newUserDoc('n.uwase@alustudent.com')),
    );
    await assertFails(
      setDoc(doc(outsider(), 'users/eve'), newUserDoc('eve@gmail.com')),
    );
  });
});

describe('editing a profile', () => {
  test('the owner can edit their own fields', async () => {
    await assertSucceeds(
      updateDoc(doc(member(), 'users/amara'), { bio: 'New bio', handle: '@amara.k' }),
    );
  });

  test('a photo must be an https URL, or removed', async () => {
    const db = member();
    await assertSucceeds(updateDoc(doc(db, 'users/amara'), {
      avatarPath: 'https://res.cloudinary.com/demo/image/upload/a.jpg',
    }));
    await assertSucceeds(updateDoc(doc(db, 'users/amara'), { avatarPath: null }));
    await assertFails(updateDoc(doc(db, 'users/amara'), { avatarPath: 'file:///x.jpg' }));
  });

  test('not counters, and not invalid values', async () => {
    const db = member();
    await assertFails(updateDoc(doc(db, 'users/amara'), { followerCount: 10000 }));
    await assertFails(updateDoc(doc(db, 'users/amara'), { handle: 'No Spaces!' }));
    await assertFails(updateDoc(doc(db, 'users/amara'), { bio: 'x'.repeat(301) }));
  });

  test('nobody else can edit it', async () => {
    const kofi = as('kofi', 'k.mensah@alustudent.com');
    await assertFails(updateDoc(doc(kofi, 'users/amara'), { bio: 'hacked' }));
  });
});

describe('device tokens', () => {
  test('a member can store and remove their own device', async () => {
    const db = member();
    await assertSucceeds(
      setDoc(doc(db, 'users/amara/devices/tok1'), { platform: 'android' }),
    );
    await assertSucceeds(deleteDoc(doc(db, 'users/amara/devices/tok1')));
  });

  test('nobody can read or write someone else\'s devices', async () => {
    const kofi = as('kofi', 'k.mensah@alustudent.com');
    await assertFails(getDoc(doc(kofi, 'users/amara/devices/tok1')));
    await assertFails(
      setDoc(doc(kofi, 'users/amara/devices/tok1'), { platform: 'android' }),
    );
  });

  test('unverified accounts can\'t register devices', async () => {
    await assertFails(
      setDoc(doc(unverified(), 'users/nadia/devices/tok1'), { platform: 'android' }),
    );
  });
});

describe('deleting an account', () => {
  test('the owner can delete their profile and suggestions', async () => {
    const db = member();
    await assertSucceeds(deleteDoc(doc(db, 'users/amara/peerSuggestions/kofi')));
    await assertSucceeds(deleteDoc(doc(db, 'users/amara')));
  });

  test('nobody else can', async () => {
    const kofi = as('kofi', 'k.mensah@alustudent.com');
    await assertFails(deleteDoc(doc(kofi, 'users/amara')));
  });

  test('taking a like back off a post is allowed', async () => {
    await assertSucceeds(updateDoc(doc(member(), 'posts/p1'), { likeCount: increment(-1) }));
  });

  test('suggestions are still backend-only to write', async () => {
    await assertFails(
      setDoc(doc(member(), 'users/amara/peerSuggestions/x'), { mutualCount: 1 }),
    );
  });
});
