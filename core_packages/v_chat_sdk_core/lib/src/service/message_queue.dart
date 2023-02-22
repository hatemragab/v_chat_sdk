// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:logging/logging.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class MessageUploaderQueue {
  final _uploadQueue = <VMessageUploadModel>[];
  final _localStorage = VChatController.I.nativeApi.local.message;
  final _remoteStorage = VChatController.I.nativeApi.remote;
  final _log = Logger("MessageUploaderQueue");

  ///singleton
  MessageUploaderQueue._();

  static MessageUploaderQueue get instance {
    return _instance;
  }

  static final _instance = MessageUploaderQueue._();

  Future<void> addToQueue(VMessageUploadModel uploadModel) async {
    if (!_uploadQueue.contains(uploadModel)) {
      _uploadQueue.add(uploadModel);
      await _sendToApi(uploadModel);
    }
  }

  Future<void> _sendToApi(VMessageUploadModel uploadModel) async {
    try {
      _setSending(uploadModel);
      final msg = await _remoteStorage.message.createMessage(
        uploadModel,
      );
      _onSuccessToSend(msg);
    } on VChatHttpForbidden {
      await _deleteTheMessage(uploadModel);
      // rethrow;
    } on VChatBaseHttpException catch (err) {
      await _deleteTheMessage(uploadModel);
      print(err);
      _log.warning("VChatBaseHttpException", err);
    } on VUserInternetException catch (err) {
      await _setErrorToMessage(uploadModel);
      _log.info("UserInternetExceptionUserInternetException", err);
    } catch (err) {
      await _deleteTheMessage(uploadModel);
      _log.warning("_onUnknownException", err);
      // rethrow;
    } finally {
      _uploadQueue.remove(uploadModel);
    }
  }

  Future<void> _deleteMessage(String localId) async {
    final VBaseMessage? baseMessage =
        await _localStorage.getMessageByLocalId(localId);
    if (baseMessage != null) {
      await _localStorage.deleteMessageByLocalId(baseMessage);
    }
  }

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

  Future _deleteTheMessage(VMessageUploadModel uploadModel) async {
    await _deleteMessage(uploadModel.msgLocalId);
  }

  Future _onSuccessToSend(VBaseMessage messageModel) async {
    await _localStorage.updateFullMessage(
      messageModel,
    );
  }

  void clearQueue() {
    _uploadQueue.clear();
  }

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
