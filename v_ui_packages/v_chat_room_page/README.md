# V Chat SDK - Room Page UI Package

Welcome to the V Chat SDK Room Page UI Package. This component provides a ready-made UI for the room page of your chat application. Please note that this package is part of the V Chat SDK ecosystem and cannot be used as a standalone component.

## Features

- **Pre-built Room Page UI:** This package includes a user interface for the room page, making the development process much easier.
- **Theme Customization:** Easily tailor the theme of the room page to match your application's style.

## Installation

To use the V Chat SDK Room Page UI package, you will need to install it in your project using your preferred package manager.

## Usage

To use the Room Page UI in your application, implement the `VChatPage` widget like so:

```dart
VChatPage(
  //context: navigator == null ? context : navigator!.context,
  appBar: AppBar(
    title: Text("start chat"),
  ),
  controller: controller.vRoomController,
  useIconForRoomItem: false,
  onRoomItemPress: (room) {
    controller.vRoomController.setRoomSelected(room.id);
    vWebChatNavigation.key.currentState!
        .pushReplacementNamed(ChatRoute.route, arguments: room);
  },
);
```

To customize the theme of the room page, apply a `ThemeData` and use the `VRoomTheme` class:

```dart
theme: ThemeData(
  extensions: [
    VRoomTheme.light().copyWith(
      scaffoldDecoration: VRoomTheme.light()
        .scaffoldDecoration
        .copyWith(color: lightColorScheme.background),
    ),
  ],
),
```

More details on how to use this package can be found [here](https://v-chat-sdk.github.io/vchat-v2-docs/docs/flutter/room_page).

## Documentation

For a more comprehensive guide on how to use this package, please refer to our extensive [documentation](https://v-chat-sdk.github.io/vchat-v2-docs/docs/intro/). It includes detailed guides, examples, and tutorials on how to fully leverage the V Chat SDK ecosystem.

## Support

If you encounter any issues, have feature requests, or general inquiries, please visit our [issues page](https://github.com/v-chat-sdk/vchat-v2/issues) for information and to report any problems.

---

**Note:** Always ensure you are using the most recent version of the V Chat SDK and its packages to access the latest features and improvements.

---

The V Chat SDK Room Page UI Package is proudly developed and maintained by the V Chat Team.