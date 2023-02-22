// import 'package:flutter/material.dart';
// import 'package:v_chat_input_ui/v_chat_input_ui.dart';
// import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
// import 'package:v_chat_utils/v_chat_utils.dart';
//
// import '../../../models/input_state_model.dart';
// import '../../../widgets/input_widgets/ban_widget.dart';
// import '../../../widgets/input_widgets/reply_msg_widget.dart';
// import '../states/input_state_controller.dart';
//
// abstract class InputWidgetAbs {
//   void onTextMessage(String text);
// }
//
// class InputWidgetState extends StatelessWidget {
//   final InputStateController inputStateController;
//   final InputWidgetAbs inputWidgetAbs;
//
//   const InputWidgetState({
//     Key? key,
//     required this.inputStateController,
//     required this.inputWidgetAbs,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: ValueListenableBuilder<MessageInputModel>(
//         valueListenable: inputStateController,
//         builder: (_, value, __) {
//           if (value.isHidden) return const SizedBox.shrink();
//           return VMessageInputWidget(
//             onSubmitText: inputWidgetAbs.onTextMessage,
//             autofocus: !VPlatforms.isWebRunOnMobile && !VPlatforms.isMobile,
//             language: VInputLanguage(
//               files: VTrans.of(context).labels.shareFiles,
//               location: VTrans.of(context).labels.shareLocation,
//               media: VTrans.of(context).labels.media,
//               shareMediaAndLocation:
//                   VTrans.of(context).labels.shareMediaAndLocation,
//               textFieldHint: VTrans.of(context).labels.typeYourMessage,
//             ),
//             focusNode: controller.focusNode,
//             onSubmitMedia: (files) => controller.onSubmitMedia(context, files),
//             onSubmitVoice: controller.onSubmitVoice,
//             onSubmitFiles: controller.onSubmitFiles,
//             onSubmitLocation: controller.onSubmitLocation,
//             onTypingChange: controller.onTypingChange,
//             googleMapsLangKey: VAppConstants.sdkLanguage,
//             maxMediaSize: _config.maxMediaSize,
//             onMentionSearch: (query) =>
//                 controller.onMentionRequireSearch(context, query),
//             maxRecordTime: _config.maxRecordTime,
//             googleMapsApiKey: _config.googleMapsApiKey,
//             replyWidget: value.replyMsg == null
//                 ? null
//                 : ReplyMsgWidget(
//                     vBaseMessage: value.replyMsg!,
//                     onDismiss: controller.dismissReply,
//                   ),
//             stopChatWidget: value.isCloseInput
//                 ? BanWidget(
//                     isMy: false,
//                     onUnBan: () {},
//                   )
//                 : null,
//           );
//         },
//       ),
//     );
//   }
// }
