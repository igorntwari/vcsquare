# lib/ architecture rules

1. Feature-first structure with a shared layer.
2. A widget used by 2 or more features goes in `shared/widgets`. A widget used by only one feature stays in that feature's `widgets/` folder.
3. No hardcoded colors, text styles, spacing, radii or asset paths in screens. They come from `core/theme` and `core/constants`.
4. Screens get data through the repositories in `data/repositories` (via the Riverpod providers in `repository_providers.dart`), never from `data/dummy` or inline lists. Each repository has a sample version (backed by `data/dummy`) and a Firebase version; `--dart-define=USE_FIREBASE=true` switches between them.
5. Features never import from other features. They only import from `core`, `data` and `shared`.
6. One widget per file, and the file is named after the widget.
7. State management is Riverpod (`flutter_riverpod`). Screen data lives in a `FutureProvider` in the feature's `providers/` folder; widgets that need it are `ConsumerWidget` / `ConsumerStatefulWidget`.
8. Models carry `fromFirestore` / `toFirestore`. They never hold per-user state (liked, saved, joined, following, mine): that comes from the repositories as id sets. Schema: `docs/firestore-schema.md`.
9. Moving between signed out, unverified and signed in is the auth gate's job (`app/auth_gate.dart`): it watches `authAccountProvider` and swaps the root screen. Auth screens never navigate after signing in or out. Repository methods that touch the account throw `AuthFailure`, and screens show its `message`.
