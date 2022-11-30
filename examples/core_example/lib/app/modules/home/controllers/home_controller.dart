import 'dart:async';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class HomeController extends GetxController {
  late final StreamSubscription subscription;
  late final StreamSubscription subscription2;
  late final StreamSubscription subscription3;

  @override
  void onInit() {
    super.onInit();
    loginTest();
  }

  void loginTest() async {
    final loginRes = await VChatController.instance.login(
      identifier: "xxx",
      deviceLanguage: const Locale("en"),
    );
    subscription =
        VChatController.I.vNativeApi.socketStatusStream.listen((event) {
      print("event.isConnected is => ${event.isConnected}");
    });

    subscription2 = VChatController.I.vNativeApi.messageStream.listen((event) {
      print(event.toString());
    });
    subscription3 =
        VChatController.I.vNativeApi.socketIntervalStream.listen((event) {
      print(event.toString());
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    subscription.cancel();
    subscription2.cancel();
  }
}
