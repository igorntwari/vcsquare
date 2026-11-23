// Root screen: splash, verify email or the main tabs, based on the account.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_colors.dart';
import '../data/models/auth_account_model.dart';
import '../data/repositories/repository_providers.dart';
import '../features/auth/screens/verify_email_screen.dart';
import '../features/notifications/providers/push_sync_provider.dart';
import '../features/onboarding/screens/splash_screen.dart';
import '../shared/widgets/feedback/loading_indicator.dart';
import 'routes/app_router.dart';
import 'routes/route_names.dart';

enum AuthStage { loading, signedOut, needsVerification, signedIn }

AuthStage authStageOf(AsyncValue<AuthAccount?> account) => switch (account) {
  AsyncData(value: null) => AuthStage.signedOut,
  AsyncData(:final value?) when value.needsEmailVerification =>
    AuthStage.needsVerification,
  AsyncData() => AuthStage.signedIn,
  AsyncError() => AuthStage.signedOut,
  _ => AuthStage.loading,
};

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(pushSyncProvider);

    // Clear pushed routes so Back can't return to the previous stage.
    ref.listen(authAccountProvider, (previous, next) {
      final before = previous == null ? null : authStageOf(previous);
      final after = authStageOf(next);
      if (before != null && before != after && after != AuthStage.loading) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    });

    final account = ref.watch(authAccountProvider);
    return switch (authStageOf(account)) {
      AuthStage.loading => const Scaffold(
        backgroundColor: AppColors.primary,
        body: LoadingIndicator(),
      ),
      AuthStage.signedOut => SplashScreen(
        onGetStarted: () => Navigator.of(context).pushNamed(RouteNames.login),
      ),
      AuthStage.needsVerification => VerifyEmailScreen(
        email: account.value!.email,
      ),
      AuthStage.signedIn => AppRouter.buildMainShell(context, ref),
    };
  }
}
