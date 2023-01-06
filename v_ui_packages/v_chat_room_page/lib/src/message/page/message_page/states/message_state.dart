import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:v_chat_room_page/src/message/core/extentions.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../message_provider.dart';

class MessageStateController extends ValueNotifier<List<VBaseMessage>>
    with VSocketStatusStream {
  final VRoom _vRoom;
  final bool isInTesting;
  final MessageProvider _messageProvider;

  MessageStateController(
    this._vRoom,
    this._messageProvider,
    this.isInTesting,
  ) : super(<VBaseMessage>[]) {
    initSocketStatusStream(
      VChatController.I.nativeApi.streams.socketStatusStream,
    );
    _initLocalMessages();
  }

  List<VBaseMessage> get stateMessages => value;
  final messageStateStream = StreamController<VBaseMessage>.broadcast();

  bool get isMessagesEmpty => stateMessages.isEmpty;

  String get lastMessageId => stateMessages.last.id;

  void insertAll(List<VBaseMessage> messages) {
    value = messages.sortById();
  }

  void updateCacheState(List<VBaseMessage> apiMessages) {
    final stateMessages = value;
    final newList = <VBaseMessage>[];

    newList.addAll(apiMessages);
    newList.addAll(
      stateMessages.where((e) => e.messageStatus.isSendingOrError),
    );
    //we need to sort
    value = newList.sortById();
  }

  void insertMessage(VBaseMessage messageModel) {
    if (!stateMessages.contains(messageModel)) {
      value.insert(0, messageModel);
      notifyListeners();
    } else {
      print(
          "-------------you are try to insert message which already exist!-----------");
    }
  }

  void updateMessage(VBaseMessage messageModel) {
    final msgIndex = stateMessages.indexOf(messageModel);
    if (msgIndex != -1) {
      //full update
      value[msgIndex] = messageModel;
      messageStateStream.sink.add(messageModel);
    } else {
      print(
          "----------------you are try to update message which Not exist!--------------");
    }
  }

  void close() {
    messageStateStream.close();
    dispose();
    closeSocketStatusStream();
  }

  void deleteMessage(String localId) {
    value.removeWhere((e) => e.localId == localId);
    notifyListeners();
  }

  void updateMessageType(String localId, MessageType messageType) {
    value
        .firstWhereOrNull(
          (e) => e.localId == localId,
        )
        ?.messageType = messageType;
    notifyListeners();
  }

  void updateMessageStatus(String localId, MessageEmitStatus emitState) {
    value
        .firstWhereOrNull(
          (e) => e.localId == localId,
        )
        ?.messageStatus = emitState;
    notifyListeners();
  }

  void seenAll(VSocketOnRoomSeenModel model) {
    for (int i = 0; i < stateMessages.length; i++) {
      stateMessages[i].seenAt ??= model.date;
      stateMessages[i].deliveredAt ??= model.date;
    }
    notifyListeners();
  }

  void deliverAll(VSocketOnDeliverMessagesModel model) {
    for (int i = 0; i < stateMessages.length; i++) {
      stateMessages[i].deliveredAt ??= model.date;
    }
    notifyListeners();
  }

  @override
  void onSocketConnected() {
    //todo improve the call here
    getApiMessages();
    _messageProvider.setSeen(_vRoom.id);
  }

  Future<void> getApiMessages() async {
    await vSafeApiCall<List<VBaseMessage>>(
      request: () async {
        if (isInTesting) {
          return await _messageProvider.getFakeApiMessages();
        } else {
          return _messageProvider.getApiMessages(
            roomId: _vRoom.id,
            dto: const VRoomMessagesDto(
              limit: 20,
            ),
          );
        }
      },
      onSuccess: (response) {
        updateCacheState(response);
      },
    );
  }

  Future<void> _initLocalMessages() async {
    await vSafeApiCall<List<VBaseMessage>>(
      request: () async {
        if (isInTesting) {
          return await _messageProvider.getFakeLocalMessages();
        } else {
          return _messageProvider.getLocalMessages(roomId: _vRoom.id);
        }
      },
      onSuccess: (response) {
        insertAll(response);
      },
    );
    await getApiMessages();
  }

  void emitSeenFor(String roomId) {
    _messageProvider.setSeen(roomId);
  }
}
