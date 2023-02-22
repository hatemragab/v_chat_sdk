// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:get/get.dart';
import 'package:v_chat_input_ui/v_chat_input_ui.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class HomeController extends GetxController {
  final logs = <InputLog>[].obs;
  final isBan = false.obs;
  VBaseMessage replyMsg = VEmptyMessage();

  final isReplying = false.obs;
  final _serverMentions = List.generate(
    1000,
    (i) => VMentionModel(
      identifier: "$i",
      name: "u$i",
      image: "https://picsum.photos/600/60$i",
    ),
  );

  void banPress() {
    isBan.toggle();
  }

  void setReplyPress({required bool isText}) {
    if (isText) {
      replyMsg = VTextMessage.buildFakeMessage(index: 1);
    } else {
      replyMsg = VImageMessage.buildFakeMessage(high: 300, width: 300);
    }
    isReplying.value = true;
  }

  void onSubmitText(String message) {
    printOnScreen(InputLog("onSubmitText", message));
  }

  Future<List<VMentionModel>> onMentionRequireSearch(String text) async {
    printOnScreen(
      InputLog("onMentionRequireSearch", text),
      dissmiseReply: false,
    );
    if (text.isEmpty) {
      return _serverMentions.take(30).toList();
    }
    return _serverMentions
        .where((element) =>
            element.display.toLowerCase().contains(text.toLowerCase()))
        .toList();
  }

  void onSubmitMedia(List<VBaseMediaRes> files) {
    printOnScreen(InputLog("onSubmitMedia", files.toString()));
  }

  void onSubmitVoice(VMessageVoiceData data) {
    printOnScreen(InputLog("onSubmitVoice", data.toString()));
  }

  void onSubmitFiles(List<VPlatformFileSource> files) {
    printOnScreen(InputLog("onSubmitFiles", files.toString()));
  }

  void onSubmitLocation(VLocationMessageData data) {
    printOnScreen(InputLog("onSubmitLocation", data.toString()));
  }

  void onTypingChange(VRoomTypingEnum typing) {
    printOnScreen(InputLog("onTypingChange", typing.toString()),
        dissmiseReply: false);
  }

  void printOnScreen(InputLog log, {bool dissmiseReply = true}) {
    if (dissmiseReply) {
      isReplying.value = false;
    }
    logs.add(log);
  }
}

class InputLog {
  final String fName;
  final String data;

  InputLog(this.fName, this.data);
}
