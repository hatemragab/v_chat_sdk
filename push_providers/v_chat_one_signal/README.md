# v_chat_one_signal

OneSignal push-notification adapter for V Chat SDK. It manages notification permission, subscription IDs, foreground messages, click events, token changes, displayed notifications, and application badges.

## Requirements

- Flutter 3.47 or newer
- Dart 3.13 or newer
- `v_chat_sdk_core` 2.1.1 or newer
- A OneSignal application configured for your Android and/or Apple bundle IDs

Complete the OneSignal native setup for each mobile target before running the provider.

## Installation

```bash
flutter pub add v_chat_one_signal
```

```dart
import 'package:v_chat_one_signal/v_chat_one_signal.dart';
```

The package re-exports `onesignal_flutter`, so application-level identity APIs remain available without another import.

## Configure V Chat

```dart
final oneSignalProvider = VChatOneSignalProver(
  appId: const String.fromEnvironment('ONESIGNAL_APP_ID'),
  logLevel: OSLogLevel.warn,
);

await VChatController.init(
  navigatorKey: navigatorKey,
  vNavigator: appNavigator,
  vChatConfig: VChatConfig(
    baseUrl: Uri.parse('https://chat.example.com'),
    encryptHashKey: encryptionKey,
    vPush: VPush(
      oneSignalProvider: oneSignalProvider,
      enableVForegroundNotification: true,
      vPushConfig: const VLocalNotificationPushConfig(
        channelName: 'messages',
      ),
    ),
  ),
);

await oneSignalProvider.askForPermissions();
```

`VChatController.init` initializes the selected push provider. In release mode, OneSignal logging is forced off.

## Associate the V Chat User

After your V Chat login succeeds, associate the OneSignal subscription with a stable external user ID:

```dart
await OneSignal.login(vChatUserId);
```

Clear that association during logout:

```dart
await OneSignal.logout();
await oneSignalProvider.deleteToken();
```

`getToken()` returns the current OneSignal push-subscription ID. Subscription changes are emitted as `VOnUpdateNotificationsToken` events.

## V Chat Data Payload

The provider expects these OneSignal additional-data fields:

| Key | Value |
| --- | --- |
| `fromVChat` | Non-null marker indicating a V Chat notification |
| `vMessage` | JSON-encoded V Chat message map |

Valid foreground messages emit `VOnNewNotifications`. Clicks emit `VOnNotificationsClickedEvent` after the matching room is found in local storage.

## Lifecycle and Limitations

```dart
final token = await oneSignalProvider.getToken();
await oneSignalProvider.cleanAll();
oneSignalProvider.close();
```

`close()` removes the foreground, subscription, and click listeners. Call it when replacing the authenticated application session.

Cold-start message restoration is not currently implemented by this adapter: `getOpenAppNotification()` returns null. Active-process and resumed-process click listeners remain supported.

## Firebase Fallback

You may configure both FCM and OneSignal in `VPush`. On Android, V Chat uses FCM when Google Play Services are available and falls back to OneSignal when they are not.

## Troubleshooting

- Verify the OneSignal App ID matches the installed bundle/application ID.
- Request permission only in response to an appropriate user-facing flow.
- Confirm the backend sends `fromVChat` and `vMessage` as additional data.
- Test subscription opt-in/opt-out and user login/logout independently.
- Keep production logging disabled.

## Development

From the repository root:

```bash
dart run melos exec --scope=v_chat_one_signal -- flutter analyze
dart run melos exec --scope=v_chat_one_signal -- flutter test
```
