# vsquare

Virtual Campus Community: a closed social network and marketplace for African Leadership University students, built with Flutter and Firebase (project `vcsquared-131f0`).

- Architecture rules: [lib/README.md](lib/README.md)
- Database schema: [docs/firestore-schema.md](docs/firestore-schema.md)

## Run the app

```sh
flutter pub get
flutter run
```

By default the app uses **sample data** (`lib/data/dummy`), so you need no Firebase setup to work on screens. Two switches change that:

| Flag | Effect |
| --- | --- |
| `--dart-define=USE_FIREBASE=true` | Screens read and write Firestore instead of sample data. You must sign in with Google. |
| `--dart-define=USE_EMULATORS=true` | With `USE_FIREBASE`, use the local Emulator Suite instead of the live project. **Use this for day-to-day testing.** |
| `--dart-define=EMULATOR_HOST=192.168.x.x` | Emulator host for a physical phone. The Android emulator uses `10.0.2.2` automatically. |

```sh
# Real Firebase code, local fake database
flutter run --dart-define=USE_FIREBASE=true --dart-define=USE_EMULATORS=true
```

### env.json (Firebase keys)

The Firebase keys are kept out of `lib/firebase_options.dart` and passed in at build time.

- **Android** reads `android/app/google-services.json` and doesn't need `env.json`.
- **iOS** needs it.

1. Copy the template: `cp env.example.json env.json`. `env.json` is gitignored, so never commit it.
2. Fill in the values:
   - Android values come from `android/app/google-services.json`.
   - iOS values come from `ios/Runner/GoogleService-Info.plist` (`API_KEY`, `GOOGLE_APP_ID`).
   - Or copy them from Firebase Console → Project settings → Your apps.
3. Run with the file:

   ```sh
   flutter run --dart-define-from-file=env.json
   ```

   In VS Code, add `"toolArgs": ["--dart-define-from-file=env.json"]` to your launch configuration.

| Key | Used by |
| --- | --- |
| `FIREBASE_API_KEY`, `FIREBASE_APP_ID` | Android (fallback) |
| `FIREBASE_IOS_API_KEY`, `FIREBASE_IOS_APP_ID` | iOS |
| `FIREBASE_MESSAGING_SENDER_ID`, `FIREBASE_PROJECT_ID`, `FIREBASE_STORAGE_BUCKET` | both |

If iOS starts without these keys, it stops with a "Firebase keys are missing" error instead of crashing later.

### iOS

The iOS app is already registered in Firebase (bundle id `com.example.vsquare`), and the code reads its keys from `env.json` as described above. You need a Mac with Xcode and CocoaPods.

To regenerate the config with the FlutterFire CLI instead (for example after changing the bundle id), run:

```sh
dart pub global activate flutterfire_cli
flutterfire configure --project=vcsquared-131f0 --platforms=android,ios
```

This rewrites `lib/firebase_options.dart` with the keys written inline. Move them back to `String.fromEnvironment(...)` before committing.

Google sign-in on iOS also needs an iOS OAuth client:

1. Enable the Google provider in Firebase Auth.
2. Download a fresh `GoogleService-Info.plist`; it will then include `CLIENT_ID` and `REVERSED_CLIENT_ID`.
3. Add `REVERSED_CLIENT_ID` as a URL scheme in `ios/Runner/Info.plist`.

## Firebase Emulator Suite

The emulators let you test against Auth, Firestore and Storage on your own machine, without touching the live project. Ports are set in `firebase.json`:

| Emulator | Port |
| --- | --- |
| Auth | 9099 |
| Firestore | 8080 |
| Storage | 9199 |
| Emulator UI | 4000 |

You need the Firebase CLI (`npm install -g firebase-tools`) and Java 11+.

```sh
# 1. Start the emulators (leave this running)
firebase emulators:start

# 2. Seed the fixed data (categories, pickup hubs, official accounts, communities)
cd tool/seed && npm install && npm run seed

# 3. Run the app against them
flutter run --dart-define=USE_FIREBASE=true --dart-define=USE_EMULATORS=true
```

Open http://localhost:4000 to browse and edit the data. Emulator data is wiped when you stop it. To keep it between runs, use `firebase emulators:start --import=.emulator-data --export-on-exit`.

## Seeding the live project

`tool/seed` writes the fixed collections from `tool/seed/data/*.json`. It targets the emulator unless you pass `--live`, and it needs a service account key to do that:

```sh
GOOGLE_APPLICATION_CREDENTIALS=/path/to/key.json npm run seed -- --live
```

Get the key from Firebase Console → Project settings → Service accounts. Never commit it; `.gitignore` blocks the usual file names.

The JSON files must match the sample data in `lib/data/dummy`. `test/seed_data_test.dart` fails if they drift apart.

## Deploying rules and indexes

`firestore.rules`, `storage.rules` and `firestore.indexes.json` are deployed by hand by the project owner:

```sh
firebase deploy --only firestore:rules,firestore:indexes,storage
```

## Tests and CI

```sh
flutter analyze
flutter test
```

| Test file | Covers |
| --- | --- |
| `test/data/models/` | Every model survives `toFirestore` → `fromFirestore` |
| `test/data/repositories/` | Sample repositories, plus Firebase repositories against an in-memory Firestore (`fake_cloud_firestore`) |
| `test/features/` | Each main screen renders its sample data, and shows an error state when loading fails |
| `test/seed_data_test.dart` | Seed JSON matches the sample data |

[`.github/workflows/ci.yml`](.github/workflows/ci.yml) runs `flutter analyze` and `flutter test` on every pull request into `dev`.
