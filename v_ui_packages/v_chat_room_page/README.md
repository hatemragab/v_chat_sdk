# v_chat_room_page

Ready-made room-list UI for V Chat SDK. It combines local cache and remote pagination, listens for room and message events, displays connection state, supports room actions, and routes selected rooms through the application's `VNavigator`.

This package is not standalone. Initialize and authenticate `v_chat_sdk_core` first.

## Requirements

- Flutter 3.47 or newer
- Dart 3.13 or newer
- `v_chat_sdk_core` 2.1.1 or newer
- An initialized `VChatController`
- A connected or connectable Socket.IO session
- Application-provided `VRoomLanguage` labels

## Installation

```bash
flutter pub add v_chat_room_page
```

```dart
import 'package:v_chat_room_page/v_chat_room_page.dart';
```

## Display the Room List

Create one `VRoomController` per room page and dispose it with the widget:

```dart
class RoomsScreen extends StatefulWidget {
  const RoomsScreen({
    required this.language,
    super.key,
  });

  final VRoomLanguage language;

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  late final VRoomController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VRoomController();
  }

  @override
  Widget build(BuildContext context) {
    return VChatPage(
      controller: _controller,
      language: widget.language,
      appBar: AppBar(title: const Text('Chats')),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

When `onRoomItemPress` is omitted, the page calls `VChatController.I.vNavigator.messageNavigator.toMessagePage`.

## Custom Room Navigation

```dart
VChatPage(
  controller: controller,
  language: language,
  onRoomItemPress: (room) {
    controller.setRoomSelected(room.id);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MessageScreen(room: room),
      ),
    );
  },
)
```

Use `setRoomSelected` when custom navigation should reset the selected room's unread state.

## Filtering

```dart
controller.sortRoomsBy(VRoomType.g); // Groups only.
controller.sortRoomsBy(null);        // Restore all rooms.
```

The controller responds to socket reconnection, typing, online state, unread counts, room updates, and inserted or deleted messages.

## Theming

Add `VRoomTheme` to the application theme:

```dart
MaterialApp(
  theme: ThemeData(
    extensions: <ThemeExtension<dynamic>>[
      VRoomTheme.light().copyWith(
        scaffoldDecoration: const BoxDecoration(
          color: Color(0xfff7f7f8),
        ),
      ),
    ],
  ),
  home: RoomsScreen(language: roomLanguage),
)
```

`VRoomTheme` controls the scaffold, room tiles, text, unread indicators, images, and status presentation. Provide your own `VRoomLanguage` for every user-facing label.

## Main Public API

- `VChatPage`: paginated room-list screen.
- `VRoomController`: room state, filtering, selection, cache, and event subscriptions.
- `VRoomTheme`: theme extension for room presentation.
- `VRoomLanguage`: localized strings used by room actions and status labels.
- `VChooseRoomsPage`: room picker used by forwarding and sharing flows.
- `VRoomItem`: reusable room-list item.

## Platform Notes

The UI targets Android, iOS, web, macOS, and Windows. Network and realtime behavior still depend on the configured V Chat backend. Test narrow layouts, pointer/keyboard input, reconnection, empty lists, and pagination on every target you ship.

## Development

From the repository root:

```bash
dart run melos exec --scope=v_chat_room_page -- flutter analyze
dart run melos exec --scope=v_chat_room_page -- flutter test
```
