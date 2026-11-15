# v_chat_receive_share

Adds Android and iOS “Share to…” handling to a V Chat application. Shared text and attachments are converted into V Chat messages, destination rooms are selected through your `VRoomNavigator`, and the messages are sent through the initialized SDK.

The package compiles on all V Chat platforms but performs work only on mobile.

## Requirements

- Flutter 3.47 or newer
- Dart 3.13 or newer
- `VChatController` initialized with a usable `navigatorKey`
- An authenticated V Chat user
- Android intent filters or an iOS share extension configured for your host app

## Installation

```bash
flutter pub add v_chat_receive_share
```

```dart
import 'package:v_chat_receive_share/v_chat_receive_share.dart';
```

## Initialize Incoming Sharing

Initialize the handler once, after `VChatController.init` and after your navigator has a context:

```dart
class AppShellState extends State<AppShell> {
  @override
  void initState() {
    super.initState();
    _initializeSharing();
  }

  Future<void> _initializeSharing() async {
    await vInitReceiveShareHandler();
  }

  @override
  Widget build(BuildContext context) => const AppHome();
}
```

The initializer checks content that launched the app and then listens for additional shares while the process remains alive. Call it only once to avoid duplicate stream listeners.

## How Shared Content Is Routed

1. The package reads the initial payload from `share_handler`.
2. File attachments are converted to `VPlatformFile` values.
3. `VNavigator.roomNavigator.toForwardPage` asks the user to choose rooms.
4. The package creates the appropriate V Chat messages and forwards them to the selected rooms.

Because room selection uses `VChatController.I.navigationContext`, initialization must happen after the root `NavigatorState` is available.

## Host Platform Setup

This package does not generate native sharing configuration.

- Android: declare the MIME types your activity accepts through intent filters.
- iOS: add and configure a Share Extension for the app group and payload types you support.

Follow the [`share_handler` platform guide](https://pub.dev/packages/share_handler) and test cold-start and warm-start sharing separately.

## Security and Validation

- Validate file size and MIME type again before uploading.
- Do not assume a shared file extension is trustworthy.
- Keep the authenticated user and socket state ready before forwarding.
- Test text-only, single-file, multiple-file, and cancelled room-selection flows.

## Development

From the repository root:

```bash
dart run melos exec --scope=v_chat_receive_share -- flutter analyze
dart run melos exec --scope=v_chat_receive_share -- flutter test
```

See the full integration application in [`v_chat_sdk_sample`](../v_chat_sdk_sample/).
