// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../../../v_chat_message_page.dart';
import '../../providers/message_provider.dart';

class MessageStateController extends ValueNotifier<List<VBaseMessage>>
    with VSocketStatusStream {
  final VRoom vRoom;
  final BuildContext context;
  final MessageProvider messageProvider;
  final AutoScrollController scrollController;
  LoadMoreStatus _loadingStatus = LoadMoreStatus.loaded;

  MessageStateController({
    required this.vRoom,
    required this.messageProvider,
    required this.context,
    required this.scrollController,
  }) : super(<VBaseMessage>[]) {
    initSocketStatusStream(
      VChatController.I.nativeApi.streams.socketStatusStream,
    );
    getMessagesFromLocal();
    unawaited(getMessagesFromRemote(_initFilterDto));
    scrollController.addListener(_loadMoreListener);
  }

  void _initLoadMore() {
    _loadingStatus = LoadMoreStatus.loaded;
    _filterDto.lastId = null;
  }

  List<VBaseMessage> get stateMessages => value;
  final messageStateStream = StreamController<VBaseMessage>.broadcast();

  bool get isMessagesEmpty => stateMessages.isEmpty;

  String get lastMessageId => stateMessages.last.id;
  final _initFilterDto = VRoomMessagesDto(
    limit: 30,
    lastId: null,
  );
  final _filterDto = VRoomMessagesDto(
    limit: 30,
    lastId: null,
  );

  void insertAllMessages(List<VBaseMessage> messages) {
    value = sort(messages);
  }

  void updateApiMessages(List<VBaseMessage> apiMessages) {
    if (apiMessages.isEmpty) return;
    final stateMessages = value;
    final newList = <VBaseMessage>[];
    newList.addAll(apiMessages);
    newList.addAll(
      stateMessages.where((e) => e.emitStatus.isSendingOrError),
    );
    //we need to sort
    if (context.mounted) {
      value = sort(newList);
    }
  }

  List<VBaseMessage> sort(List<VBaseMessage> messages) {
    messages.sort((a, b) {
      return b.id.compareTo(a.id);
    });
    return messages;
  }

  void insertMessage(VBaseMessage messageModel) {
    if (!stateMessages.contains(messageModel)) {
      value.insert(0, messageModel);
      notifyListeners();
    } else {
      if (kDebugMode) {
        print(
            "-------------you are try to insert message which already exist!-----------");
      }
    }
  }

  void updateMessage(VBaseMessage messageModel) {
    final msgIndex = stateMessages.indexOf(messageModel);
    if (msgIndex != -1) {
      //full update
      value[msgIndex] = messageModel;
      messageStateStream.sink.add(messageModel);
    } else {
      if (kDebugMode) {
        print(
            "----------------you are try to update message which Not exist!--------------");
      }
    }
  }

  void close() {
    messageStateStream.close();
    dispose();
    closeSocketStatusStream();
  }

  int _indexByLocalId(String localId) =>
      value.indexWhere((e) => e.localId == localId);

  void deleteMessage(String localId) {
    final index = _indexByLocalId(localId);
    if (index != -1) {
      value[index].isDeleted = true;
      messageStateStream.add(value[index]);
    }
  }

  void updateMessageType(
    String localId,
    VMessageType messageType,
  ) {
    final index = _indexByLocalId(localId);
    if (index != -1) {
      if (messageType.isAllDeleted) {
        value[index].messageType = messageType;
        final deletedMessage =
            VAllDeletedMessage.fromRemoteMap(value[index].toRemoteMap());
        value[index] = deletedMessage;
        messageStateStream.add(deletedMessage);
      }
    }
  }

  void updateMessageStatus(String localId, VMessageEmitStatus emitState) {
    final index = _indexByLocalId(localId);
    if (index != -1) {
      value[index].emitStatus = emitState;
      messageStateStream.add(value[index]);
    }
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
    getMessagesFromRemote(_initFilterDto);
    messageProvider.setSeen(vRoom.id);
  }

  Future<void> getMessagesFromRemote(
    VRoomMessagesDto dto,
  ) async {
    await VChatController.I.nativeApi.remote.socketIo.socketCompleter.future;
    await vSafeApiCall<List<VBaseMessage>>(
      request: () async {
        return messageProvider.getApiMessages(
          roomId: vRoom.id,
          dto: dto,
        );
      },
      onSuccess: (response) {
        updateApiMessages(response);
      },
    );
  }

  Future<void> getMessagesFromLocal() async {
    await vSafeApiCall<List<VBaseMessage>>(
      request: () async {
        return messageProvider.getLocalMessages(
          roomId: vRoom.id,
          filter: _initFilterDto,
        );
      },
      onSuccess: (response) {
        insertAllMessages(response);
      },
    );
  }

  void emitSeenFor(String roomId) {
    messageProvider.setSeen(roomId);
  }

  bool get requireLoadMoreMessages =>
      _loadingStatus != LoadMoreStatus.loading &&
      _loadingStatus != LoadMoreStatus.completed;

  void _loadMoreListener() {
    final maxScrollExtent = scrollController.position.maxScrollExtent / 2;
    if (scrollController.offset > maxScrollExtent && requireLoadMoreMessages) {
      loadMoreMessages();
    }
  }

  Future<List<VBaseMessage>?> loadMoreMessages() async {
    _loadingStatus = LoadMoreStatus.loading;
    _filterDto.lastId = value.last.id;
    final localLoadedMessages = await messageProvider.getLocalMessages(
      roomId: vRoom.id,
      filter: _filterDto,
    );
    if (localLoadedMessages.isEmpty) {
      ///if no more data ask server for it
      return await vSafeApiCall<List<VBaseMessage>>(
        request: () async {
          return messageProvider.getApiMessages(
            roomId: vRoom.id,
            dto: _filterDto,
          );
        },
        onSuccess: (response) {
          if (response.isEmpty) {
            _loadingStatus = LoadMoreStatus.completed;
            return null;
          }
          _loadingStatus = LoadMoreStatus.loaded;
          value.addAll(response);
          notifyListeners();
          return response;
        },
      );
    }
    _loadingStatus = LoadMoreStatus.loaded;
    value.addAll(localLoadedMessages);
    notifyListeners();
    return localLoadedMessages;
  }

  Future<void> loadUntil(VBaseMessage message) async {
    await vSafeApiCall<List<VBaseMessage>>(
      request: () async {
        return messageProvider.getLocalMessages(
          roomId: vRoom.id,
          filter: VRoomMessagesDto(
            between: VMessageBetweenFilter(
              lastId: value.last.id,
              targetId: message.id,
            ),
          ),
        );
      },
      onSuccess: (response) {
        value.insertAll(0, response);
        notifyListeners();
      },
    );
  }

  void messageSearch(String text) async {
    final searchMessages = await messageProvider.search(vRoom.id, text);
    value = searchMessages;
    notifyListeners();
  }

  void resetMessages() {
    _initLoadMore();
    getMessagesFromLocal();
  }
}
