# V Chat SDK - Voice Player Package

Welcome to the V Chat SDK Voice Player Package, a standalone component that provides a versatile voice player for your chat application. This package is a part of the V Chat SDK ecosystem, but it can also be used independently.

## Features

- **Voice Player Widget:** This package includes a voice player widget with many features, including seeking and speeding up the playback.
- **Customizable:** The appearance and functionality of the voice player can be tailored to your specific needs.

## Installation

To get started with the V Chat SDK Voice Player package, you'll need to install it using your preferred package manager.

## Usage

To integrate the voice player into your application, implement the `VVoiceMessageView` widget as shown below:

```dart
VVoiceMessageView(
  controller: voiceController(message)!,
  notActiveSliderColor: context
    .getMessageItemHolderColor(
      message.isMeSender,
      context,
    )
    .withOpacity(.3),
  activeSliderColor: context.isDark ? Colors.green : Colors.red,
);
```
you can add VVoiceMessageController()

You can customize this widget to suit your application's needs and style.

## Documentation

For more comprehensive information on how to use this package, please refer to our extensive [documentation](https://v-chat-sdk.github.io/vchat-v2-docs/docs/intro/). It includes detailed guides, examples, and tutorials to fully leverage the V Chat SDK ecosystem.

## Support

If you encounter any issues, have feature requests, or general inquiries, please visit our [issues page](https://github.com/v-chat-sdk/vchat-v2/issues) for information and to report any problems.

---

**Note:** Always ensure you are using the most recent version of the V Chat SDK and its packages to access the latest features and improvements.

---

The V Chat SDK Voice Player Package is proudly developed and maintained by the V Chat Team.