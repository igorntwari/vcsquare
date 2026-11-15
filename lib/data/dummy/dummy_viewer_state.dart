// What the sample signed-in student (dummyCurrentUser) has liked, saved,
// joined and followed. In Firebase this lives under users/{uid}/...
// subcollections; see docs/firestore-schema.md.

// Posts the student has liked.
const Set<String> dummyLikedPostIds = {'p05', 'p16', 'p21'};

// Listings the student has saved (heart icon).
const Set<String> dummySavedListingIds = {'l04', 'l06', 'l14'};

// Communities and clubs the student is a member of.
const Set<String> dummyJoinedIds = {'c_gdg'};

// Official accounts and people the student follows.
const Set<String> dummyFollowingIds = {'h_registry'};
