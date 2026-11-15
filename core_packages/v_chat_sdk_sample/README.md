# V Chat SDK Sample

Private Flutter application that demonstrates the complete V Chat integration: core initialization, Firebase push, authentication, room and message pages, incoming sharing, localization, navigation, media, and calls.

This application is a development fixture (`publish_to: none`), not a reusable package.

## Requirements

- Flutter 3.47 or newer
- Dart 3.13 or newer
- A running V Chat backend reachable from the selected device
- A matching message-encryption key
- Firebase configuration for every mobile application ID you run
- Optional Maps and Agora credentials for those features

## Configure the Sample

Review these files before running:

- `lib/v_chat_config.dart`: backend URL, encryption key, push provider, navigation, and Agora configuration.
- `lib/firebase_options.dart`: generated Firebase options.
- `android/app/google-services.json`: Android Firebase client configuration.
- `ios/Runner/GoogleService-Info.plist`: iOS Firebase client configuration.
- `macos/Runner/GoogleService-Info.plist`: macOS Firebase client configuration.

Replace repository demo values with configuration for your own backend and Firebase project. Firebase client files identify an application but must still be reviewed before distribution. Never add service-account keys, server keys, private APNs keys, or production encryption secrets to the repository.

## Resolve Dependencies

Run from the workspace root:

```bash
flutter pub get
```

## Run

```bash
cd core_packages/v_chat_sdk_sample
flutter run
```

Choose a specific device when several are connected:

```bash
flutter devices
flutter run -d <device-id>
```

An optional Maps value can be passed at compile time:

```bash
flutter run --dart-define=maps=<maps-api-key>
```

## What to Validate

1. Firebase initializes on mobile without blocking startup.
2. The user can register or sign in against the configured backend.
3. The SDK stores the access token and connects Socket.IO.
4. Rooms load from cache and refresh from the backend.
5. Direct, group, broadcast, and order message pages open.
6. Enabled text, media, file, location, voice, and call actions work.
7. Foreground, background, and tapped push notifications route correctly.
8. Logout removes push identity and leaves no authenticated socket session.

## Tests and Builds

From this directory:

```bash
flutter analyze
flutter test
flutter build apk --debug
flutter build web
```

The Android project intentionally remains on the newest Gradle/AGP combination currently compatible with the bundled Agora artifacts. Flutter may print future-toolchain warnings even though the debug build succeeds.

## Workspace Development

After changing a shared package, run from the repository root:

```bash
dart run melos run format
dart run melos run analyze
dart run melos run test
```

The sample resolves local workspace packages, so edits are exercised immediately without publishing.
