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

// Live counts.
final followerCountProvider = StreamProvider.family<int, String>(
  (ref, userId) =>
      ref.watch(followRepositoryProvider).watchFollowerCount(userId),
);

final followingCountProvider = StreamProvider.family<int, String>(
  (ref, userId) =>
      ref.watch(followRepositoryProvider).watchFollowingCount(userId),
);

typedef StudentProfileData = ({
  ProfileModel profile,
  List<PostModel> posts,
  List<ListingModel> listings,
});

// Another student's profile, posts and listings.
final studentProfileProvider = FutureProvider.autoDispose
    .family<StudentProfileData, String>((ref, userId) async {
      final (profile, posts, listings) = await (
        ref.watch(profileRepositoryProvider).fetchProfile(userId),
        ref.watch(postsRepositoryProvider).fetchPostsByAuthor(userId),
        ref.watch(listingsRepositoryProvider).fetchListingsBySeller(userId),
      ).wait;
      return (profile: profile, posts: posts, listings: listings);
    });
