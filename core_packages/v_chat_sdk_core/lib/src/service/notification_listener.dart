import 'package:logging/logging.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class VNotificationListener {
  final VNativeApi nativeApi;
  final VChatConfig vChatConfig;
  final VNavigator vNavigator;

  final _log = Logger('VNotificationListener');

  VNotificationListener(
    this.nativeApi,
    this.vChatConfig,
    this.vNavigator,
  ) {
    _init();
  }

  void _init() {
    if (!vChatConfig.isPushEnable || VPlatforms.isWeb) return;
    if (vChatConfig.currentPushProviderService!.enableForegroundNotification) {
      nativeApi.streams.vOnNewNotificationStream.listen((event) {
        final message = event.message;
        final isRoomOpen = VRoomTracker.instance.isRoomOpen(message.roomId);
        if (!isRoomOpen && !message.isMeSender) {
          VAppAlert.showOverlaySupport(
            title: message.senderName,
            subtitle: message.getMessageText,
          );
        }
      });
    }
    nativeApi.streams.vOnNotificationsClickedStream.listen((event) {
      final message = event.message;
      final room = event.room;
      final isRoomOpen = VRoomTracker.instance.isRoomOpen(message.roomId);
      if (isRoomOpen) return;
      if (VChatController.I.navigationContext == null) {
        _log.shout(
          "(vOnNotificationsClickedStream) please set the navigation context to handle the notification click VChatController.I.setContext",
        );
        return;
      }

      vNavigator.messageNavigator
          .toMessagePage(VChatController.I.navigationContext!, room);
    });
    nativeApi.streams.vOnUpdateNotificationsTokenStream.listen((event) async {
      await nativeApi.remote.profile.addFcm(event.token);
    });
    _getOpenAppNotification();
  }

  Future<VRoom?> _getRoom(String roomId) async {
    return VChatController.I.nativeApi.local.room
        .getOneWithLastMessageByRoomId(roomId);
  }

  Future<void> _getOpenAppNotification() async {
    await Future.delayed(const Duration(seconds: 3));
    await VChatController.I.nativeApi.remote.socketIo.socketCompleter.future;
    final message =
        await vChatConfig.currentPushProviderService!.getOpenAppNotification();
    if (message == null) return;
    final room = await _getRoom(message.roomId);
    final isRoomOpen = VRoomTracker.instance.isRoomOpen(message.roomId);
    if (room == null || isRoomOpen) return;
    if (VChatController.I.navigationContext == null) {
      _log.shout(
        "(_getOpenAppNotification) please set the navigation context to handle the notification click by VChatController.I.setContext",
      );
      return;
    }
    vNavigator.messageNavigator.toMessagePage(
      VChatController.I.navigationContext!,
      room,
    );
  }
}
