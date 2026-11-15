# V Chat SDK

V Chat SDK is a modular Flutter client for applications backed by the V Chat REST and Socket.IO services. The workspace contains the core data and networking layer, ready-made room and message interfaces, push-notification adapters, and runnable integration examples.

The workspace root is for development only (`publish_to: none`). Add the packages your application needs from pub.dev.

## Requirements

- Flutter 3.47 or newer
- Dart 3.13 or newer
- A compatible V Chat backend URL
- An encryption key that matches the backend configuration
- Firebase, OneSignal, and Agora credentials only when those features are enabled

Never commit production credentials. Supply secrets through your deployment system or `--dart-define` values.

## Packages

| Package | Purpose |
| --- | --- |
| [`v_chat_sdk_core`](core_packages/v_chat_sdk_core/) | Models, REST clients, Socket.IO, local persistence, events, and SDK lifecycle |
| [`v_chat_receive_share`](core_packages/v_chat_receive_share/) | Receives content shared from Android and iOS applications |
| [`v_chat_message_page`](v_ui_packages/v_chat_message_page/) | Message timelines, composer, attachments, calls, and message actions |
| [`v_chat_room_page`](v_ui_packages/v_chat_room_page/) | Room list, room state, pagination, and room actions |
| [`v_chat_firebase_fcm`](push_providers/v_chat_firebase_fcm/) | Firebase Cloud Messaging provider for V Chat |
| [`v_chat_one_signal`](push_providers/v_chat_one_signal/) | OneSignal push provider for V Chat |
| [`v_chat_sdk_sample`](core_packages/v_chat_sdk_sample/) | Private full-integration Flutter application |
| [`v_chat_firebase_fcm_example`](push_providers/v_chat_firebase_fcm/example/) | Credential-safe FCM diagnostics application |

## Integration Flow

1. Configure your backend URL, matching encryption key, and optional push provider.
2. Implement `VNavigator` so SDK events can open rooms, settings, media, and calls using your app's routing system.
3. Initialize `VChatController` before building room or message pages.
4. Authenticate the user through the SDK APIs, then connect the Socket.IO client.
5. Present `VChatPage` for rooms and `VMessagePage` for a selected `VRoom`.
6. Dispose page controllers and provider listeners with the owning widget lifecycle.

See the package READMEs for complete examples and platform-specific requirements.

## Workspace Setup

```bash
flutter pub get
dart run melos list --long
```

The repository uses a Dart pub workspace, so dependency resolution happens once at the root.

## Quality Commands

Run these commands from the repository root:

```bash
dart run melos run format
dart run melos run analyze
dart run melos run test
dart run melos run generate
```

`generate` rebuilds the Chopper clients in `v_chat_sdk_core`. Do not edit `*.chopper.dart` manually.

## Run the Examples

Launch the complete SDK sample:

```bash
cd core_packages/v_chat_sdk_sample
flutter run
```

Launch the FCM diagnostics app without credentials:

```bash
cd push_providers/v_chat_firebase_fcm/example
flutter run
```

The FCM example starts safely in configuration-help mode. Its README documents the `--dart-define` values needed for live token validation.

## Platform Notes

- Core and UI packages target Android, iOS, web, macOS, and Windows.
- Background push delivery is a mobile feature; configure native Firebase or OneSignal projects before testing it.
- Incoming share handling is active on Android and iOS and is a no-op elsewhere.
- Calls use Agora through `v_chat_message_page`; provide an Agora App ID in `VChatConfig` before enabling call actions.
- Web builds currently target JavaScript. Some upstream dependencies are not yet WebAssembly-compatible.

## Documentation and Support

- [Flutter integration documentation](https://v-chat-sdk.github.io/vchat-v2-docs/docs/flutter/intro)
- [Backend API collection](https://documenter.getpostman.com/view/24524392/2s93Jox6Dq)
- [Issue tracker](https://github.com/hatemragab/v_chat_sdk/issues)

This repository is licensed under the terms in [LICENSE](LICENSE).
