import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textless/textless.dart';
import '../../../utils/custom_widgets/rounded_container.dart';

import '../controllers/message_controller.dart';

class MessageRecordView extends GetView<MessageController> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
            onTap: controller.cancelRecord,
            child: Icon(
              Icons.cancel,
              size: 40,
            )),
        InkWell(
          child: Obx(() => controller.recordTime.value.text),
        ),
        InkWell(
          onTap:()=> controller.stopRecord(context),
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
        )
      ],
    );
  }
}
