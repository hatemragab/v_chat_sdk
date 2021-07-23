import 'package:auto_direction/auto_direction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/custom_widgets/rounded_container.dart';


import '../controllers/send_message_controller.dart';

class MessageTextFieldView extends GetView<SendMessageController> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
            onTap:()=> controller.startPickFile(context), child: Icon(Icons.attach_file)),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Obx(() {
            return AutoDirection(
              text: controller.msgText.value,
              child: CupertinoTextField(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                controller: controller.textController,
                maxLines: 5,
                minLines: 1,
                placeholder: "your message",
                cursorHeight: 30,
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
              onTap:()=> controller.showRecordWidgetAndStart(context),
              child: RoundedContainer(
                boxShape: BoxShape.circle,
                color: Colors.red,
                height: 50,
                width: 50,
                child: Icon(
                  Icons.keyboard_voice_outlined,
                  color: Colors.white,
                ),
              ),
            );
          } else {
            return InkWell(
              onTap: controller.sendTextMessage,
              child: RoundedContainer(
                boxShape: BoxShape.circle,
                color: Colors.red,
                height: 50,
                width: 50,
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
