import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/firebase_bootstrap.dart';
import 'app/routes/app_router.dart';
import 'core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();

  final notifications = NotificationService.instance;
  await notifications.init();
  notifications.setOpenInboxHandler(AppRouter.openNotifications);

  runApp(const ProviderScope(child: App()));

  // Shows the permission prompt once the first screen is up.
  notifications.requestPermissionAndSubscribe();
}
