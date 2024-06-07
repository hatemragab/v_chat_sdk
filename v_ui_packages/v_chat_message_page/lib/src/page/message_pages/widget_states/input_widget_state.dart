// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../../../v_chat_message_page.dart';
import '../../../models/input_state_model.dart';
import '../../../widgets/input_widgets/ban_widget.dart';
import '../../../widgets/input_widgets/reply_msg_widget.dart';

class InputWidgetState extends StatelessWidget {
  final VBaseMessageController controller;
  final VMessageLocalization language;

  const InputWidgetState({
    super.key,
    required this.controller,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ValueListenableBuilder<MessageInputModel>(
        valueListenable: controller.inputStateController,
        builder: (_, value, __) {
          if (value.isHidden) return const SizedBox.shrink();
          return VMessageInputWidget(
            onSubmitText: controller.onSubmitText,
            autofocus: VPlatforms.isWebRunOnMobile || VPlatforms.isMobile
                ? false
                : true,
            language: language.vInputLanguage,
            focusNode: controller.focusNode,
            onAttachIconPress:
                controller.vMessageConfig.onMessageAttachmentIconPress == null
                    ? null
                    : () async {
                        final res = await controller
                            .vMessageConfig.onMessageAttachmentIconPress!();
                        if (res == null) return null;

                        return AttachEnumRes.values.byName(res.name);
                      },
            onSubmitMedia: (files) => controller.onSubmitMedia(context, files),
            onSubmitVoice: (data) {
              controller.onSubmitVoice(VMessageVoiceData.fromMap(data.toMap()));
            },
            onSubmitFiles: controller.onSubmitFiles,
            onSubmitLocation: (data) {
              controller
                  .onSubmitLocation(VLocationMessageData.fromMap(data.toMap()));
            },
            onTypingChange: (typing) {
              controller
                  .onTypingChange(VRoomTypingEnum.values.byName(typing.name));
            },
            googleMapsLangKey: Localizations.localeOf(context).languageCode,
            maxMediaSize: controller.vMessageConfig.maxMediaSize,
            onMentionSearch: (query) =>
                controller.onMentionRequireSearch(context, query),
            maxRecordTime: controller.vMessageConfig.maxRecordTime,
            googleMapsApiKey: controller.vMessageConfig.googleMapsApiKey,
            replyWidget: value.replyMsg == null
                ? null
                : ReplyMsgWidget(
                    vBaseMessage: value.replyMsg!,
                    replyToYourSelf: language.repliedToYourSelf,
                    onDismiss: controller.dismissReply,
                  ),
            stopChatWidget: value.isCloseInput
                ? BanWidget(
                    isMy: false,
                    youDontHaveAccess: language.youDontHaveAccess,
                    onUnBan: () {},
                  )
                : null,
          );
        },
      ),
    );
  }
}
