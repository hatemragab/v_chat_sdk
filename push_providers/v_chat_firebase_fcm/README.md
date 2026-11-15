# v_chat_firebase_fcm

Firebase Cloud Messaging adapter for V Chat SDK. It initializes FCM, exposes the registration-token lifecycle, translates V Chat data messages into SDK events, handles notification taps, stores background messages, and updates application badges.

## Requirements

- Flutter 3.47 or newer
- Dart 3.13 or newer
- `v_chat_sdk_core` 2.1.1 or newer
- A Firebase project with Android and/or Apple applications configured
- APNs credentials and notification capabilities for Apple targets

The package can compile with the wider workspace, but background push behavior is intended for Android and iOS.

## Installation

```bash
flutter pub add v_chat_firebase_fcm
```

```dart
import 'package:v_chat_firebase_fcm/v_chat_firebase_fcm.dart';
```

Complete the standard Firebase platform setup before initializing V Chat. Either install the native Firebase configuration files or initialize Firebase with generated `FirebaseOptions`.

## Configure V Chat

```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

final fcmProvider = VChatFcmProver();

await VChatController.init(
  navigatorKey: navigatorKey,
  vNavigator: appNavigator,
  vChatConfig: VChatConfig(
    baseUrl: Uri.parse('https://chat.example.com'),
    encryptHashKey: encryptionKey,
    vPush: VPush(
      fcmProvider: fcmProvider,
      enableVForegroundNotification: true,
      vPushConfig: const VLocalNotificationPushConfig(
        channelName: 'messages',
      ),
    ),
  ),
);

await fcmProvider.askForPermissions();
```

`VChatController.init` selects and initializes the configured provider. Keep a provider reference only when your application needs to request permission, inspect the token, or explicitly close listeners.

## Token Lifecycle

```dart
final token = await fcmProvider.getToken();

// Remove the FCM token and clear local notifications during logout.
await fcmProvider.deleteToken();
```

Token refreshes are emitted as `VOnUpdateNotificationsToken` events so the SDK can update the backend registration.

## V Chat Data Payload

V Chat notification handling expects both values in the FCM data payload:

| Key | Value |
| --- | --- |
| `fromVChat` | Non-null marker indicating a V Chat notification |
| `vMessage` | JSON-encoded V Chat message map |

Foreground messages emit `VOnNewNotifications`. Notification taps emit `VOnNotificationsClickedEvent` after the related room is found in local storage. Background handling persists the message, updates unread counts, marks delivery when possible, and updates the app badge.

## Cold Start and Cleanup

`getOpenAppNotification()` returns the V Chat message that opened the app, except call messages. The core notification listener uses this result to route to the correct room when the navigator context is ready.

Cancel provider subscriptions when replacing the application session:

```dart
fcmProvider.close();
```

Use `cleanAll()` to clear displayed notifications and reset the app badge.

## Runnable Diagnostics Example

The bundled example runs safely without credentials:

```bash
cd example
flutter run
```

For live Firebase initialization and token validation:

```bash
flutter run \\
  --dart-define=FIREBASE_API_KEY=... \\
  --dart-define=FIREBASE_APP_ID=... \\
  --dart-define=FIREBASE_MESSAGING_SENDER_ID=... \\
  --dart-define=FIREBASE_PROJECT_ID=...
```

Optional values are `FIREBASE_AUTH_DOMAIN` and `FIREBASE_STORAGE_BUCKET`. Do not commit real values.

## Troubleshooting

- A null token usually means permission was denied, Firebase was not configured, networking failed, or Google Play Services are unavailable.
- Test foreground, background, terminated, token-refresh, and logout flows separately.
- Confirm the backend sends a data payload containing `fromVChat` and `vMessage`.
- On iOS, verify Push Notifications and Background Modes capabilities plus valid APNs credentials.

## Development

From the repository root:

```bash
dart run melos exec --scope=v_chat_firebase_fcm -- flutter analyze
dart run melos exec --scope=v_chat_firebase_fcm -- flutter test
```
