// Data for the signed-in student's Profile screen.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/listing_model.dart';
import '../../../data/models/post_model.dart';
import '../../../data/models/profile_model.dart';
import '../../../data/repositories/repository_providers.dart';

typedef ProfileData = ({
  ProfileModel profile,
  List<PostModel> posts,
  List<ListingModel> listings,
  // Every listing, to show the saved ones on the Saved tab.
  List<ListingModel> allListings,
  Set<String> likedPostIds,
  Set<String> savedListingIds,
});

// Null when nobody is signed in.
final profileProvider = FutureProvider<ProfileData?>((ref) async {
  final userId = await ref.watch(currentUserIdProvider.future);
  if (userId == null) return null;
  final profiles = ref.watch(profileRepositoryProvider);
  final posts = ref.watch(postsRepositoryProvider);
  final listings = ref.watch(listingsRepositoryProvider);

  final (profile, myPosts, myListings, all, liked, saved) = await (
    profiles.fetchProfile(userId),
    posts.fetchPostsByAuthor(userId),
    listings.fetchListingsBySeller(userId),
    listings.fetchListings(),
    posts.fetchLikedPostIds(userId),
    listings.fetchSavedListingIds(userId),
  ).wait;
  return (
    profile: profile,
    posts: myPosts,
    listings: myListings,
    allListings: all,
    likedPostIds: liked,
    savedListingIds: saved,
  );
});
