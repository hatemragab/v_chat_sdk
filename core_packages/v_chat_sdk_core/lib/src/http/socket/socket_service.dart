// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:logging/logging.dart';
import 'package:v_chat_sdk_core/src/http/socket/socket_io_client.dart';
import 'package:v_chat_sdk_core/src/native_api/local/native_local_message.dart';
import 'package:v_chat_sdk_core/src/native_api/local/native_local_room.dart';
import 'package:v_chat_sdk_core/src/utils/api_constants.dart';
import 'package:v_chat_sdk_core/src/utils/app_pref.dart';
import 'package:v_chat_sdk_core/src/utils/enums.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class SocketService {
  // Logger instance for logging events in this service
  final _log = Logger('SocketService');

  // Access to the native API interface
  final _nativeApi = VNativeApi.I;

  // Interface to the SocketIO client
  final SocketIoClient _socketIoClient;

  // Access to local room data
  NativeLocalRoom get _localRoom => _nativeApi.local.room;

  // Access to local message data
  NativeLocalMessage get _localMessage => _nativeApi.local.message;

  // SocketService constructor
  SocketService(this._socketIoClient);

  // Returns the connection status of the socket
  bool get isSocketConnected => _socketIoClient.socket.connected;

  // Event bus instance for event emitting
  final _emitter = VEventBusSingleton.vEventBus;

  /// Handles the connection to the SocketIO server.
  /// Adds the authorization token to the connection if available.
  void handleConnect() {
    final access =
        VAppPref.getHashedString(key: VStorageKeys.vAccessToken.name) ?? "";
    if (access.isNotEmpty) {
      _socketIoClient.socket.io.options = {
        ..._socketIoClient.socket.io.options ?? {},
        "query": "auth=Bearer%20$access",
        "extraHeaders": {
          ..._socketIoClient.socket.io.options?['extraHeaders']
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

  /// Handles the receipt of a new message, saving it to local storage.
  /// If the sender is not the current user, increments the unread count of the room.
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

  /// Updates the online status of the rooms based on the provided data model list.
  void handleOnGetMyOnlineList(List<VOnlineOfflineModel> dataModelList) {
    return _localRoom.updateRoomOnline(dataModelList);
  }

  /// Updates the seen status of the messages in the room based on the provided model.
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

  /// Updates the delivered status of the messages in the room based on the provided model.
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

  /// Handles changes in the typing status in a room.
  /// If the typing status is not for the current user, updates the local room typing status.
  Future<void> handleOnRoomTypingChanged(VSocketRoomTypingModel x) async {
    if (!x.isMe) {
      await _localRoom.updateRoomTyping(x);
    }
  }

  /// Handles the single room ban event, updating the local room ban status based on the provided model.
  Future<void> handleOnSingleRoomBan(VSingleBlockModel ban) async {
    await _localRoom.updateRoomBlock(ban);
  }

  /// Updates a message's status to "deleted form all" based on the provided message.
  Future<void> updateMessageToAllDeleted(VBaseMessage msg) async {
    await _localMessage.updateMessageToAllDeleted(
      VUpdateMessageAllDeletedEvent(
        roomId: msg.roomId,
        localId: msg.localId,
        message: msg,
      ),
    );
  }

  /// Handles a group kick event.
  /// If the current user is the one who got kicked, it fires a group kicked event.
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

  /// Handles a new call event, firing a new call event for the room.
  void handleNewCall(VNewCallModel vOnNewCall) {
    _emitter.fire(
      VOnNewCallEvent(
        roomId: vOnNewCall.roomId,
        data: vOnNewCall,
      ),
    );
  }

  /// Handles a call timeout event, firing a call timeout event for the room.
  void handleCallTimeout(String roomId) {
    _emitter.fire(VCallTimeoutEvent(roomId: roomId));
  }

  /// Handles a call acceptance event, firing a call acceptance event for the room.
  void handleCallAccepted(VOnAcceptCall onAcceptCall) {
    _emitter.fire(
      VCallAcceptedEvent(
        roomId: onAcceptCall.roomId,
        data: onAcceptCall,
      ),
    );
  }

  /// Handles a call end event, firing a call end event for the room.
  void handleCallEnded(String roomId) {
    _emitter.fire(VCallEndedEvent(roomId: roomId));
  }

  /// Handles a call cancel event, firing a call cancel event for the room.
  void handleCallCanceled(String roomId) {
    _emitter.fire(VCallCanceledEvent(roomId: roomId));
  }

  /// Handles a call rejection event, firing a call rejection event for the room.
  void handleCallRejected(String roomId) {
    _emitter.fire(VCallRejectedEvent(roomId: roomId));
  }

  /// Handles an ICE candidate event, firing an ICE event for the room.
  void handleOnIce(Map<String, dynamic> res) {
    _emitter.fire(
      VOnRtcIceEvent(
        roomId: "roomId",
        data: res['data'] as Map<String, dynamic>,
      ),
    );
  }
}
