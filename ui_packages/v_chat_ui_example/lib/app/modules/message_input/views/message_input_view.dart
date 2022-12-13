import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_ui/v_chat_ui.dart';

import '../controllers/message_input_controller.dart';

class MessageInputView extends GetView<MessageInputController> {
  const MessageInputView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('MessageInputView'),
        actions: [
          IconButton(
              onPressed: () => controller.logs.clear(),
              icon: const Icon(Icons.delete))
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      controller.logs[index].fName,
                    ),
                    subtitle: Text(
                      controller.logs[index].data,
                    ),
                  );
                },
                itemCount: controller.logs.length,
              );
            }),
          ),
          VMessageInputWidget(
            onSubmitText: (String message) {
              controller.logs.add(InputLog("onSubmitText", message));
            },
            onMentionRequireSearch: (String text) {
              controller.logs.add(InputLog("onMentionRequireSearch", text));
            },
            onSubmitMedia: (List<PlatformFileSource> files) {
              controller.logs.add(InputLog("onSubmitMedia", files.toString()));
            },
            onSubmitVoice: (VMessageVoiceData data) {
              controller.logs.add(InputLog("onSubmitVoice", data.toString()));
            },
            onSubmitFiles: (List<PlatformFileSource> files) {
              controller.logs.add(InputLog("onSubmitFiles", files.toString()));
            },
            onSubmitLocation: (VLocationMessageData data) {
              controller.logs
                  .add(InputLog("onSubmitLocation", data.toString()));
            },
            onTypingChange: (RoomTypingEnum typing) {
              controller.logs
                  .add(InputLog("onTypingChange", typing.toString()));
            },
          ),
        ],
      ),
    );
  }
}
