import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:v_chat_message_page/src/core/extentions.dart';
import 'package:v_chat_sdk_core/src/models/socket/on_deliver_room_messages_model.dart';
import 'package:v_chat_sdk_core/src/models/socket/on_enter_room_model.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class MessageState {
  final stateNotifier = ValueNotifier<List<VBaseMessage>>(
    <VBaseMessage>[],
  );

  List<VBaseMessage> get stateMessages => stateNotifier.value;
  final messageStateStream = StreamController<VBaseMessage>.broadcast();

  bool get isMessagesEmpty => stateMessages.isEmpty;

  String get lastMessageId => stateMessages.last.id;

  void updateCacheState(List<VBaseMessage> apiMessages) {
    final stateMessages = stateNotifier.value;
    final newList = <VBaseMessage>[];

    newList.addAll(apiMessages);
    newList.addAll(
      stateMessages.where((e) => e.messageStatus.isSendingOrError),
    );
    //we need to sort
    stateNotifier.value = newList.sortById();
  }

  void insertMessage(VBaseMessage messageModel) {
    if (!stateMessages.contains(messageModel)) {
      stateNotifier.value.insert(0, messageModel);
      stateNotifier.notifyListeners();
    } else {
      print(
          "-------------you are try to insert message which already exist!-----------");
    }
  }

  void updateMessage(VBaseMessage messageModel) {
    final msgIndex = stateMessages.indexOf(messageModel);
    if (msgIndex != -1) {
      //full update
      stateNotifier.value[msgIndex] = messageModel;
      messageStateStream.sink.add(messageModel);
    } else {
      print(
          "----------------you are try to update message which Not exist!--------------");
    }
  }

  void close() {
    messageStateStream.close();
    stateNotifier.dispose();
  }

  void deleteMessage(String localId) {
    stateNotifier.value.removeWhere((e) => e.localId == localId);
    stateNotifier.notifyListeners();
  }

  void updateMessageType(String localId, MessageType messageType) {
    stateNotifier.value
        .firstWhereOrNull(
          (e) => e.localId == localId,
        )
        ?.messageType = messageType;
    stateNotifier.notifyListeners();
  }

  void updateMessageStatus(String localId, MessageEmitStatus emitState) {
    stateNotifier.value
        .firstWhereOrNull(
          (e) => e.localId == localId,
        )
        ?.messageStatus = emitState;
    stateNotifier.notifyListeners();
  }

  void seenAll(VSocketOnRoomSeenModel model) {
    for (int i = 0; i < stateMessages.length; i++) {
      stateMessages[i].seenAt ??= model.date;
      stateMessages[i].deliveredAt ??= model.date;
    }
    stateNotifier.notifyListeners();
  }

  void deliverAll(VSocketOnDeliverMessagesModel model) {
    for (int i = 0; i < stateMessages.length; i++) {
      stateMessages[i].deliveredAt ??= model.date;
    }
    stateNotifier.notifyListeners();
  }
}
