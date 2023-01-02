import 'package:v_chat_utils/v_chat_utils.dart';

class VNotificationListener {
  VNotificationListener() {
    _init();
  }

  void _init() {
    VEventBusSingleton.vEventBus
        .on<VOnNotificationsClickedEvent>()
        .listen((event) {});
    VEventBusSingleton.vEventBus.on<VOnNewNotifications>().listen((event) {});
    VEventBusSingleton.vEventBus
        .on<VOnUpdateNotificationsToken>()
        .listen((event) {
      print("eventeventeventeventevent $event");
    });
  }
}
