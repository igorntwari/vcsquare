// Build-time switches, set with --dart-define (see README).
abstract final class AppConfig {
  // false (default): screens use the sample data in lib/data/dummy.
  // true: screens read and write Firestore.
  //   flutter run --dart-define=USE_FIREBASE=true
  static const bool useFirebase = bool.fromEnvironment('USE_FIREBASE');

  // Point Firebase at the local Emulator Suite instead of the live project.
  // Only has an effect together with USE_FIREBASE=true.
  //   flutter run --dart-define=USE_FIREBASE=true --dart-define=USE_EMULATORS=true
  static const bool useEmulators = bool.fromEnvironment('USE_EMULATORS');

  // Host the emulators listen on. The Android emulator reaches the computer
  // at 10.0.2.2; use your computer's LAN IP for a physical phone.
  static const String emulatorHost = String.fromEnvironment(
    'EMULATOR_HOST',
    defaultValue: '',
  );

  // Keep in sync with firestore.rules.
  static const List<String> allowedEmailDomains = [
    'alustudent.com',
    'alueducation.com',
  ];
}
