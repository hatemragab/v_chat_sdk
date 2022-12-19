import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textless/textless.dart';
import 'package:v_chat_input_ui/v_chat_input_ui.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MessageInputView'),
        actions: [
          IconButton(
            onPressed: () => controller.logs.clear(),
            icon: const Icon(Icons.delete),
          ),
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  onTap: controller.banPress,
                  child: controller.isBan.value
                      ? const Text("un Ban")
                      : const Text("Ban"),
                ),
                const PopupMenuItem(
                  // onTap: () => controller.setReplyPress(isText: true),
                  child: Text("Reply be text msg"),
                ),
                const PopupMenuItem(
                  // onTap: () => controller.setReplyPress(isText: false),
                  child: Text("Reply be image msg"),
                ),
              ];
            },
          )
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.separated(
                reverse: true,
                padding: const EdgeInsets.all(8),
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      controller.logs[index].fName.s2,
                      controller.logs[index].data.cap
                    ],
                  );
                  // return ListTile(
                  //   dense: true,
                  //   minVerticalPadding: 10,
                  //   contentPadding: EdgeInsets.zero,
                  //   title: controller.logs[index].fName.s2,
                  //   subtitle: controller.logs[index].data.cap,
                  // );
                },
                itemCount: controller.logs.length,
              );
            }),
          ),
          Obx(() {
            return VMessageInputWidget(
              stopChatWidget: controller.isBan.value ? _getBanWidget() : null,
              replyWidget: null,
              // replyWidget: controller.isReplying
              //     ? _getReplyWidget(controller.replyMsg.value)
              //     : null,
              googleMapsApiKey: "texst",
              onSubmitText: controller.onSubmitText,
              onMentionSearch: controller.onMentionRequireSearch,
              onSubmitMedia: controller.onSubmitMedia,
              onSubmitVoice: controller.onSubmitVoice,
              onSubmitFiles: controller.onSubmitFiles,
              onSubmitLocation: controller.onSubmitLocation,
              onTypingChange: controller.onTypingChange,
            );
          }),
        ],
      ),
    );
  }

  Widget _getBanWidget() {
    return const Text("BANNNED");
  }

  // Widget _getReplyWidget(Object value) {
  //   if (value is VTextMessage) {
  //     return const Text("VTextMessage");
  //   } else if (value is VImageMessage) {
  //     return const Text("V Image msg");
  //   }
  //   throw UnimplementedError();
  // }
}
