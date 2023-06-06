# V Chat SDK - Receive Share Package

Welcome to the V Chat SDK Receive Share Package. This standalone component enables your application to accept shared content from other apps, enhancing the interactivity and usability of your chat application. This package is part of the V Chat SDK ecosystem, but can also be used independently.

## Features

- **Inter-app Sharing:** With this package, your application can receive shared content from other apps installed on the user's device.

## Installation

To use the V Chat SDK Receive Share package, you'll need to install it in your project using your preferred package manager.

## Usage

To enable your application to accept shared content from other apps, call `vInitReceiveShareHandler();` inside the `initState()` method:

```dart
@override
void initState() {
  super.initState();
  vInitReceiveShareHandler();
}
```

This will initialize the receive share handler, making your application ready to accept shared content.

## Documentation

For more in-depth information on how to use this package, please refer to our comprehensive [documentation](https://v-chat-sdk.github.io/vchat-v2-docs/docs/intro/). This includes detailed guides, examples, and tutorials on how to fully take advantage of the V Chat SDK ecosystem.

## Support

If you encounter any issues, have feature requests, or general inquiries, please visit our [issues page](https://github.com/hatemragab/v_chat_sdk/issues) for information and to report any problems.

---

**Note:** Always ensure you are using the most recent version of the V Chat SDK and its packages to access the latest features and improvements.

---

The V Chat SDK Receive Share Package is proudly developed and maintained by the V Chat Team.