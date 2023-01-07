import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:v_chat_room_page/src/message/core/extentions.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../../../v_chat_room_page.dart';
import '../message_provider.dart';

class MessageStateController extends ValueNotifier<List<VBaseMessage>>
    with VSocketStatusStream {
  final VRoom _vRoom;
  final BuildContext context;
  final bool isInTesting;
  final MessageProvider _messageProvider;
  final ScrollController scrollController;
  LoadMoreStatus _loadingStatus = LoadMoreStatus.loaded;

  MessageStateController(
    this._vRoom,
    this._messageProvider,
    this.isInTesting,
    this.context,
    this.scrollController,
  ) : super(<VBaseMessage>[]) {
    initSocketStatusStream(
      VChatController.I.nativeApi.streams.socketStatusStream,
    );
    _initLocalMessages();
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

  void insertAll(List<VBaseMessage> messages) {
    value = messages.sortById();
  }

  void _updateCacheState(List<VBaseMessage> apiMessages) {
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

  VBaseMessage? _messageByLocalId(String localId) =>
      value.firstWhereOrNull((e) => e.localId == localId);

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
    MessageType messageType,
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

  void updateMessageStatus(String localId, MessageEmitStatus emitState) {
    final index = _indexByLocalId(localId);
    if (index != -1) {
      value[index].messageStatus = emitState;
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
    //todo improve the call here
    _getApiMessages(_initFilterDto);
    _messageProvider.setSeen(_vRoom.id);
  }

  Future<void> _getApiMessages(
    VRoomMessagesDto dto,
  ) async {
    await vSafeApiCall<List<VBaseMessage>>(
      request: () async {
        if (isInTesting) {
          return await _messageProvider.getFakeApiMessages();
        } else {
          return _messageProvider.getApiMessages(
            roomId: _vRoom.id,
            dto: dto,
          );
        }
      },
      onSuccess: (response) {
        _updateCacheState(response);
      },
    );
  }

  Future<void> _initLocalMessages() async {
    await vSafeApiCall<List<VBaseMessage>>(
      request: () async {
        if (isInTesting) {
          return await _messageProvider.getFakeLocalMessages();
        } else {
          return _messageProvider.getLocalMessages(
            roomId: _vRoom.id,
            filter: _initFilterDto,
          );
        }
      },
      onSuccess: (response) {
        insertAll(response);
      },
    );
    await _getApiMessages(_initFilterDto);
  }

  void emitSeenFor(String roomId) {
    _messageProvider.setSeen(roomId);
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
    final localLoadedMessages = await _messageProvider.getLocalMessages(
      roomId: _vRoom.id,
      filter: _filterDto,
    );
    if (localLoadedMessages.isEmpty) {
      ///if no more data ask server for it
      return await vSafeApiCall<List<VBaseMessage>>(
        request: () async {
          return _messageProvider.getApiMessages(
            roomId: _vRoom.id,
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

  Future loadUntil(VBaseMessage message) async {
    await vSafeApiCall<List<VBaseMessage>>(
      request: () async {
        return _messageProvider.getLocalMessages(
          roomId: _vRoom.id,
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

  void onSearch(String text) async {
    final searchMessages = await _messageProvider.search(_vRoom.id, text);
    value = searchMessages;
    notifyListeners();
  }

  void onCloseSearch() {
    _initLoadMore();
    _initLocalMessages();
  }
}
