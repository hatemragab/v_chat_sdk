import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

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
        final isRoomOpen = VRoomTracker.instance.isRoomOpen(message.roomId);
        if (!vChatConfig.pushProvider!.enableForegroundNotification) {
          if (!isRoomOpen && !message.isMeSender) {
            VEventBusSingleton.vEventBus.fire(
              VOnNewNotifications(message, room),
            );
            return;
          }
        }

        if (event.actionRes == VNotificationActionRes.click) {
          if (room == null) return;
          VEventBusSingleton.vEventBus.fire(
            VOnNotificationsClickedEvent(message, room),
          );
        } else if (event.actionRes == VNotificationActionRes.push &&
            !message.isMeSender) {
          if (!isRoomOpen) {
            VAppAlert.showOverlaySupport(
              title: message.senderName,
              subtitle: message.getMessageText,
            );
          }
        }
      });
    }
    nativeApi.streams.vOnUpdateNotificationsTokenStream.listen((event) async {
      await nativeApi.remote.profile.addFcm(event.token);
    });
  }

  Future<VRoom?> _getRoom(String roomId) async {
    return VChatController.I.nativeApi.local.room.getOneWithLastMessageByRoomId(roomId);
  }

  Future<void> getOpenAppNotification() async {
    if (vChatConfig.isPushEnable) {
      final msgMap = await vChatConfig.pushProvider!.getOpenAppNotification();
      if (msgMap != null) {
        final message = MessageFactory.createBaseMessage(msgMap);
        final room = await _getRoom(message.roomId);
        final isRoomOpen = VRoomTracker.instance.isRoomOpen(message.roomId);
        if (room == null || isRoomOpen) return;
        VEventBusSingleton.vEventBus.fire(
          VOnNotificationsClickedEvent(message, room),
        );
      }
    }
  }
}
