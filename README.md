# vsquare

Virtual Campus Community: a closed social network and marketplace for African Leadership University students, built with Flutter and Firebase (project `vcsquared-131f0`).

- Architecture rules: [lib/README.md](lib/README.md)
- Database schema: [docs/firestore-schema.md](docs/firestore-schema.md)
- Images (photos, avatars) are hosted on Cloudinary, not Firebase Storage. The database stores the image URL.

## Run the app

```sh
flutter pub get
flutter run
```

By default the app uses **sample data** (`lib/data/dummy`), so you need no Firebase setup to work on screens. Two switches change that:

| Flag | Effect |
| --- | --- |
| `--dart-define=USE_FIREBASE=true` | Screens read and write Firestore instead of sample data. You must sign in with an ALU account (see [Sign-in](#sign-in)). |
| `--dart-define=USE_EMULATORS=true` | With `USE_FIREBASE`, use the local Emulator Suite instead of the live project. **Use this for day-to-day testing.** |
| `--dart-define=EMULATOR_HOST=192.168.x.x` | Emulator host for a physical phone. The Android emulator uses `10.0.2.2` automatically. |

```sh
# Real Firebase code, local fake database
flutter run --dart-define=USE_FIREBASE=true --dart-define=USE_EMULATORS=true
```

### Run from VS Code

1. Copy `env.example.json` to `env.json` and fill in the Firebase values plus
   the Cloudinary cloud name and unsigned upload preset. Keep `env.json`
   private; it is gitignored.
2. Select **Run and Debug → VCSquared · Sample data** for a backend-free run,
   or **VCSquared · Firebase Emulator** to start Auth/Firestore locally, seed
   the fixed campus data, and run against the emulator.

The emulator launch requires the Firebase CLI, Java 11+, Node.js, and npm.
The first launch installs the seed tool's locked dependencies. To prepare it
manually instead, run `firebase emulators:start` from the repository root, then
`npm ci && npm run seed` from `tool/seed`. Emulator mode is explicitly enabled
in the VS Code launch configuration; it will not write to the live project.

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

## Sign-in

Only `@alustudent.com` and `@alueducation.com` accounts can join. Two methods are supported:

| Method | Flow |
| --- | --- |
| Email and password | Sign up → verification email → verify → Home. Includes "Forgot password?" (reset link by email). |
| Google | One tap with an ALU Google account. Google accounts arrive verified. |

The **auth gate** (`lib/app/auth_gate.dart`) is the app's root screen. It shows Splash when signed out, Verify email for unverified email accounts, and the main tabs when signed in. Firebase keeps the session, so the app reopens signed in. Sign out, delete account and edit profile are under **Profile → ⚙ Account settings**.

**One-time Firebase Console setup** (project owner):

1. Authentication → Sign-in method: enable **Email/Password** and **Google**.
2. Project settings → Your apps → Android: add the **SHA-1** of every machine that builds the app (`cd android && ./gradlew signingReport`), then download `google-services.json` again. Without your SHA-1, Google sign-in fails on your build.
3. Deploy the rules: `firebase deploy --only firestore:rules`.

**Sample-data mode** (no `USE_FIREBASE`): the app starts signed in as the sample student. To try the email flow after signing out, use `a.kamau@alustudent.com` / `campus2026`. Sign-ups are kept in memory, and "I've verified my email" verifies at once.

**Emulator:** the Auth emulator doesn't send real emails. It prints verification and reset links in the terminal running `firebase emulators:start`. Open the link in a browser, then tap "I've verified my email".

## Following students

Explore lists **Students on campus**: everyone who has signed up, newest first. Students can follow each other from that list, or from a student's profile page (tap a student). Follows are saved in `users/{uid}/following`. The Followers and Following numbers on profiles update live (see `docs/firestore-schema.md`). After pulling, deploy the indexes too: `firebase deploy --only firestore`.

The older **People You May Know** list (with **Connect**) needs a backend to fill `peerSuggestions`, so it stays empty on the Spark plan.

## Notifications

Pushes come from Firebase Cloud Messaging. Every device is subscribed to the topic `all`. Signed-in users also follow the topics `announcements`, `marketplace` and `messages`, unless they turn them off under **Profile → ⚙ → Notification settings**. Those choices, and "Show alerts" for pushes arriving while the app is open, are saved on the device with SharedPreferences, so they survive a restart.

When a user signs in, the device's FCM token is stored at `users/{uid}/devices/{token}`. It's removed on sign-out or account deletion.

**Sending a push from Firebase Console** (Messaging → New campaign → Notifications):

- To everyone, or to one category: target **Topic** `all`, `announcements`, `marketplace` or `messages`.
- To one person: open their `users/{uid}/devices` in Firestore, copy the document id (the token), then use **Send test message**.
- To open a tab when tapped: under **Additional options → Custom data**, add the key `screen` with the value `home`, `market`, `explore`, `messages` or `profile`. Without it, tapping opens the notifications inbox.

Received pushes are kept in the in-app inbox (bell icon) on the device.

## Firebase Emulator Suite

The emulators let you test against Auth and Firestore on your own machine, without touching the live project. Ports are set in `firebase.json`:

| Emulator | Port |
| --- | --- |
| Auth | 9099 |
| Firestore | 8080 |
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

## Cloudinary image uploads

Set the cloud name and unsigned upload preset at run time:

```sh
flutter run --dart-define=CLOUDINARY_CLOUD_NAME=px7mja9s \\
  --dart-define=CLOUDINARY_UPLOAD_PRESET=vcsquare_mobile_unsigned
```

In Android Studio, open **Run → Edit Configurations**, select the Flutter run configuration, and put these same flags in **Additional run args**. Click **Apply** and **OK**, then run the app on the connected device. This leaves the app in sample-data mode for a Cloudinary upload smoke test. Add `--dart-define=USE_FIREBASE=true` only when intentionally testing Firestore persistence with an ALU account and the required rules deployed.

Do not add a Cloudinary API secret to the app or repository. Restrict the unsigned preset to the image formats the app needs. The app compresses images, limits their width to 2000 pixels and rejects files larger than 8 MB; Cloudinary presets do not enforce a per-preset file-size limit.

Profile photos (Profile → ⚙ → Edit profile → Change photo) use the same upload. They're resized to 800 pixels wide and saved to `users/{uid}.avatarPath` when you tap Save.

## Testing the security rules

`tool/rules_test` runs `firestore.rules` against the Firestore emulator. It covers who can read, profile create/update/delete, ALU-only access and verified-only access. It needs Node and Java 21+.

```sh
cd tool/rules_test && npm install && npm test
```

## Deploying rules and indexes

`firestore.rules` and `firestore.indexes.json` are deployed by hand by the project owner:

```sh
firebase deploy --only firestore:rules,firestore:indexes
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
| `test/core/` | Form validators (ALU email, password strength, handle, lengths) |
| `test/data/repositories/auth_*`, `firebase_auth_repository_test.dart` | Error mapping, sign-up/sign-in/reset/sign-out/delete account and profile edits against `firebase_auth_mocks` and `fake_cloud_firestore` |
| `test/features/` | Each main screen renders its sample data and shows an error state when loading fails. Also the auth flow through the real routes and gate, edit profile, account actions, and layouts in landscape and on a small phone |
| `test/data/repositories/notification_prefs_repository_test.dart`, `device_registry_test.dart`, `test/features/notification*_test.dart`, `push_sync_test.dart`, `main_shell_test.dart` | Notification settings saved and restored, topics applied, device token stored on sign-in and cleared on sign-out, inbox taps and tab switching |
| `test/helpers/`, `test/flutter_test_config.dart` | Shared widget-test setup (phone-sized screen, real fonts, in-memory SharedPreferences) |
| `test/seed_data_test.dart` | Seed JSON matches the sample data |

[`.github/workflows/ci.yml`](.github/workflows/ci.yml) runs `flutter analyze`, `flutter test` and the rules tests on every pull request into `dev`.
