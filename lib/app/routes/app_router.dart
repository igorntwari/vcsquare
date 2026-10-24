// Central router mapping route names to screens.
import 'package:flutter/material.dart';

import '../../features/onboarding/screens/login_screen.dart';
import '../../features/onboarding/screens/splash_screen.dart';
import '../../features/onboarding/screens/why_institutional_login_screen.dart';
import 'route_names.dart';

// Screens expose callbacks; navigation is decided here so features never
// import each other or the app layer.
abstract final class AppRouter {
  static final Map<String, WidgetBuilder> routes = {
    RouteNames.splash: (context) => SplashScreen(
      onGetStarted: () =>
          Navigator.of(context).pushReplacementNamed(RouteNames.login),
    ),
    RouteNames.login: (context) => LoginScreen(
      onWhyInstitutionalLogin: () =>
          Navigator.of(context).pushNamed(RouteNames.whyInstitutionalLogin),
    ),
    RouteNames.whyInstitutionalLogin: (context) => WhyInstitutionalLoginScreen(
      onGoBack: () => Navigator.of(context).pop(),
    ),
  };
}
