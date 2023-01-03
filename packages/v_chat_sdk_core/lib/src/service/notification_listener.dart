import 'package:v_chat_sdk_core/src/v_chat_controller.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class VNotificationListener {
  VNotificationListener() {
    _init();
  }

  void _init() {
    VEventBusSingleton.vEventBus
        .on<VOnNotificationsClickedEvent>()
        .listen((event) {
      print(
          "VChatController.I.navContext!.mediaQuerySize.toString() ${VChatController.I.navContext!.mediaQuerySize.toString()}");
    });
    VEventBusSingleton.vEventBus.on<VOnNewNotifications>().listen((event) {});
    VEventBusSingleton.vEventBus
        .on<VOnUpdateNotificationsToken>()
        .listen((event) {
      print("eventeventeventeventevent $event");
    });
  }
}
