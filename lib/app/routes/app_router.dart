// Central router mapping route names to screens.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/dummy/dummy_conversations.dart';
import '../../data/models/listing_model.dart';
import '../../data/repositories/repository_providers.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/sign_up_screen.dart';
import '../../features/explore/screens/explore_screen.dart';
import '../../features/home/screens/create_post_screen.dart';
import '../../features/explore/screens/official_handle_detail_screen.dart';
import '../../features/explore/screens/community_detail_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/market/providers/market_providers.dart';
import '../../features/market/screens/listing_detail_screen.dart';
import '../../features/market/screens/listing_preview_screen.dart';
import '../../features/market/screens/market_screen.dart';
import '../../features/market/screens/sell_item_screen.dart';
import '../../features/messages/screens/messages_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/onboarding/screens/why_institutional_login_screen.dart';
import '../../features/profile/screens/account_settings_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../shared/widgets/navigation/main_shell.dart';
import '../auth_gate.dart';
import 'route_names.dart';

// Screens expose callbacks; navigation is decided here so features never
// import each other or the app layer.
abstract final class AppRouter {
  // Lets code outside the widget tree navigate, e.g. when a push is tapped.
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // Opens the inbox, without stacking a second copy if it is already on top.
  static void openNotifications() {
    final navigator = navigatorKey.currentState;
    if (navigator == null) return;
    var alreadyOpen = false;
    navigator.popUntil((route) {
      alreadyOpen = route.settings.name == RouteNames.notifications;
      return true;
    });
    if (!alreadyOpen) navigator.pushNamed(RouteNames.notifications);
  }

  static Widget buildMainShell(BuildContext context) => MainShell(
    // Messages/chats are owned separately; still on dummy data.
    messagesBadgeCount: dummyUnreadConversationCount,
    tabs: [
      HomeScreen(
        onCreatePost: () => Navigator.of(context).pushNamed<bool>(
          RouteNames.createPost,
        ),
      ),
      MarketScreen(
        onSellItem: () => Navigator.of(context).pushNamed(RouteNames.sellItem),
        onOpenListing: (listing) => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => ListingDetailScreen(listing: listing),
          ),
        ),
      ),
      ExploreScreen(
        onOpenCommunity: (community, isJoined, onJoin) =>
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => CommunityDetailScreen(
                  community: community,
                  isJoined: isJoined,
                  onJoin: onJoin,
                ),
              ),
            ),
        onOpenOfficialHandle: (handle, isFollowing, onFollow) =>
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => OfficialHandleDetailScreen(
                  handle: handle,
                  isFollowing: isFollowing,
                  onFollow: onFollow,
                ),
              ),
            ),
      ),
      const MessagesScreen(),
      ProfileScreen(
        onEditProfile: () =>
            Navigator.of(context).pushNamed(RouteNames.editProfile),
        onOpenSettings: () =>
            Navigator.of(context).pushNamed(RouteNames.accountSettings),
      ),
    ],
  );

  static final Map<String, WidgetBuilder> routes = {
    RouteNames.root: (context) => const AuthGate(),
    RouteNames.login: (context) => LoginScreen(
      onCreateAccount: () => Navigator.of(context).pushNamed(RouteNames.signUp),
      onForgotPassword: () =>
          Navigator.of(context).pushNamed(RouteNames.forgotPassword),
      onWhyInstitutionalLogin: () =>
          Navigator.of(context).pushNamed(RouteNames.whyInstitutionalLogin),
    ),
    RouteNames.signUp: (context) => SignUpScreen(
      onBack: () => Navigator.of(context).pop(),
      onSignIn: () => Navigator.of(context).pop(),
    ),
    RouteNames.forgotPassword: (context) =>
        ForgotPasswordScreen(onBack: () => Navigator.of(context).pop()),
    RouteNames.whyInstitutionalLogin: (context) => WhyInstitutionalLoginScreen(
      onGoBack: () => Navigator.of(context).pop(),
    ),
    RouteNames.createPost: (context) => const CreatePostScreen(),
    // Step 2 receives the current sell form as a preview draft.
    RouteNames.sellItem: (context) => SellItemScreen(
      onClose: () => Navigator.of(context).pop(),
      onPreview: (draft) => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (previewContext) => Consumer(
            builder: (context, ref, _) => ListingPreviewScreen(
              draft: draft,
              onBack: () => Navigator.of(context).pop(),
              onPublish: () async {
                final seller = ref.read(currentUserProvider).value;
                if (seller == null) throw StateError('No signed-in seller');
                final navigator = Navigator.of(previewContext);
                await ref
                    .read(listingsRepositoryProvider)
                    .createListing(
                      ListingModel(
                        id: '',
                        title: draft.title,
                        details: draft.description,
                        priceRwf: draft.priceRwf,
                        condition: draft.condition,
                        categoryId: draft.categoryId,
                        seller: seller,
                        createdAt: DateTime.now(),
                        distanceKm: 0,
                        imagePath: draft.photoPaths.isEmpty
                            ? null
                            : draft.photoPaths.first,
                        tag: draft.pickupHubName,
                      ),
                    );
                ref.invalidate(marketProvider);
                navigator.pop();
                navigator.pop();
              },
            ),
          ),
        ),
        ),
      ),
    RouteNames.notifications: (context) =>
        NotificationsScreen(onBack: () => Navigator.of(context).pop()),
    RouteNames.editProfile: (context) =>
        EditProfileScreen(onDone: () => Navigator.of(context).pop()),
    RouteNames.accountSettings: (context) => AccountSettingsScreen(
      onBack: () => Navigator.of(context).pop(),
      onEditProfile: () =>
          Navigator.of(context).pushNamed(RouteNames.editProfile),
    ),
  };
}
