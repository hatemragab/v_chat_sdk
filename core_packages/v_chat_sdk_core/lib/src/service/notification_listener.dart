import 'package:v_chat_utils/v_chat_utils.dart';

import '../../v_chat_sdk_core.dart';

class VNotificationListener {
  final VNativeApi nativeApi;
  final VChatConfig vChatConfig;

  VNotificationListener(this.nativeApi, this.vChatConfig) {
    _init();
  }

  void _init() {
    if (vChatConfig.isPushEnable) {
      vChatConfig.pushProvider!.eventsStream().listen((event) async {
        final message = MessageFactory.createBaseMessage(event.message);
        final room = await _getRoom(message.roomId);
        if (!vChatConfig.pushProvider!.enableForegroundNotification) {
          VEventBusSingleton.vEventBus.fire(
            VOnNewNotifications(message, room),
          );
          return;
        }

        if (event.actionRes == VNotificationActionRes.click) {
          if (room == null) return;
          if (VChatController.I.navContext != null) {
            // Get.context!.toPage(VMessagePage(
            //   vRoom: room,
            // ));
          }

          // VEventBusSingleton.vEventBus.fire(
          //   VOnNotificationsClickedEvent(message, room),
          // );
        } else if (event.actionRes == VNotificationActionRes.push) {
          VAppAlert.showOverlaySupport(
            title: message.senderName,
            subtitle: message.getTextTrans,
          );
        }
      });
    }
    nativeApi.streams.vOnUpdateNotificationsTokenStream.listen((event) async {
      await nativeApi.remote.profile.addFcm(event.token);
    });
  }

  Future<VRoom?> _getRoom(String roomId) async {
    return VChatController.I.nativeApi.local.room.getRoomById(roomId);
  }
}
