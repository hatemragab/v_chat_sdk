import '../../v_chat_sdk_core.dart';
import '../utils/event_bus.dart';
import 'online_offline_service.dart';

class OfflineOnlineEmitterService {
  final _emitter = EventBusSingleton.instance.vChatEvents;

  void start(Stream<VOnlineOfflineModel> stream) {
    stream.listen((e) {
      if (e.isOnline) {
        _handleOnlineEvent(e);
      } else {
        _handleOfflineEvent(e);
      }
    });
  }

  void _handleOnlineEvent(VOnlineOfflineModel e) {
    final isOnline = OnlineOfflineService.isUserOnlineByPeerId(e.peerId);
    //if (isOnline) return;
    OnlineOfflineService.setUser(e);
    _emitter.fire(VRoomOnlineEvent(roomId: e.roomId));
  }

  void _handleOfflineEvent(VOnlineOfflineModel e) {
    //we need to set this user offline
    final isOffline = OnlineOfflineService.isUserOfflineByPeerId(e.peerId);
    // if (isOffline) return;
    OnlineOfflineService.setUser(e);
    _emitter.fire(VRoomOfflineEvent(roomId: e.roomId));
  }
}
