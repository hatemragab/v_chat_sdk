# V Chat SDK - Input UI & Recorder Package

Welcome to the V Chat SDK Input UI & Recorder Package, a standalone component that provides a user-friendly input interface and voice recording feature for your chat application. This package is a part of the V Chat SDK ecosystem, but it can also be used independently.

## Features

- **Internationalization (i18n):** This package supports multiple languages, enabling you to cater to a diverse global user base.
- **Theme Customization:** You can easily customize the look and feel of your chat input and recorder to align with your application's theme.
- **Voice Recording:** Allows your users to send voice messages seamlessly.

## Installation

To get started with the V Chat SDK Input UI & Recorder package, you'll need to install it using your preferred package manager.

## Usage

To integrate this package into your application, implement the `VMessageInputWidget` as shown in the example code below:

```dart
VMessageInputWidget(
  onSubmitText: controller.onSubmitText,
  autofocus: VPlatforms.isWebRunOnMobile || VPlatforms.isMobile ? false : true,
  language: VInputLanguage(
    
  ),
  focusNode: controller.focusNode,
  onAttachIconPress:,
  onSubmitMedia: (files) => controller.onSubmitMedia(context, files),
  onSubmitVoice: (data) {
    controller.onSubmitVoice(VMessageVoiceData.fromMap(data.toMap()));
  },
  onSubmitFiles: controller.onSubmitFiles,
  onSubmitLocation: (data) {
    controller.onSubmitLocation(VLocationMessageData.fromMap(data.toMap()));
  },
  onTypingChange: (typing) {
    controller.onTypingChange(VRoomTypingEnum.values.byName(typing.name));
  },
  googleMapsLangKey: VAppConstants.sdkLanguage,
  maxMediaSize: controller.vMessageConfig.maxMediaSize,
  onMentionSearch: (query) => controller.onMentionRequireSearch(context, query),
  maxRecordTime: controller.vMessageConfig.maxRecordTime,
  googleMapsApiKey: controller.vMessageConfig.googleMapsApiKey,
  replyWidget: VReplyWidget(
    onReplyCancel: controller.onReplyCancel,
    onReplySubmit: controller.onReplySubmit,
  ),
);
```

You can customize this widget according to your needs.

For theming, you can override theme extensions:

```dart
ThemeData(
  // Your ThemeData configurations...
).copyWith(extensions: [VInputTheme.light()]);
```

## Documentation

For more comprehensive details on how to use this package, refer to our extensive [documentation](https://v-chat-sdk.github.io/vchat-v2-docs/docs/intro/). It includes detailed guides, examples, and tutorials to fully utilize the V Chat SDK ecosystem.

## Support

If you encounter any issues, have feature requests, or general inquiries, please visit our [issues page](https://github.com/hatemragab/v_chat_sdk/issues) for information and to report problems.

---

**Note:** Always ensure you are using the most recent version of the V Chat SDK and its packages to access the latest features and improvements.

---

The V Chat SDK Input UI & Recorder Package is proudly developed and maintained by the V Chat Team.