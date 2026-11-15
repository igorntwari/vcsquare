// Starts Firebase and, when asked, points it at the local Emulator Suite.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import '../core/config/app_config.dart';
import '../firebase_options.dart';

// Ports match the "emulators" block in firebase.json.
const int _authPort = 9099;
const int _firestorePort = 8080;
const int _storagePort = 9199;

Future<void> initializeFirebase() async {
  // On Android, google-services.json already configures the default app
  // natively, so passing options here would conflict with it.
  if (defaultTargetPlatform == TargetPlatform.android) {
    await Firebase.initializeApp();
  } else {
    final options = DefaultFirebaseOptions.currentPlatform;
    if (options.apiKey.isEmpty || options.appId.isEmpty) {
      throw StateError(
        'Firebase keys are missing. Create env.json (see README) and run '
        'with --dart-define-from-file=env.json',
      );
    }
    await Firebase.initializeApp(options: options);
  }

  if (AppConfig.useFirebase && AppConfig.useEmulators) {
    final host = AppConfig.emulatorHost.isNotEmpty
        ? AppConfig.emulatorHost
        // The Android emulator reaches the host computer at 10.0.2.2.
        : defaultTargetPlatform == TargetPlatform.android
        ? '10.0.2.2'
        : 'localhost';
    await FirebaseAuth.instance.useAuthEmulator(host, _authPort);
    FirebaseFirestore.instance.useFirestoreEmulator(host, _firestorePort);
    await FirebaseStorage.instance.useStorageEmulator(host, _storagePort);
    debugPrint('[Firebase] Using local emulators on $host');
  }
}
