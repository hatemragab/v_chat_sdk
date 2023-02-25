// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_input_ui/v_chat_input_ui.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../../v_chat_message_page.dart';
import '../../../models/input_state_model.dart';
import '../../../widgets/input_widgets/ban_widget.dart';
import '../../../widgets/input_widgets/reply_msg_widget.dart';
import '../controllers/v_base_message_controller.dart';

class InputWidgetState extends StatelessWidget {
  final VBaseMessageController controller;

  const InputWidgetState({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ValueListenableBuilder<MessageInputModel>(
        valueListenable: controller.inputStateController,
        builder: (_, value, __) {
          if (value.isHidden) return const SizedBox.shrink();
          return VMessageInputWidget(
            onSubmitText: controller.onSubmitText,
            autofocus: !VPlatforms.isWebRunOnMobile && !VPlatforms.isMobile,
            language: VInputLanguage(
              files: VTrans.of(context).labels.shareFiles,
              location: VTrans.of(context).labels.shareLocation,
              media: VTrans.of(context).labels.media,
              shareMediaAndLocation:
                  VTrans.of(context).labels.shareMediaAndLocation,
              textFieldHint: VTrans.of(context).labels.typeYourMessage,
            ),
            focusNode: controller.focusNode,
            onSubmitMedia: (files) => controller.onSubmitMedia(context, files),
            onSubmitVoice: controller.onSubmitVoice,
            onSubmitFiles: controller.onSubmitFiles,
            onSubmitLocation: controller.onSubmitLocation,
            onTypingChange: controller.onTypingChange,
            googleMapsLangKey: VAppConstants.sdkLanguage,
            maxMediaSize: controller.vConfig.maxMediaSize,
            onMentionSearch: (query) =>
                controller.onMentionRequireSearch(context, query),
            maxRecordTime: controller.vConfig.maxRecordTime,
            googleMapsApiKey: controller.vConfig.googleMapsApiKey,
            replyWidget: value.replyMsg == null
                ? null
                : ReplyMsgWidget(
                    vBaseMessage: value.replyMsg!,
                    onDismiss: controller.dismissReply,
                  ),
            stopChatWidget: value.isCloseInput
                ? BanWidget(
                    isMy: false,
                    onUnBan: () {},
                  )
                : null,
          );
        },
      ),
    );
  }
}
