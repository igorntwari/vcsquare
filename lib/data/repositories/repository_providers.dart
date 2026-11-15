// Riverpod providers for every repository. Screens read data through these,
// never from lib/data/dummy directly. (The Messages screens are owned
// separately and still read dummy data; chatsRepositoryProvider is ready.)
//
// AppConfig.useFirebase picks the implementation. Tests override a provider
// to plug in a fake:
//   ProviderScope(overrides: [
//     postsRepositoryProvider.overrideWithValue(MyFakePosts()),
//   ], child: ...)
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import '../models/user_model.dart';
import 'auth/auth_repository.dart';
import 'auth/firebase_auth_repository.dart';
import 'auth/sample_auth_repository.dart';
import 'chats/chats_repository.dart';
import 'chats/firebase_chats_repository.dart';
import 'chats/sample_chats_repository.dart';
import 'explore/explore_repository.dart';
import 'explore/firebase_explore_repository.dart';
import 'explore/sample_explore_repository.dart';
import 'listings/firebase_listings_repository.dart';
import 'listings/listings_repository.dart';
import 'listings/sample_listings_repository.dart';
import 'posts/firebase_posts_repository.dart';
import 'posts/posts_repository.dart';
import 'posts/sample_posts_repository.dart';
import 'profile/firebase_profile_repository.dart';
import 'profile/profile_repository.dart';
import 'profile/sample_profile_repository.dart';

// Only read when AppConfig.useFirebase is true.
final firestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AppConfig.useFirebase
      ? FirebaseAuthRepository(
          FirebaseAuth.instance,
          ref.watch(firestoreProvider),
        )
      : SampleAuthRepository(),
);

final postsRepositoryProvider = Provider<PostsRepository>(
  (ref) => AppConfig.useFirebase
      ? FirebasePostsRepository(ref.watch(firestoreProvider))
      : SamplePostsRepository(),
);

final listingsRepositoryProvider = Provider<ListingsRepository>(
  (ref) => AppConfig.useFirebase
      ? FirebaseListingsRepository(ref.watch(firestoreProvider))
      : SampleListingsRepository(),
);

// Ready for the Messages screens; not used by them yet (owned separately).
final chatsRepositoryProvider = Provider<ChatsRepository>(
  (ref) => AppConfig.useFirebase
      ? FirebaseChatsRepository(ref.watch(firestoreProvider))
      : SampleChatsRepository(),
);

final exploreRepositoryProvider = Provider<ExploreRepository>(
  (ref) => AppConfig.useFirebase
      ? FirebaseExploreRepository(ref.watch(firestoreProvider))
      : SampleExploreRepository(),
);

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => AppConfig.useFirebase
      ? FirebaseProfileRepository(ref.watch(firestoreProvider))
      : SampleProfileRepository(),
);

// The signed-in user, or null when signed out.
final currentUserProvider = StreamProvider<UserModel?>(
  (ref) => ref.watch(authRepositoryProvider).watchCurrentUser(),
);

// Just the signed-in user's id. Screen data depends on this rather than the
// whole user, so editing a profile field doesn't reload every screen.
final currentUserIdProvider = FutureProvider<String?>(
  (ref) => ref.watch(currentUserProvider.selectAsync((user) => user?.id)),
);
