// Central router mapping route names to screens.
import 'package:flutter/material.dart';

import '../../data/dummy/dummy_conversations.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/sign_up_screen.dart';
import '../../features/explore/screens/explore_screen.dart';
import '../../features/home/screens/home_screen.dart';
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
      const HomeScreen(),
      MarketScreen(
        onSellItem: () => Navigator.of(context).pushNamed(RouteNames.sellItem),
      ),
      const ExploreScreen(),
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
    // Preview Listing (step 2) is wired up once that screen is built.
    RouteNames.sellItem: (context) =>
        SellItemScreen(onClose: () => Navigator.of(context).pop()),
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
