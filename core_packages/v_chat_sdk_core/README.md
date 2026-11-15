# v_chat_sdk_core

The foundation of V Chat SDK. This package owns the chat models, REST and Socket.IO clients, local persistence, event bus, navigation contracts, notification abstraction, and application lifecycle.

Use it before adding the room UI, message UI, incoming-share handler, or a push provider.

## Requirements

- Flutter 3.47 or newer
- Dart 3.13 or newer
- A compatible V Chat backend
- A backend-matching encryption key

The package supports Android, iOS, web, macOS, and Windows. Background notification providers remain mobile-specific.

## Installation

```bash
flutter pub add v_chat_sdk_core
```

```dart
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
```

## Initialize the SDK

`VChatController` is a singleton and must be initialized once before any SDK page or API is used.

```dart
import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> initializeVChat({
  required VNavigator navigator,
}) async {
  const encryptionKey = String.fromEnvironment('V_CHAT_ENCRYPTION_KEY');
  if (encryptionKey.isEmpty) {
    throw StateError('V_CHAT_ENCRYPTION_KEY is required');
  }

  await VChatController.init(
    navigatorKey: navigatorKey,
    vNavigator: navigator,
    vChatConfig: VChatConfig(
      baseUrl: Uri.parse('https://chat.example.com'),
      encryptHashKey: encryptionKey,
      vPush: VPush(
        enableVForegroundNotification: false,
        vPushConfig: const VLocalNotificationPushConfig(),
      ),
    ),
  );
}
```

Attach the same key to your app:

```dart
MaterialApp(
  navigatorKey: navigatorKey,
  home: const AppHome(),
);
```

## Navigation Contract

`VNavigator` keeps the SDK independent of your routing package. Provide:

- `VRoomNavigator.toForwardPage` to select destination rooms.
- `VMessageNavigator` callbacks for message pages, message information, media viewers, profiles, and chat settings.
- An optional `VCallNavigator` for outgoing and incoming calls.

The complete application wiring is available in the repository's [`v_chat_config.dart`](https://github.com/hatemragab/v_chat_sdk/blob/master/core_packages/v_chat_sdk_sample/lib/v_chat_config.dart).

## Authentication and Realtime

Initialize the controller before authenticating. After a successful SDK login has stored the access token, connect realtime updates:

```dart
final connected = VChatController.I.connectToSocket();
if (!connected) {
  // The SDK has no stored access token yet.
}
```

The controller exposes `profileApi`, `roomApi`, `blockApi`, `nativeApi`, local room/message repositories, and typed event streams.

## Push Providers

`VPush` accepts Firebase and OneSignal adapters:

```dart
VPush(
  fcmProvider: firebaseProvider,
  oneSignalProvider: oneSignalProvider,
  enableVForegroundNotification: true,
  vPushConfig: const VLocalNotificationPushConfig(
    channelName: 'messages',
  ),
)
```

On Android, the SDK prefers Firebase when Google Play Services are available and can fall back to OneSignal when both providers are configured.

## Configuration Notes

- `encryptHashKey` must match the backend and must not change for existing encrypted data.
- Set `agoraAppId` before enabling call actions in `v_chat_message_page`.
- End-to-end message encryption is opt-in through `enableEndToEndMessageEncryption`.
- Group, broadcast, and forwarding limits are configurable through `VChatConfig`.
- Keep `enableLog` disabled in production unless diagnostic output is required.

## Lifecycle

Dispose SDK-owned page controllers in their widgets. When replacing the entire authenticated application session, disconnect provider listeners first and call:

```dart
VChatController.I.dispose();
```

## Development

From the repository root:

```bash
dart run melos run generate
dart run melos run analyze
dart run melos run test
```

Generated `*.chopper.dart` files are produced by `build_runner` and must not be edited manually.

## Related Packages

- [`v_chat_room_page`](https://pub.dev/packages/v_chat_room_page)
- [`v_chat_message_page`](https://pub.dev/packages/v_chat_message_page)
- [`v_chat_firebase_fcm`](https://pub.dev/packages/v_chat_firebase_fcm)
- [`v_chat_one_signal`](https://pub.dev/packages/v_chat_one_signal)
- [`v_chat_receive_share`](https://pub.dev/packages/v_chat_receive_share)
