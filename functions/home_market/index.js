const { initializeApp } = require('firebase-admin/app');
const { getFirestore, FieldValue } = require('firebase-admin/firestore');
const { onDocumentWritten, onDocumentDeleted } = require('firebase-functions/v2/firestore');

initializeApp();

const db = getFirestore();

// Individual vote documents remain private. The public post document stores
// only aggregate option counts and the total number of votes.
exports.onPollVoteWritten = onDocumentWritten(
  'posts/{postId}/pollVotes/{voteId}',
  async (event) => {
    const before = event.data?.before.exists ? event.data.before.data() : null;
    const after = event.data?.after.exists ? event.data.after.data() : null;
    const oldOption = before?.option;
    const newOption = after?.option;
    if (oldOption === newOption) return;

    const postRef = db.doc(`posts/${event.params.postId}`);
    const eventRef = db.doc(
      `_functionEvents/${Buffer.from(event.id).toString('base64url')}`
    );
    await db.runTransaction(async (transaction) => {
      const processed = await transaction.get(eventRef);
      if (processed.exists) return;

      const postSnap = await transaction.get(postRef);
      if (!postSnap.exists) {
        transaction.create(eventRef, {
          processedAt: FieldValue.serverTimestamp(),
          type: 'pollVote',
        });
        return;
      }

      const post = postSnap.data();
      const options = post.poll?.options;
      if (!Array.isArray(options)) return;

      const counts = { ...(post.pollCounts || {}) };
      for (const option of options) {
        if (typeof counts[option] !== 'number') counts[option] = 0;
      }
      if (typeof oldOption === 'string' && options.includes(oldOption)) {
        counts[oldOption] = Math.max(0, counts[oldOption] - 1);
      }
      if (typeof newOption === 'string' && options.includes(newOption)) {
        counts[newOption] += 1;
      }
      const total = Object.values(counts).reduce((sum, count) => sum + count, 0);

      transaction.update(postRef, { pollCounts: counts, pollTotal: total });
      transaction.create(eventRef, {
        processedAt: FieldValue.serverTimestamp(),
        type: 'pollVote',
      });
    });
  }
);

// Firestore does not cascade subcollection deletes when a post is removed.
exports.onPostDeleted = onDocumentDeleted('posts/{postId}', async (event) => {
  await db.recursiveDelete(db.doc(`posts/${event.params.postId}`));
});
