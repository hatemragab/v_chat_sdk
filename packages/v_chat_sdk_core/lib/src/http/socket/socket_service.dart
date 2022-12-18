import 'dart:async';

import 'package:logging/logging.dart';
import 'package:v_chat_sdk_core/src/http/socket/socket_io_client.dart';
import 'package:v_chat_sdk_core/src/models/socket/on_deliver_room_messages_model.dart';
import 'package:v_chat_sdk_core/src/models/socket/on_enter_room_model.dart';
import 'package:v_chat_sdk_core/src/models/socket/room_typing_model.dart';
import 'package:v_chat_sdk_core/src/models/v_room/single_room/my_single_room_info.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../v_chat_sdk_core.dart';
import '../../local_db/core/imp/api_cache/api_cache_keys.dart';
import '../../models/api_cache_model.dart';
import '../../native_api/local/native_local_cache.dart';
import '../../native_api/local/native_local_message.dart';
import '../../native_api/local/native_local_room.dart';
import '../../native_api/v_native_api.dart';

class SocketService {
  final _log = Logger('SocketService');
  final _nativeApi = VNativeApi.I;
  final SocketIoClient _socketIoClient;

  NativeLocalRoom get _localRoom => _nativeApi.local.room;

  NativeLocalApiCache get _apiCache => _nativeApi.local.apiCache;

  NativeLocalMessage get _localMessage => _nativeApi.local.message;

  SocketService(this._socketIoClient);

  bool get isSocketConnected => _socketIoClient.socket.connected;

  void handleConnect() {
    final access = AppPref.getHashedString(key: StorageKeys.accessToken) ?? "";
    if (access.isNotEmpty) {
      _socketIoClient.socket.io.options = {
        ..._socketIoClient.socket.io.options,
        "query": "auth=Bearer%20$access",
        "extraHeaders": {
          ..._socketIoClient.socket.io.options['extraHeaders']
              as Map<String, dynamic>,
          "Authorization": "Bearer $access"
        }
      };
      if (!isSocketConnected) {
        _socketIoClient.connect();
      } else {
        _log.warning(
          "you try to connect but you already connected ! i will disconnect and connect this will throw in future!",
        );
        _socketIoClient.disconnect();
        handleConnect();
      }
    }
  }

  Future<void> handleOnNewMessage(VBaseMessage message) async {
    if (!message.isMeSender) {
      /// i received this message from any one
      final res = await _localMessage.insertMessage(message);
      if (res == 1) {
        await _localRoom.updateRoomUnreadCountAddOne(message.roomId);
      }
    } else {
      await _localMessage.safeInsertMessage(message);
    }
  }

  void handleOnGetMyOnlineList(List<OnlineOfflineModel> dataModelList) {
    for (final e in dataModelList) {
      unawaited(
        _localRoom.updateRoomOnline(
          UpdateRoomOnlineEvent(
            ///this value will updated later
            roomId: '',
            model: e,
          ),
        ),
      );
    }
  }

  void handleOnEnterChatRoom(OnEnterRoomModel model) {
    unawaited(
      _localMessage.updateMessagesSetSeen(
        VUpdateMessageSeenEvent(
          roomId: model.roomId,
          localId: model.roomId,
          onEnterRoomModel: model,
        ),
      ),
    );
  }

  void handleOnDeliverRoomMessages(OnDeliverRoomMessagesModel model) {
    unawaited(
      _localMessage.updateMessagesSetDeliver(
        VUpdateMessageDeliverEvent(
          roomId: model.roomId,
          localId: model.roomId,
          deliverRoomMessagesModel: model,
        ),
      ),
    );
  }

  Future<void> handleOnRoomTypingChanged(RoomTypingModel x) async {
    if (!x.isMe) {
      await _localRoom.updateRoomTyping(x);
    }
  }

  Future<void> handleOnSingleRoomBan(
    MySingleRoomInfo mySingleRoomInfo,
    String roomId,
  ) async {
    final apiCache = ApiCacheModel(
      endPoint: ApiCacheKeys.mySingleInfo + roomId,
      value: mySingleRoomInfo.toMap(),
    );
    await _localRoom.updateRoomSingleBlock(
      mySingleRoomInfo.ban,
      roomId,
    );
    await _apiCache.insertToApiCache(apiCache);
  }

  Future<void> updateMessageType(VBaseMessage msg) async {
    await _localMessage.updateMessageType(
      VUpdateMessageTypeEvent(
        roomId: msg.roomId,
        localId: msg.localId,
        messageType: MessageType.allDeleted,
      ),
    );
  }
}
