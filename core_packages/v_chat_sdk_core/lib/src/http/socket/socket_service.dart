// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:logging/logging.dart';
import 'package:v_chat_sdk_core/src/http/socket/socket_io_client.dart';
import 'package:v_chat_sdk_core/src/native_api/local/native_local_message.dart';
import 'package:v_chat_sdk_core/src/native_api/local/native_local_room.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class SocketService {
  final _log = Logger('SocketService');
  final _nativeApi = VNativeApi.I;
  final SocketIoClient _socketIoClient;

  NativeLocalRoom get _localRoom => _nativeApi.local.room;

  // NativeLocalApiCache get _apiCache => _nativeApi.local.apiCache;

  NativeLocalMessage get _localMessage => _nativeApi.local.message;

  SocketService(this._socketIoClient);

  bool get isSocketConnected => _socketIoClient.socket.connected;
  final _emitter = VEventBusSingleton.vEventBus;

  void handleConnect() {
    final access =
        VAppPref.getHashedString(key: VStorageKeys.vAccessToken.name) ?? "";
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

  void handleOnGetMyOnlineList(List<VOnlineOfflineModel> dataModelList) {
    return _localRoom.updateRoomOnline(dataModelList);
  }

  void handleOnEnterChatRoom(VSocketOnRoomSeenModel model) {
    unawaited(
      _localMessage.updateMessagesSetSeen(
        VUpdateMessageSeenEvent(
          roomId: model.roomId,
          localId: model.roomId,
          model: model,
        ),
      ),
    );
  }

  void handleOnDeliverRoomMessages(VSocketOnDeliverMessagesModel model) {
    unawaited(
      _localMessage.updateMessagesSetDeliver(
        VUpdateMessageDeliverEvent(
          roomId: model.roomId,
          localId: model.roomId,
          model: model,
        ),
      ),
    );
  }

  Future<void> handleOnRoomTypingChanged(VSocketRoomTypingModel x) async {
    if (!x.isMe) {
      await _localRoom.updateRoomTyping(x);
    }
  }

  Future<void> handleOnSingleRoomBan(VSingleBlockModel ban) async {
    await _localRoom.updateRoomBlock(ban);
  }

  Future<void> updateMessageToAllDeleted(VBaseMessage msg) async {
    await _localMessage.updateMessageToAllDeleted(
      VUpdateMessageAllDeletedEvent(
        roomId: msg.roomId,
        localId: msg.localId,
        message: msg,
      ),
    );
  }

  Future handleOnGroupKick(
    Map<String, dynamic> data,
  ) async {
    final roomId = data['roomId'] as String;
    final userId = data['userId'] as String;
    if (VAppConstants.myProfile.baseUser.vChatId == userId) {
      //push block
      _emitter.fire(
        VOnGroupKicked(
          roomId: roomId,
        ),
      );
    }
  }

  void handleNewCall(VNewCallModel vOnNewCall) {
    _emitter.fire(
      VOnNewCallEvent(
        roomId: vOnNewCall.roomId,
        data: vOnNewCall,
      ),
    );
  }

  void handleCallTimeout(String roomId) {
    _emitter.fire(VCallTimeoutEvent(roomId: roomId));
  }

  void handleCallAccepted(VOnAcceptCall onAcceptCall) {
    _emitter.fire(
      VCallAcceptedEvent(
        roomId: onAcceptCall.roomId,
        data: onAcceptCall,
      ),
    );
  }

  void handleCallEnded(String roomId) {
    _emitter.fire(VCallEndedEvent(roomId: roomId));
  }

  void handleCallCanceled(String roomId) {
    _emitter.fire(VCallCanceledEvent(roomId: roomId));
  }

  void handleCallRejected(String roomId) {
    _emitter.fire(VCallRejectedEvent(roomId: roomId));
  }

  void handleOnIce(Map<String, dynamic> res) {
    _emitter.fire(
      VOnRtcIceEvent(
        roomId: "roomId",
        data: res['data'] as Map<String, dynamic>,
      ),
    );
  }
}
