# V Chat SDK Firebase Push Notifications Package

Welcome to the V Chat SDK Firebase Push Notifications Package, a powerful add-on package that enables push notifications through Firebase Cloud Messaging (FCM) service. This package seamlessly integrates with the V Chat SDK core package and ensures your users stay updated with every conversation.

## Features

- **Firebase FCM Integration:** This package leverages the Firebase Cloud Messaging service to deliver push notifications to your users.
- **Foreground Notification Support:** It supports notifications while the app is in the foreground, ensuring your users never miss an update.

## Installation

To start using the V Chat SDK Firebase Push Notifications package, you'll first need to install it in your project using your preferred package manager.

## Usage

To enable push notifications through Firebase, you can use the following code inside the `VChatController.init()` method:

```dart
VChatController.init(
  // Other parameters...
  vPush: VPush(
    fcmProvider: VChatFcmProver(),
    enableVForegroundNotification: true,
  ),
);
```

This method includes an optional `vPush` parameter, where you can pass a new `VPush` instance. By providing a `VChatFcmProver()` instance to `fcmProvider`, you're enabling the Firebase Cloud Messaging service.

## Documentation

For a more detailed explanation of how to use this package, please refer to our comprehensive [documentation](https://v-chat-sdk.github.io/vchat-v2-docs/docs/intro/). This includes in-depth guides, examples, and tutorials on how to fully leverage the V Chat SDK ecosystem.

## Support

If you encounter any issues, have feature requests, or general inquiries, please visit our [issues page](https://github.com/hatemragab/v_chat_sdk/issues) for information and to report any problems.

---

**Note:** Always ensure you are using the most recent version of the V Chat SDK and its packages to enjoy the latest features and improvements.

---

The V Chat SDK Firebase Push Notifications Package is proudly developed and maintained by the V Chat Team.
