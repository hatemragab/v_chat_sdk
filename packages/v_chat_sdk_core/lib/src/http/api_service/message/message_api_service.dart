import 'dart:async';
import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:logging/logging.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../../v_chat_sdk_core.dart';
import '../../../models/v_message/core/message_factory.dart';
import '../../../utils/api_constants.dart';
import '../../dto/v_room_messages_dto.dart';
import '../interceptors.dart';
import 'message_api.dart';

class MessageApiService {
  static late final MessageApi _messageApi;
  final _log = Logger('MessageApiService');

  MessageApiService._();

  Future<List<VBaseMessage>> getRoomMessages({
    required String roomId,
    required VRoomMessagesDto dto,
  }) async {
    final res = await _messageApi.getRoomMessages(
      roomId,
      dto.toMap(),
    );
    throwIfNotSuccess(res);
    final data = extractDataFromResponse(res);
    final docs = data['docs'] as List;
    return docs
        .map((e) => MessageFactory.createBaseMessage(
              e as Map<String, dynamic>,
            ))
        .toList();
  }

  Future<bool> deleteMessageFromMe(
    String roomId,
    String messageId,
  ) async {
    final res = await _messageApi.deleteMessageFromMe(roomId, messageId);
    throwIfNotSuccess(res);
    return true;
  }

  Future<dynamic> getMessageStatusSummary(
    String roomId,
    String messageId,
  ) async {
    final res = await _messageApi.getMessageStatusSummary(
      roomId,
      messageId,
    );
    throwIfNotSuccess(res);
    // return MessageStatusSummary.fromMap(
    //   (res.body as Map<String, dynamic>)['data'] as Map<String, dynamic>,
    // );
  }

  Future<bool> deleteMessageFromAll(
    String roomId,
    String mId,
  ) async {
    final res = await _messageApi.deleteMessageFromAll(roomId, mId);
    throwIfNotSuccess(res);
    return true;
  }

  Future<VBaseMessage> createMessage(
    VMessageUploadModel messageModel,
  ) async {
    late Response res;
    try {
      res = await _messageApi.createMessage(
        messageModel.roomId,
        messageModel.body,
        messageModel.file1,
        messageModel.file2,
      );
    } on SocketException {
      throw VUserInternetException(exception: "SocketException");
    } on TimeoutException {
      throw VUserInternetException(exception: "TimeoutException");
    }
    throwIfNotSuccess(res);
    return MessageFactory.createBaseMessage(extractDataFromResponse(res));
  }

  //todo fix
  Future<List<dynamic>> getMessageStatus(
    String roomId,
    String messageId,
    Map<String, Object> pagination, {
    required bool isSeen,
  }) async {
    final Response res = await _messageApi.getMessageStatus(
      roomId,
      messageId,
      pagination,
      isSeen ? "seen" : "deliver",
    );

    throwIfNotSuccess(res);
    // final resList = (res.body as Map<String, dynamic>)['data'] as List;
    // return resList
    //     .map((e) => MessageStatusModel.fromMap(e as Map<String, dynamic>))
    //     .toList();

    return [];
  }

  static MessageApiService init({
    Uri? baseUrl,
    String? accessToken,
  }) {
    _messageApi = MessageApi.create(
      accessToken: accessToken,
      baseUrl: baseUrl ?? VAppConstants.baseUri,
    );
    return MessageApiService._();
  }
}
