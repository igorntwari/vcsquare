const { initializeApp } = require('firebase-admin/app');
const { getFirestore, FieldValue } = require('firebase-admin/firestore');
const { getMessaging } = require('firebase-admin/messaging');

const {
  onDocumentCreated,
  onDocumentDeleted,
} = require('firebase-functions/v2/firestore');

initializeApp();

const db = getFirestore();

// Apply a counter change only once per Firestore event.
// This protects counts against automatic event retries.
async function updateCountOnce(event, uid, field, amount) {
  if (!uid || !event.id) return;

  const userRef = db.doc(`users/${uid}`);
  const eventKey = Buffer.from(event.id).toString('base64url');
  const eventRef = db.doc(`_functionEvents/${eventKey}`);

  await db.runTransaction(async (transaction) => {
    const processed = await transaction.get(eventRef);

    if (processed.exists) return;

    transaction.set(
      userRef,
      { [field]: FieldValue.increment(amount) },
      { merge: true }
    );

    transaction.create(eventRef, {
      processedAt: FieldValue.serverTimestamp(),
      uid,
      field,
      amount,
    });
  });
}

// Send notifications when a new conversation message is created.
exports.onMessageCreated = onDocumentCreated(
  'conversations/{cid}/messages/{mid}',
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) return;

    const msg = snapshot.data();
    if (!msg || typeof msg.senderId !== 'string') return;

    const conversationRef = db.doc(
      `conversations/${event.params.cid}`
    );

    const conversationSnap = await conversationRef.get();
    if (!conversationSnap.exists) return;

    const conversation = conversationSnap.data();
    const participants = conversation.participants;

    if (!Array.isArray(participants)) return;
    if (!participants.includes(msg.senderId)) return;

    const recipients = participants.filter(
      (uid) => uid !== msg.senderId
    );

    const mutedBy = conversation.mutedBy || [];

    const senderSnap = await db.doc(
      `users/${msg.senderId}`
    ).get();

    const sender = senderSnap.data() || {};
    const messageText =
      typeof msg.text === 'string' ? msg.text : '';

    const notification = {
      title: sender.name || 'New message',
      body: messageText.slice(0, 120) || 'Sent you a message',
    };

    for (const recipientId of recipients) {
      if (mutedBy.includes(recipientId)) continue;

      // Do not notify users who blocked the sender.
      const blockSnap = await db.doc(
        `users/${recipientId}/blocks/${msg.senderId}`
      ).get();

      if (blockSnap.exists) continue;

      const tokenSnap = await db.collection(
        `users/${recipientId}/tokens`
      ).get();

      const tokenDocs = tokenSnap.docs;

      if (!tokenDocs.length) continue;

      // FCM multicast supports up to 500 tokens per request.
      for (let i = 0; i < tokenDocs.length; i += 500) {
        const batch = tokenDocs.slice(i, i + 500);

        const response = await getMessaging().sendEachForMulticast({
          tokens: batch.map((doc) => doc.id),
          notification,
          data: {
            type: 'chat',
            conversationId: event.params.cid,
            otherUid: msg.senderId,
          },
        });

        // Remove expired or invalid device tokens.
        const cleanup = [];

        response.responses.forEach((result, index) => {
          if (
            !result.success &&
            [
              'messaging/registration-token-not-registered',
              'messaging/invalid-registration-token',
            ].includes(result.error?.code)
          ) {
            cleanup.push(batch[index].ref.delete());
          }
        });

        await Promise.all(cleanup);
      }
    }
  }
);

// Increment follower count when someone follows a user.
exports.onFollowerAdded = onDocumentCreated(
  'users/{uid}/followers/{followerId}',
  (event) =>
    updateCountOnce(
      event,
      event.params.uid,
      'followersCount',
      1
    )
);

// Decrement follower count when someone unfollows.
exports.onFollowerRemoved = onDocumentDeleted(
  'users/{uid}/followers/{followerId}',
  (event) =>
    updateCountOnce(
      event,
      event.params.uid,
      'followersCount',
      -1
    )
);

// Increment following count when a user follows someone.
exports.onFollowingAdded = onDocumentCreated(
  'users/{uid}/following/{followingId}',
  (event) =>
    updateCountOnce(
      event,
      event.params.uid,
      'followingCount',
      1
    )
);

// Decrement following count when a user unfollows someone.
exports.onFollowingRemoved = onDocumentDeleted(
  'users/{uid}/following/{followingId}',
  (event) =>
    updateCountOnce(
      event,
      event.params.uid,
      'followingCount',
      -1
    )
);
