# V Chat SDK - Media Editor Package

Welcome to the V Chat SDK Media Editor Package, a standalone component that provides robust image and video editing capabilities for your chat application. This package is part of the V Chat SDK ecosystem, but it can also be used independently.

## Features

- **Image and Video Editing:** This package allows users to manipulate images and videos within the chat, including cropping images and drawing on them.
- **Customizable Editing Configurations:** You can customize image quality with the `VMediaEditorConfig` class.

## Installation

To get started with the V Chat SDK Media Editor package, you'll first need to install it in your project using your preferred package manager.

## Usage

To implement this package in your application, use the `VMediaEditorView`:

```dart
final fileRes = await context.toPage(VMediaEditorView(
  files: files,
  config: VMediaEditorConfig(
    imageQuality: vMessageConfig.compressImageQuality,
  ),
)) as List<VBaseMediaRes>?;
```

`VBaseMediaRes` is the base class for the returned media objects. You can perform different actions based on the type of media returned:

```dart
if (file is VMediaImageRes) {
  // Perform actions for edited images
}

if (file is VMediaVideoRes) {
  // Perform actions for edited videos
}

if (file is VMediaFileRes) {
  // Perform actions for other file types
}
```

## Documentation

For a more detailed explanation on how to use this package, please refer to our comprehensive [documentation](https://v-chat-sdk.github.io/vchat-v2-docs/docs/intro/). This includes in-depth guides, examples, and tutorials on how to fully leverage the V Chat SDK ecosystem.

## Support

If you encounter any issues, have feature requests, or general inquiries, please visit our [issues page](https://github.com/hatemragab/v_chat_sdk/issues) for information and to report any problems.

---

**Note:** Always ensure you are using the most recent version of the V Chat SDK and its packages to enjoy the latest features and improvements.

---

The V Chat SDK Media Editor Package is proudly developed and maintained by the V Chat Team.