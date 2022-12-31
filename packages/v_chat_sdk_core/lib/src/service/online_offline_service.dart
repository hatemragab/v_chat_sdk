import 'package:collection/collection.dart';

import '../../v_chat_sdk_core.dart';

abstract class OnlineOfflineService {
  static final _list = <VOnlineOfflineModel>[];

  static bool isUserOnlineByPeerId(String peerId) {
    final user = _list.firstWhereOrNull((e) => e.peerId == peerId);
    if (user == null) return false;
    return user.isOnline == true;
  }

  static bool isUserOfflineByPeerId(String peerId) {
    final user = _list.firstWhereOrNull((e) => e.peerId == peerId);
    if (user == null) return true;
    return user.isOnline == false;
  }

  static bool isUserExist(String peerId) {
    return _list.firstWhereOrNull((e) => e.peerId == peerId) != null;
  }

  static void clean() {
    _list.clear();
  }

  static void setUser(VOnlineOfflineModel e) {
    final index = _list.indexWhere((e) => e.peerId == e.peerId);
    if (index == -1) {
      _list.add(e);
    } else {
      _list[index] = e;
    }
  }
}
