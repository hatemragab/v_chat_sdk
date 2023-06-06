// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:logging/logging.dart';
import 'package:v_chat_sdk_core/src/exceptions/http/v_chat_http_exception.dart';
import 'package:v_chat_sdk_core/src/models/v_chat_base_exception.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class MessageUploaderQueue {
  final _uploadQueue = <VMessageUploadModel>[];
  final _localStorage = VChatController.I.nativeApi.local.message;
  final _remoteStorage = VChatController.I.nativeApi.remote;
  final _log = Logger("MessageUploaderQueue");

  /// Singleton pattern
  MessageUploaderQueue._();

  /// Singleton instance
  static final _instance = MessageUploaderQueue._();

  /// Getter for singleton instance
  static MessageUploaderQueue get instance {
    return _instance;
  }

  /// Add a message to the queue and send it to the API
  /// [uploadModel] is the model of the message to be uploaded
  Future<void> addToQueue(VMessageUploadModel uploadModel) async {
    if (!_uploadQueue.contains(uploadModel)) {
      _uploadQueue.add(uploadModel);
      await _sendToApi(uploadModel);
    }
  }

  /// Send the message to the API, handle errors and remove message from queue
  /// [uploadModel] is the model of the message to be sent
  Future<void> _sendToApi(VMessageUploadModel uploadModel) async {
    _setSending(uploadModel);
    try {
      final msg = await _remoteStorage.message.createMessage(uploadModel);
      await _onSuccessToSend(msg);
    } catch (e) {
      if (e is VChatHttpForbidden || e is VChatBaseHttpException) {
        _log.warning("VChatBaseHttpException", e);
        await _deleteTheMessage(uploadModel);
      } else if (e is VUserInternetException) {
        _log.info("UserInternetExceptionUserInternetException", e);
        await _setErrorToMessage(uploadModel);
      } else {
        _log.warning("_onUnknownException", e);
        await _deleteTheMessage(uploadModel);
      }
    } finally {
      _uploadQueue.remove(uploadModel);
    }
  }

  /// Delete a message by its local id
  /// [localId] is the local id of the message to be deleted
  Future<void> _deleteMessage(String localId) async {
    final baseMessage = await _localStorage.getMessageByLocalId(localId);
    if (baseMessage != null && !baseMessage.emitStatus.isServerConfirm) {
      await _localStorage.deleteMessageByLocalId(baseMessage);
    }
  }

  /// Set the message status to error
  /// [uploadModel] is the model of the message with an error
  Future _setErrorToMessage(VMessageUploadModel uploadModel) async {
    final VBaseMessage? baseMessage =
        await _localStorage.getMessageByLocalId(uploadModel.msgLocalId);
    if (baseMessage != null) {
      baseMessage.emitStatus = VMessageEmitStatus.error;
      await _localStorage.updateMessageSendingStatus(
        VUpdateMessageStatusEvent(
          roomId: baseMessage.roomId,
          localId: baseMessage.localId,
          emitState: baseMessage.emitStatus,
        ),
      );
    }
  }

  /// Delete a message from the queue
  /// [uploadModel] is the model of the message to be deleted
  Future _deleteTheMessage(VMessageUploadModel uploadModel) async {
    await _deleteMessage(uploadModel.msgLocalId);
  }

  /// Update the local message status to success upon successful send
  /// [messageModel] is the model of the successfully sent message
  Future _onSuccessToSend(VBaseMessage messageModel) async {
    await _localStorage.updateFullMessage(messageModel);
  }

  /// Clear the queue of all messages
  void clearQueue() {
    _uploadQueue.clear();
  }

  /// Set the message status to sending
  /// [uploadModel] is the model of the message that is being sent
  Future<void> _setSending(VMessageUploadModel uploadModel) async {
    await _localStorage.updateMessageSendingStatus(
      VUpdateMessageStatusEvent(
        roomId: uploadModel.roomId,
        localId: uploadModel.msgLocalId,
        emitState: VMessageEmitStatus.sending,
      ),
    );
  }
}
