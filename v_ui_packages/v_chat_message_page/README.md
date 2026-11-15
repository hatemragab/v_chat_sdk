# v_chat_message_page

Complete message UI for V Chat SDK. The package selects the correct direct, group, broadcast, or order view for a `VRoom` and provides timelines, message actions, attachments, replies, search, voice notes, media viewers, delivery state, and optional Agora calls.

This package is not standalone. Initialize and authenticate `v_chat_sdk_core` before opening a message page.

## Requirements

- Flutter 3.47 or newer
- Dart 3.13 or newer
- `v_chat_sdk_core` 2.1.1 or newer
- An initialized `VChatController`
- A room returned by the SDK
- Application-provided `VMessageLocalization`

## Installation

```bash
flutter pub add v_chat_message_page
```

```dart
import 'package:v_chat_message_page/v_chat_message_page.dart';
```

The package also re-exports `v_chat_input_ui` and `v_chat_voice_player`.

## Open a Message Page

```dart
Navigator.of(context).push(
  MaterialPageRoute<void>(
    builder: (_) => VMessagePage(
      vRoom: room,
      localization: messageLocalization,
      vMessageConfig: const VMessageConfig(
        showDisconnectedWidget: true,
        isCallsAllowed: false,
        maxMediaSize: 50 * 1024 * 1024,
        compressImageQuality: 70,
        maxRecordTime: Duration(minutes: 10),
      ),
    ),
  ),
);
```

`VMessagePage` reads `room.roomType` and builds `VSingleView`, `VGroupView`, `VBroadcastView`, or `VOrderView`. Each view creates and disposes its own specialized message controller.

## Configure Message Behavior

`VMessageConfig` supports:

- enabling or disabling call controls;
- custom attachment-button handling;
- block, unblock, and long-press callbacks;
- optional Google Maps API access for location picking;
- maximum media size;
- image-compression quality;
- maximum voice-recording duration;
- showing or hiding the disconnected-state widget.

To override attachment selection:

```dart
VMessageConfig(
  onMessageAttachmentIconPress: () async {
    return VAttachEnumRes.media;
  },
)
```

Return `null` when the action is cancelled.

## Theming

The widgets automatically fall back to light or dark defaults. Add `VMessageTheme` when the application needs custom presentation:

```dart
MaterialApp(
  theme: ThemeData(
    extensions: <ThemeExtension<dynamic>>[
      VMessageTheme.light().copyWith(
        scaffoldDecoration: const BoxDecoration(
          color: Color(0xfff7f7f8),
        ),
        senderBubbleColor: const Color(0xffd9fdd3),
        receiverBubbleColor: Colors.white,
      ),
    ],
  ),
  home: VMessagePage(
    vRoom: room,
    localization: messageLocalization,
  ),
)
```

Use `customMessageItem` on the theme to render application-specific custom-message payloads.

## Calls

Calls are available for supported rooms when:

1. `VMessageConfig.isCallsAllowed` is true;
2. `VChatConfig.agoraAppId` contains a valid Agora App ID; and
3. `VNavigator.callNavigator` implements outgoing and incoming navigation.

The workspace currently resolves `agora_rtc_engine` 6.5.4 because newer releases conflict with `share_plus` over incompatible `ffi` requirements.

## Localization

`VMessageLocalization` is required and contains every message action, delivery state, call state, error, and composer label. Create it from your localization system rather than hard-coding UI strings in the page.

## Main Public API

- `VMessagePage`: room-type dispatcher and top-level message screen.
- `VMessageConfig`: behavior, upload, attachment, call, and callback options.
- `VMessageTheme`: page and message-bubble theme extension.
- `VMessageLocalization`: required localized labels.
- `VBaseMessageController`: base contract for specialized room controllers.
- `VSingleView`, `VGroupView`, `VBroadcastView`, and `VOrderView`: specialized screens.
- `VTextParserWidget` and `MessageStatusIcon`: reusable message components.

## Platform Notes

The package targets Android, iOS, web, macOS, and Windows. Individual media, recording, map, file, and call capabilities still depend on their platform plugins and permissions. Validate every enabled attachment type on each platform you ship.

## Development

From the repository root:

```bash
dart run melos exec --scope=v_chat_message_page -- flutter analyze
dart run melos exec --scope=v_chat_message_page -- flutter test
```
