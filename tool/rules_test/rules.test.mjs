// firestore.rules against the emulator. Run: npm install && npm test (Java 21+).
import { readFileSync } from 'node:fs';
import { after, before, beforeEach, describe, test } from 'node:test';

import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} from '@firebase/rules-unit-testing';
import {
  arrayRemove,
  arrayUnion,
  collection,
  collectionGroup,
  deleteDoc,
  doc,
  getDoc,
  getDocs,
  increment,
  orderBy,
  query,
  serverTimestamp,
  setDoc,
  updateDoc,
  where,
  writeBatch,
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
    await setDoc(doc(db, 'posts/p1'), {
      authorId: 'kofi',
      likeCount: 3,
      commentCount: 0,
      pollCounts: {},
      pollTotal: 0,
    });
    await setDoc(doc(db, 'posts/p1/pollVotes/amara'), {
      userId: 'amara',
      option: 'Yes',
    });
    await setDoc(doc(db, 'posts/p1/pollVotes/kofi'), {
      userId: 'kofi',
      option: 'No',
    });
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

describe('poll vote collection-group reads', () => {
  test('a member can query their own votes across posts', async () => {
    const votes = query(
      collectionGroup(member(), 'pollVotes'),
      where('userId', '==', 'amara'),
    );
    await assertSucceeds(getDocs(votes));
  });

  test('a member cannot query another member’s votes', async () => {
    const votes = query(
      collectionGroup(member(), 'pollVotes'),
      where('userId', '==', 'kofi'),
    );
    await assertFails(getDocs(votes));
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

describe('marketplace drafts', () => {
  const draft = {
    title: 'Desk',
    description: 'Wooden desk',
    priceText: '25000',
    categoryId: 'furniture',
    condition: 'good',
    pickupHubId: 'library',
    negotiable: true,
    photoUrls: [],
    updatedAt: serverTimestamp(),
  };

  test('a member can save, read and delete their own draft', async () => {
    const ref = doc(member(), 'users/amara/listingDrafts/desk');
    await assertSucceeds(setDoc(ref, draft));
    await assertSucceeds(getDoc(ref));
    await assertSucceeds(deleteDoc(ref));
  });

  test('a member cannot read or write another user’s drafts', async () => {
    await env.withSecurityRulesDisabled((context) =>
      setDoc(doc(context.firestore(), 'users/amara/listingDrafts/desk'), {
        ...draft,
        updatedAt: new Date(),
      }),
    );
    const other = as('kofi', 'k.mensah@alustudent.com');
    await assertFails(getDoc(doc(other, 'users/amara/listingDrafts/desk')));
    await assertFails(
      setDoc(doc(other, 'users/amara/listingDrafts/desk'), draft),
    );
  });
});

describe('following students', () => {
  const follow = (db, from, to, data = {}) =>
    setDoc(doc(db, `users/${from}/following/${to}`), {
      targetId: to,
      type: 'user',
      ...data,
    });

  test('a member can follow and unfollow a student', async () => {
    const db = member();
    await assertSucceeds(follow(db, 'amara', 'kofi'));
    await assertSucceeds(deleteDoc(doc(db, 'users/amara/following/kofi')));
  });

  test('no following yourself, or naming someone else as the target', async () => {
    const db = member();
    await assertFails(follow(db, 'amara', 'amara'));
    await assertFails(follow(db, 'amara', 'kofi', { targetId: 'nadia' }));
  });

  test('no writing into someone else\'s following list', async () => {
    const kofi = as('kofi', 'k.mensah@alustudent.com');
    await assertFails(follow(kofi, 'amara', 'kofi'));
  });

  test('members can count followers across everyone', async () => {
    await env.withSecurityRulesDisabled((context) =>
      setDoc(doc(context.firestore(), 'users/kofi/following/amara'), {
        targetId: 'amara',
        type: 'user',
      }),
    );
    const followers = query(
      collectionGroup(member(), 'following'),
      where('targetId', '==', 'amara'),
    );
    await assertSucceeds(getDocs(followers));
    await assertFails(getDocs(query(
      collectionGroup(unverified(), 'following'),
      where('targetId', '==', 'amara'),
    )));
  });
});

describe('chats', () => {
  const kofi = () => as('kofi', 'k.mensah@alustudent.com');
  const nadia = () => as('nadia', 'n.uwase@alustudent.com');
  const id = 'amara_kofi';
  const chat = (db) => doc(db, `conversations/${id}`);
  // Matches FirebaseChatsRepository.openConversation.
  const fresh = () => ({
    participantIds: ['amara', 'kofi'],
    type: 'peer',
    subject: null,
    listingId: null,
    lastMessage: {},
    updatedAt: new Date(),
    unreadCounts: { amara: 0, kofi: 0 },
    mutedBy: [],
  });
  const seed = () =>
    env.withSecurityRulesDisabled((context) =>
      setDoc(chat(context.firestore()), fresh()),
    );
  const message = (senderId) => ({
    text: 'Hi',
    sentAt: new Date(),
    senderId,
    status: 'sent',
  });

  test('a member can check for a new chat, then start it', async () => {
    const db = member();
    await assertSucceeds(getDoc(chat(db)));
    await assertSucceeds(setDoc(chat(db), fresh()));
    await assertSucceeds(getDoc(chat(db)));
  });

  test('non-members cannot check for chats', async () => {
    await assertFails(getDoc(chat(outsider())));
    await assertFails(getDoc(chat(unverified())));
  });

  test('once a chat exists, only its participants can read it', async () => {
    await seed();
    await assertSucceeds(getDoc(chat(kofi())));
    await assertFails(getDoc(chat(nadia())));
  });

  test('no starting a chat you are not in', async () => {
    await assertFails(setDoc(chat(nadia()), fresh()));
  });

  // Matches FirebaseChatsRepository.sendMessage and watchMessages.
  test('a participant can send and read messages', async () => {
    await seed();
    const db = member();
    const sent = message('amara');
    const batch = writeBatch(db);
    batch.set(doc(db, `conversations/${id}/messages/m1`), sent);
    batch.update(chat(db), {
      lastMessage: sent,
      updatedAt: sent.sentAt,
      'unreadCounts.kofi': increment(1),
    });
    await assertSucceeds(batch.commit());
    await assertSucceeds(
      getDocs(query(collection(kofi(), `conversations/${id}/messages`), orderBy('sentAt'))),
    );
    await assertFails(getDocs(collection(nadia(), `conversations/${id}/messages`)));
  });

  test('no sending as someone else or into someone else\'s chat', async () => {
    await seed();
    await assertFails(setDoc(doc(member(), `conversations/${id}/messages/m2`), message('kofi')));
    await assertFails(setDoc(doc(nadia(), `conversations/${id}/messages/m3`), message('nadia')));
  });

  test('a participant can mark read and mute or unmute themselves', async () => {
    await seed();
    await assertSucceeds(updateDoc(chat(kofi()), { 'unreadCounts.kofi': 0 }));
    await assertSucceeds(updateDoc(chat(kofi()), { mutedBy: arrayUnion('kofi') }));
    await assertSucceeds(updateDoc(chat(kofi()), { mutedBy: arrayRemove('kofi') }));
  });

  test('no muting for someone else or changing who is in the chat', async () => {
    await seed();
    await assertFails(updateDoc(chat(kofi()), { mutedBy: arrayUnion('amara') }));
    await assertFails(updateDoc(chat(kofi()), { participantIds: ['kofi', 'nadia'] }));
    await assertFails(updateDoc(chat(nadia()), { mutedBy: arrayUnion('nadia') }));
  });
});
