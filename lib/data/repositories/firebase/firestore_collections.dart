// Firestore collection and subcollection names, in one place.
// Keep in sync with docs/firestore-schema.md and firestore.rules.
abstract final class FirestoreCollections {
  static const String users = 'users';
  static const String posts = 'posts';
  static const String listings = 'listings';
  static const String conversations = 'conversations';
  static const String communities = 'communities';
  static const String officialHandles = 'officialHandles';
  static const String categories = 'categories';
  static const String pickupHubs = 'pickupHubs';
  static const String trendingTopics = 'trendingTopics';

  // conversations/{id}/messages
  static const String messages = 'messages';

  // users/{uid}/... per-user state, readable and writable only by that user.
  static const String likedPosts = 'likedPosts';
  static const String eventRsvps = 'eventRsvps';
  static const String pollVotes = 'pollVotes';
  static const String savedListings = 'savedListings';
  static const String listingDrafts = 'listingDrafts';
  static const String memberships = 'memberships';
  static const String following = 'following';
  static const String peerSuggestions = 'peerSuggestions';
  static const String connectionRequests = 'connectionRequests';
  static const String devices = 'devices';
}
