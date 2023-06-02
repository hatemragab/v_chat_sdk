# V Chat SDK - Message Page UI Package

Welcome to the V Chat SDK Message Page UI Package. This component provides a pre-built UI for the messaging page of your chat application. Note that this package is a part of the V Chat SDK ecosystem and can't be used as a standalone component.

## Features

- **Pre-built Messages Page UI:** This package provides a UI for the messaging page, easing the development process.
- **Customizable Themes:** You can easily customize the messaging page's theme to match your application's style.

## Installation

To use the V Chat SDK Message Page UI package, you'll first need to install it in your project using your preferred package manager.

## Usage

To customize the theme of the message page, apply a `ThemeData` and use the `VMessageTheme` class:

```dart
theme: ThemeData(
  extensions: [
    VMessageTheme.dark().copyWith(
      scaffoldDecoration:  BoxDecoration(
        color: Colors.green
      ),
      receiverTextStyle: TextStyle(),
      customMessageItem: (context, isMeSender, data) {
        /// Render custom message data here; 'data' is the map of data that you attached while sending the custom message
      },
      receiverBubbleColor: Colors.green,
    ),
  ],
),
```

You can see more on how to use this package [here](https://v-chat-sdk.github.io/vchat-v2-docs/docs/flutter/message_page).

## Documentation

For more comprehensive information on how to use this package, refer to our extensive [documentation](https://v-chat-sdk.github.io/vchat-v2-docs/docs/intro/). It includes detailed guides, examples, and tutorials on how to fully leverage the V Chat SDK ecosystem.

## Support

If you encounter any issues, have feature requests, or general inquiries, please visit our [issues page](https://github.com/v-chat-sdk/vchat-v2/issues) for information and to report any problems.

---

**Note:** Always ensure you are using the most recent version of the V Chat SDK and its packages to access the latest features and improvements.

---

The V Chat SDK Message Page UI Package is proudly developed and maintained by the V Chat Team.