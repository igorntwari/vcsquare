// Central router mapping route names to screens.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_strings.dart';
import '../../data/dummy/dummy_conversations.dart';
import '../../data/repositories/repository_providers.dart';
import '../../features/explore/screens/explore_screen.dart';
import '../../features/explore/screens/official_handle_detail_screen.dart';
import '../../features/explore/screens/community_detail_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/market/screens/market_screen.dart';
import '../../features/market/screens/sell_item_screen.dart';
import '../../features/messages/screens/messages_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/onboarding/screens/login_screen.dart';
import '../../features/onboarding/screens/splash_screen.dart';
import '../../features/onboarding/screens/why_institutional_login_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../shared/widgets/navigation/main_shell.dart';
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

  static final Map<String, WidgetBuilder> routes = {
    RouteNames.splash: (context) => SplashScreen(
      onGetStarted: () =>
          Navigator.of(context).pushReplacementNamed(RouteNames.login),
    ),
    RouteNames.login: (context) => Consumer(
      builder: (context, ref, _) => LoginScreen(
        onContinueWithGoogle: () => _signIn(context, ref),
        onWhyInstitutionalLogin: () =>
            Navigator.of(context).pushNamed(RouteNames.whyInstitutionalLogin),
      ),
    ),
    RouteNames.whyInstitutionalLogin: (context) => WhyInstitutionalLoginScreen(
      onGoBack: () => Navigator.of(context).pop(),
    ),
    RouteNames.home: (context) => MainShell(
      // Messages/chats are owned separately; still on dummy data.
      messagesBadgeCount: dummyUnreadConversationCount,
      tabs: [
        const HomeScreen(),
        MarketScreen(
          onSellItem: () =>
              Navigator.of(context).pushNamed(RouteNames.sellItem),
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
        const ProfileScreen(),
      ],
    ),
    // Preview Listing (step 2) is wired up once that screen is built.
    RouteNames.sellItem: (context) =>
        SellItemScreen(onClose: () => Navigator.of(context).pop()),
    RouteNames.notifications: (context) =>
        NotificationsScreen(onBack: () => Navigator.of(context).pop()),
  };

  static Future<void> _signIn(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(authRepositoryProvider).signInWithGoogle();
      if (!context.mounted) return;
      Navigator.of(context)
          .pushNamedAndRemoveUntil(RouteNames.home, (_) => false);
    } catch (error) {
      debugPrint('[signIn] $error');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text(AppStrings.signInFailed)));
    }
  }
}
