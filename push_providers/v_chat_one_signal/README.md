# V Chat SDK OneSignal Push Notifications Package

Welcome to the V Chat SDK OneSignal Push Notifications Package, an essential add-on to enable push notifications through OneSignal. This package seamlessly integrates with the V Chat SDK core package, ensuring your users are always up-to-date with their conversations.

## Features

- **OneSignal Integration:** This package uses OneSignal to deliver push notifications to your users.
- **Foreground Notification Support:** It supports notifications while the app is in the foreground, so your users never miss an update.

## Installation

To start using the V Chat SDK OneSignal Push Notifications package, you'll first need to install it in your project using your preferred package manager.

## Usage

To enable push notifications through OneSignal, you can use the following code inside the `VChatController.init()` method:

```dart
VChatController.init(
  // Other parameters...
  vPush: VPush(
    oneSignalProvider: VChatOneSignalProver(
      appId: "your_onesignal_app_id",
    ),
    enableVForegroundNotification: true,
  ),
);
```

This method includes an optional `vPush` parameter, where you can pass a new `VPush` instance. By providing a `VChatOneSignalProver()` instance to `oneSignalProvider` and setting your OneSignal app ID, you're enabling the OneSignal service.

## Documentation

For a more comprehensive guide on how to use this package, please refer to our extensive [documentation](https://v-chat-sdk.github.io/vchat-v2-docs/docs/intro/). This includes detailed guides, examples, and tutorials on how to take full advantage of the V Chat SDK ecosystem.

## Support

If you encounter any issues, have feature requests, or general inquiries, please visit our [issues page](https://github.com/hatemragab/v_chat_sdk/issues) for information and to report any problems.

---

**Note:** Always ensure you are using the most recent version of the V Chat SDK and its packages to access the latest features and improvements.

---

The V Chat SDK OneSignal Push Notifications Package is proudly developed and maintained by the V Chat Team.
