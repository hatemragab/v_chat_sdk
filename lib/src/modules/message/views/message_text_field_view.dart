import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_sdk/src/services/v_chat_app_service.dart';
import 'package:v_chat_sdk/src/utils/custom_widgets/auto_direction.dart';
import 'package:v_chat_sdk/src/utils/helpers/helpers.dart';
import '../../../utils/custom_widgets/rounded_container.dart';

import '../controllers/send_message_controller.dart';

class MessageTextFieldView extends GetView<SendMessageController> {
  const MessageTextFieldView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
            onTap: () => controller.startPickFile(context),
            child: const Icon(Icons.attach_file)),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Obx(() {
            return AutoDirection(
              text: controller.msgText.value,
              child: CupertinoTextField(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                controller: controller.textController,
                style: Helpers.isDark(context)
                    ? const TextStyle(color: Colors.white)
                    : const TextStyle(color: Colors.black),
                maxLines: 5,
                minLines: 1,
                placeholder: VChatAppService.to.getTrans().yourMessage(),
              ),
            );
          }),
        ),
        const SizedBox(
          width: 10,
        ),
        Obx(() {
          final res = controller.isRecordWidget.value;
          if (res) {
            return InkWell(
              onTap: () => controller.showRecordWidgetAndStart(context),
              child: const RoundedContainer(
                boxShape: BoxShape.circle,
                color: Colors.red,
                height: 45,
                width: 45,
                child: Icon(
                  Icons.keyboard_voice_outlined,
                  color: Colors.white,
                ),
              ),
            );
          } else {
            return InkWell(
              onTap: controller.sendTextMessage,
              child: const RoundedContainer(
                boxShape: BoxShape.circle,
                color: Colors.red,
                height: 45,
                width: 45,
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            );
          }
        }),
      ],
    );
  }
}
