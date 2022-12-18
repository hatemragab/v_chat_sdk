import 'package:get/get.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_ui/v_chat_ui.dart';

class MessageInputController extends GetxController {
  final logs = <InputLog>[].obs;
  final isBan = false.obs;
  final replyMsg = Object().obs;

  bool get isReplying => replyMsg.value is VBaseMessage;
  final _serverMentions = List.generate(
    1000,
    (i) => MentionWithPhoto(
      id: "$i",
      display: "u$i",
      photo: VFullUrlModel.fromFullUrl(
        "https://picsum.photos/600/60$i",
      ),
    ),
  );

  void banPress() {
    isBan.toggle();
  }

  void setReplyPress({required bool isText}) {
    if (isText) {
      replyMsg.value = VTextMessage.buildFakeMessage("id");
    } else {
      replyMsg.value = VImageMessage.buildFakeMessage();
    }
  }

  void onSubmitText(String message) {
    printOnScreen(InputLog("onSubmitText", message));
  }

  Future<List<MentionWithPhoto>> onMentionRequireSearch(String text) async {
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

  void onSubmitMedia(List<PlatformFileSource> files) {
    printOnScreen(InputLog("onSubmitMedia", files.toString()));
  }

  void onSubmitVoice(VMessageVoiceData data) {
    printOnScreen(InputLog("onSubmitVoice", data.toString()));
  }

  void onSubmitFiles(List<PlatformFileSource> files) {
    printOnScreen(InputLog("onSubmitFiles", files.toString()));
  }

  void onSubmitLocation(VLocationMessageData data) {
    printOnScreen(InputLog("onSubmitLocation", data.toString()));
  }

  void onTypingChange(RoomTypingEnum typing) {
    printOnScreen(InputLog("onTypingChange", typing.toString()),
        dissmiseReply: false);
  }

  void printOnScreen(InputLog log, {bool dissmiseReply = true}) {
    if (dissmiseReply) {
      replyMsg.value = Object();
    }
    logs.add(log);
  }
}

class InputLog {
  final String fName;
  final String data;

  InputLog(this.fName, this.data);
}
