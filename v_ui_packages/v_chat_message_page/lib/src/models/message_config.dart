import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

///[vRoom]: The chat room for which the messages are displayed. This parameter is required.
///[isCallsAllowed]: A boolean value that indicates whether calls are allowed in the chat room. The default value is true.
///[currentTheme]: set current theme for the v chat message page you can check the dark mode and pass the correct theme you can pass [VLightMessageTheme] OR [VDarkMessageTheme]
///[onUserBlockAnother]: A callback function that is called when a user blocks another user. This parameter is optional.
///[onMessageAttachmentIconPress]: A callback function that is called when the user clicks on the attachment icon in the message input box. This parameter is optional and returns a future AttachEnumRes instance.
///[onUserUnBlockAnother]: A callback function that is called when a user unblocks another user. This parameter is optional.
///[googleMapsApiKey]: A string value that represents the Google Maps API key. This parameter is optional.
///[maxMediaSize]: An integer value that represents the maximum size of the media files that can be uploaded. The default value is 50 MB.
///[compressImageQuality]: An integer value that represents the quality of the compressed image. The default value is 55.
///[maxRecordTime]: A Duration instance that represents the maximum duration of the recorded audio. The default value is 30 minutes.
class VMessageConfig {
  final bool isCallsAllowed;
  final UserActionType? onUserBlockAnother;
  final bool showDisconnectedWidget;

  ///callback when user clicked send attachment (this current show bottom sheet with media etc ...)
  final Future<VAttachEnumRes?> Function()? onMessageAttachmentIconPress;
  final Function(VBaseMessage baseMessage)? onMessageLongPress;
  final UserActionType? onUserUnBlockAnother;

  ///set api if you want to make users able to pick locations
  final String? googleMapsApiKey;

  ///set max upload files size default it 50 mb
  final int maxMediaSize;
  final int compressImageQuality;

  ///set max record time
  final Duration maxRecordTime;

  const VMessageConfig({
    this.isCallsAllowed = true,
    this.onMessageAttachmentIconPress,
    this.onUserUnBlockAnother,
    this.showDisconnectedWidget = true,
    this.googleMapsApiKey,
    this.onMessageLongPress,
    this.onUserBlockAnother,
    this.maxMediaSize = 1024 * 1024 * 50,
    this.compressImageQuality = 55,
    this.maxRecordTime = const Duration(minutes: 30),
  });
}
