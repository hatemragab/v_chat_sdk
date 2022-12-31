import 'dart:async';

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../assets/data/api_messages.dart';
import '../../assets/data/local_messages.dart';

class MessageProvider {
  final _remoteMessage = VChatController.I.nativeApi.remote.remoteMessage;
  final _localMessage = VChatController.I.nativeApi.local.message;

  Future<List<VBaseMessage>> getFakeLocalMessages() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return fakeLocalMessages
        .map((e) => MessageFactory.createBaseMessage(e))
        .toList();
  }

  Future<List<VBaseMessage>> getFakeApiMessages() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return fakeApiMessages
        .map((e) => MessageFactory.createBaseMessage(e))
        .toList();
  }

  Future<List<VBaseMessage>> getLocalMessages({
    required String roomId,
    String? lastId,
  }) async {
    return _localMessage.getRoomMessages(
      roomId: roomId,
      lastId: lastId,
    );
  }

  Future<List<VBaseMessage>> getApiMessages({
    required String roomId,
    required VRoomMessagesDto dto,
  }) async {
    final apiMessages = await _remoteMessage.getRoomMessages(
      roomId: roomId,
      dto: dto,
    );
    unawaited(_localMessage.cacheRoomMessages(apiMessages));
    return apiMessages;
  }
}
