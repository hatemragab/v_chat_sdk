import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textless/textless.dart';

import '../../../enums/room_type.dart';
import '../../../utils/custom_widgets/circle_image.dart';
import '../../../utils/custom_widgets/connection_checker.dart';
import '../bindings/message_binding.dart';
import '../controllers/message_controller.dart';
import 'message_appbar_view.dart';
import 'message_item_view.dart';
import 'message_recored_view.dart';
import 'message_text_field_view.dart';

class MessageView extends StatefulWidget {
  @override
  _MessageViewState createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  final controller = Get.find<MessageController>();

  @override
  void dispose() {
    MessageBinding.unBind();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MessageAppBarView(),
      body: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 1, top: 4),
        child: Column(
          children: [
            ConnectionChecker(),
            const SizedBox(
              height: 6,
            ),
            Expanded(
              child: Obx(() {
                final messagesList = controller.messagesList;
                return Scrollbar(
                  showTrackOnHover: true,
                  thickness: 7,
                  child: ListView.separated(
                    reverse: true,
                    controller: controller.scrollController,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) =>
                        MessageItemView(messagesList[index], index),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 8,
                    ),
                    itemCount: messagesList.length,
                  ),
                );
              }),
            ),
            Obx(() {
              final x = controller.isLastMessageSeen.value;
              if (controller.currentRoom!.roomType == RoomType.single) {
                if (x) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 7,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: CircleImage.network(
                            path: controller.currentRoom!.thumbImage,
                            width: 20,
                            height: 20),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }
              return const SizedBox.shrink();
            }),
            const SizedBox(
              height: 2,
            ),
            Obx(() {
              final bkId = controller.currentRoom!.blockerId.value;
              if (bkId != 0) {
                if (bkId == controller.myModel!.id) {
                  // i the blocker
                  return "chat has been closed by me".text;
                } else {
                  return "chat has been closed".text;
                }
              }

              final res = controller.isRecordWidgetEnable.value;
              if (res) {
                return MessageRecordView();
              } else {
                return MessageTextFieldView();
              }
            }),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
