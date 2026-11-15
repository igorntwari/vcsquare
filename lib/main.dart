import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app/app.dart';
import 'app/routes/app_router.dart';
import 'core/services/notification_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // On Android, google-services.json already configures the default app
  // natively, so passing options here would conflict with it.
  if (defaultTargetPlatform == TargetPlatform.android) {
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }

  final notifications = NotificationService.instance;
  await notifications.init();
  notifications.setOpenInboxHandler(AppRouter.openNotifications);

  runApp(const App());

  // Shows the permission prompt once the first screen is up.
  notifications.requestPermissionAndSubscribe();
}
