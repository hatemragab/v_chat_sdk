// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:uuid/uuid.dart';
import 'package:v_chat_media_editor/v_chat_media_editor.dart';
import 'package:v_chat_message_page/src/core/extension.dart';
import 'package:v_chat_message_page/src/page/message_pages/controllers/v_message_item_controller.dart';
import 'package:v_chat_message_page/src/page/message_pages/controllers/v_voice_controller.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../../../v_chat_message_page.dart';
import '../../../v_chat/string_utils.dart';
import '../pasteboard/file_convertor.dart';
import '../pasteboard/pasteboard.dart';
import '../states/input_state_controller.dart';
import '../states/message_state/message_state_controller.dart';

abstract class VBaseMessageController extends MessageStateController
    with StreamMix {
  final focusNode = FocusNode();
  final vConfig = VChatController.I.vChatConfig;
  final InputStateController inputStateController;
  final VMessageItemController itemController;
  final events = VEventBusSingleton.vEventBus;
  final VMessageConfig vMessageConfig;
  final uuid = const Uuid();

  VBaseMessageController({
    required super.vRoom,
    required super.messageProvider,
    required super.context,
    required super.scrollController,
    required this.inputStateController,
    required this.vMessageConfig,
    required this.itemController,
  }) {
    messageProvider.setSeen(roomId);
    VRoomTracker.instance.addToOpenRoom(roomId: roomId);
    _removeAllNotifications();
    _setUpVoiceController();
    _initMessagesStreams();
    _setUpPasteboardStreamListener();
  }

  StreamSubscription? clipboardSubscription;
  late final VVoicePlayerController voiceControllers;

  String get roomId => vRoom.id;
  final IPasteboard pasteboard = Pasteboard(FileConvertor());

  void onTitlePress(BuildContext context);

  void _setUpPasteboardStreamListener() {
    if (kIsWeb) clipboardSubscription = pasteboard.pasteBoardListener(onPaste);
  }

  @override
  void close() {
    focusNode.dispose();
    inputStateController.close();
    voiceControllers.close();
    clipboardSubscription?.cancel();
    VRoomTracker.instance.closeOpenedRoom(roomId);
    closeStreamMix();
    super.close();
  }

  void _removeAllNotifications() async {
    await VChatController.I.vChatConfig.cleanNotifications();
  }

  void onOpenSearch() {
    inputStateController.hide();
  }

  void onCloseSearch() {
    inputStateController.unHide();
    resetMessages();
  }

  void onSearch(String value) async {
    messageSearch(value);
  }

  void onMessageLongTap(BuildContext context, VBaseMessage message) {
    return itemController.onMessageItemLongPress(
      message,
      vRoom,
      setReply,
    );
  }

  void onMessageTap(VBaseMessage message) async {
    return itemController.onMessageItemPress(
      message,
    );
  }

  void onSubmitMedia(
    BuildContext context,
    List<VPlatformFile> files,
  ) async {
    final fileRes = await context.toPage(VMediaEditorView(
      files: files,
      config: VMediaEditorConfig(
        imageQuality: vMessageConfig.compressImageQuality,
      ),
    )) as List<VBaseMediaRes>?;

    if (fileRes == null) return;

    for (var media in fileRes) {
      if (media is VMediaImageRes) {
        final localMsg = VImageMessage.buildMessage(
          roomId: vRoom.id,
          data: VMessageImageData.fromMap(media.data.toMap()),
        );
        _onSubmitSendMessage(localMsg);
      } else if (media is VMediaVideoRes) {
        final localMsg = VVideoMessage.buildMessage(
          data: VMessageVideoData.fromMap(media.data.toMap()),
          roomId: vRoom.id,
        );
        _onSubmitSendMessage(localMsg);
      }
    }
    scrollDown();
  }

  Future<void> onPaste(List<VPlatformFile> files) async {
    final fileRes = await context.toPage(VMediaEditorView(
      files: files,
      config: VMediaEditorConfig(
        imageQuality: vMessageConfig.compressImageQuality,
      ),
    )) as List<VBaseMediaRes>?;

    if (fileRes == null || fileRes.isEmpty) return;
    for (final file in fileRes) {
      if (file is VMediaImageRes) {
        _onSubmitSendMessage(
          VImageMessage.buildMessage(
            roomId: roomId,
            data: VMessageImageData.fromMap(
              file.data.toMap(),
            ),
          ),
        );
      }
      if (file is VMediaFileRes) {
        _onSubmitSendMessage(
          VFileMessage.buildMessage(
            roomId: roomId,
            data: VMessageFileData.fromMap(file.data.toMap()),
          ),
        );
      }
    }
  }

  void onSubmitVoice(VMessageVoiceData data) {
    final localMsg = VVoiceMessage.buildMessage(
      data: data,
      roomId: vRoom.id,
      content: VStringUtils.printDuration(data.durationObj),
    );
    _onSubmitSendMessage(localMsg);
    scrollDown();
  }

  void onSubmitFiles(List<VPlatformFile> files) {
    for (var file in files) {
      final localMsg = VFileMessage.buildMessage(
        data: VMessageFileData(fileSource: file),
        roomId: vRoom.id,
      );
      _onSubmitSendMessage(localMsg);
      scrollDown();
    }
  }

  void onSubmitLocation(VLocationMessageData data) {
    final localMsg = VLocationMessage.buildMessage(
      data: data,
      roomId: vRoom.id,
    );
    _onSubmitSendMessage(localMsg);
    scrollDown();
  }

  void onTypingChange(VRoomTypingEnum typing) {
    if (typing == VRoomTypingEnum.recording) {
      _stopVoicePlayer();
    }
    final model = VSocketRoomTypingModel(
      status: typing,
      roomId: vRoom.id,
    );
    messageProvider.emitTypingChanged(model);
  }

  Future<void> _onSubmitSendMessage(VBaseMessage localMsg) async {
    localMsg.replyTo = inputStateController.value.replyMsg;
    await VChatController.I.nativeApi.local.message.insertMessage(localMsg);
    MessageUploaderQueue.instance.addToQueue(
      await MessageFactory.createUploadMessage(localMsg),
    );
    inputStateController.dismissReply();
  }

  void onSubmitText(String message) {
    final isEnable = vConfig.enableEndToEndMessageEncryption;
    final localMsg = VTextMessage.buildMessage(
      content: isEnable ? VMessageEncryption.encryptMessage(message) : message,
      isEncrypted: isEnable,
      roomId: vRoom.id,
    );
    scrollDown();
    _onSubmitSendMessage(localMsg);
  }

  void scrollDown() {
    scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  Future<void> onHighlightMessage(VBaseMessage message) async {
    final i = value.indexOf(message);
    if (i == -1) {
      final x = await loadMoreMessages();
      if (x == null || x.isEmpty) {
        return;
      }
      onHighlightMessage(message);
    } else {
      _highlightTo(i);
    }
  }

  void _highlightTo(int index) {
    scrollController.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.end,
      duration: const Duration(milliseconds: 500),
    );
    scrollController.highlight(index);
  }

  void setReply(VBaseMessage p1) {
    focusNode.requestFocus();
    if (p1.emitStatus.isServerConfirm) {
      inputStateController.setReply(p1);
    }
  }

  void dismissReply() {
    inputStateController.dismissReply();
  }

  void onReSend(VBaseMessage message) async {
    MessageUploaderQueue.instance.addToQueue(
      await MessageFactory.createUploadMessage(message),
    );
  }

  ///set to each controller
  Future<List<MentionModel>> onMentionRequireSearch(
    BuildContext context,
    String query,
  );

  void _setUpVoiceController() {
    voiceControllers = VVoicePlayerController(
      (localId) {
        final index = value.indexWhere((e) => e.localId == localId);
        if (index == -1 || index == 0) {
          return null;
        }
        if (!value[index - 1].messageType.isVoice) {
          return null;
        }
        return value[index - 1].localId;
      },
    );
  }

  ///----------------------------- Messages streams -----------------------------------------------------
  void _initMessagesStreams() {
    ///messages events
    streamsMix.addAll([
      events
          .on<VInsertMessageEvent>()
          .where((event) => event.roomId == vRoom.id)
          .listen(_handleOnNewMessage),
      events
          .on<VUpdateMessageEvent>()
          .where((event) => event.roomId == vRoom.id)
          .listen(_handleOnUpdateMessage),
      events
          .on<VDeleteMessageEvent>()
          .where((event) => event.roomId == vRoom.id)
          .listen(_handleOnDeleteMessage),
      events
          .on<VUpdateMessageDeliverEvent>()
          .where((event) => event.roomId == vRoom.id)
          .listen(_handleOnDeliverMessage),
      events
          .on<VUpdateMessageSeenEvent>()
          .where((event) => event.roomId == vRoom.id)
          .listen(_handleOnSeenMessage),
      events
          .on<VUpdateMessageStatusEvent>()
          .where((event) => event.roomId == vRoom.id)
          .listen(_handleOnUpdateMessageStatus),
      events
          .on<VUpdateMessageAllDeletedEvent>()
          .where((event) => event.roomId == vRoom.id)
          .listen(_handleOnAllDeleted),
    ]);
  }

  void _handleOnNewMessage(VInsertMessageEvent event) async {
    emitSeenFor(event.roomId);
    insertMessage(event.messageModel);
  }

  void _handleOnUpdateMessage(VUpdateMessageEvent event) async {
    updateMessage(event.messageModel);
  }

  void _handleOnDeleteMessage(VDeleteMessageEvent event) async {
    deleteMessage(event.localId);
  }

  void _handleOnDeliverMessage(VUpdateMessageDeliverEvent event) async {
    deliverAll(event.model);
  }

  void _handleOnSeenMessage(VUpdateMessageSeenEvent event) async {
    seenAll(event.model);
  }

  void _handleOnUpdateMessageStatus(VUpdateMessageStatusEvent event) async {
    updateMessageStatus(event.localId, event.emitState);
  }

  void _handleOnAllDeleted(VUpdateMessageAllDeletedEvent event) {
    updateMessageAllDeletedAt(event.localId, event.message.allDeletedAt);
  }

  void onGetClipboardImageBytes(Uint8List imageBytes) async {
    final fileRes = await context.toPage(VMediaEditorView(
      files: [
        VPlatformFile.fromBytes(
            bytes: imageBytes.toList(), name: "${uuid.v4()}.png")
      ],
      config: VMediaEditorConfig(
        imageQuality: vMessageConfig.compressImageQuality,
      ),
    )) as List<VBaseMediaRes>?;

    if (fileRes == null || fileRes.isEmpty) return;
    for (final e in fileRes) {
      if (e is VMediaImageRes) {
        _onSubmitSendMessage(
          VImageMessage.buildMessage(
            roomId: roomId,
            data: VMessageImageData.fromMap(e.data.toMap()),
          ),
        );
      }
    }
  }
  void _stopVoicePlayer() {
    voiceControllers.pauseAll();
  }
}
