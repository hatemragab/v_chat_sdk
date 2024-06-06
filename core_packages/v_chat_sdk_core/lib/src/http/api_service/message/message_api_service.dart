// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:v_chat_sdk_core/src/http/api_service/interceptors.dart';
import 'package:v_chat_sdk_core/src/http/api_service/message/message_api.dart';
import 'package:v_chat_sdk_core/src/models/v_chat_base_exception.dart';
import 'package:v_chat_sdk_core/src/utils/api_constants.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class VMessageApiService {
  static MessageApi? _messageApi; // Static instance of the Message API.

  VMessageApiService._(); // Private constructor to prevent direct instantiation.

  // Asynchronously get messages in a room.
  Future<List<VBaseMessage>> getRoomMessages({
    required String roomId,
    required VRoomMessagesDto dto,
  }) async {
    final res = await _messageApi!.getRoomMessages(
      roomId,
      dto.toMap(),
    );
    throwIfNotSuccess(res); // Throw if the response indicates failure.
    final data =
        extractDataFromResponse(res); // Extract data from the response.
    final docs = data['docs'] as List;
    return docs
        .map(
          (e) => MessageFactory.createBaseMessage(
            e as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<List<VBaseMessage>> getStarRoomMessages({
    required String roomId,
  }) async {
    final res = await _messageApi!.getStarMessages(
      roomId,
    );
    throwIfNotSuccess(res);
    final data = extractDataFromResponse(res);
    final docs = data['docs'] as List;
    return docs
        .map(
          (e) => MessageFactory.createBaseMessage(
            e as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<bool> starMessage(
    String roomId,
    String messageId,
  ) async {
    final res = await _messageApi!.starMessage(roomId, messageId);
    throwIfNotSuccess(res);
    return true;
  }

  Future<bool> addOneSeen({
    required String roomId,
    required String messageId,
  }) async {
    final res = await _messageApi!.addOneSeen(roomId, messageId);
    throwIfNotSuccess(res);
    return true;
  }

  Future<bool> unStarMessage(
    String roomId,
    String messageId,
  ) async {
    final res = await _messageApi!.unStarMessage(roomId, messageId);
    throwIfNotSuccess(res);
    return true;
  }

  // Asynchronously delete a message from me.
  Future<bool> deleteMessageFromMe(
    String roomId,
    String messageId,
  ) async {
    final res = await _messageApi!.deleteMessageFromMe(roomId, messageId);
    throwIfNotSuccess(res);
    return true;
  }

  // Asynchronously delete a message from all participants in a room.
  Future<bool> deleteMessageFromAll(
    String roomId,
    String mId,
  ) async {
    final res = await _messageApi!.deleteMessageFromAll(roomId, mId);
    throwIfNotSuccess(res);
    return true;
  }

  // Asynchronously create a message.
  Future<VBaseMessage> createMessage(
    VMessageUploadModel messageModel,
  ) async {
    late Response res;
    try {
      res = await _messageApi!.createMessage(
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

  static VMessageApiService init({
    Uri? baseUrl,
    String? accessToken,
  }) {
    _messageApi ??= MessageApi.create(
      accessToken: accessToken,
      baseUrl: baseUrl ?? VAppConstants.baseUri,
    );
    return VMessageApiService._();
  }
}
