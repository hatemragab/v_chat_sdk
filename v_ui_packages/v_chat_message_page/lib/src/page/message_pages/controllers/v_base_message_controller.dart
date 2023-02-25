// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:v_chat_media_editor/v_chat_media_editor.dart';
import 'package:v_chat_message_page/src/page/message_pages/controllers/v_message_item_controller.dart';
import 'package:v_chat_message_page/src/page/message_pages/controllers/v_voice_controller.dart';

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../chat_media/chat_media_page.dart';
import '../states/app_bar_state_controller.dart';
import '../states/input_state_controller.dart';
import '../states/message_state/message_state_controller.dart';

abstract class VBaseMessageController extends MessageStateController {
  final focusNode = FocusNode();
  final vConfig = VChatController.I.vChatConfig;
  final AppBarStateController appBarStateController;
  final InputStateController inputStateController;
  final VMessageItemController itemController;

  VBaseMessageController({
    required super.vRoom,
    required super.messageProvider,
    required super.context,
    required super.scrollController,
    required this.appBarStateController,
    required this.inputStateController,
    required this.itemController,
  }) {
    messageProvider.setSeen(roomId);
    VRoomTracker.instance.addToOpenRoom(roomId: roomId);
    _removeAllNotifications();
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
  bool get isSocketConnected =>
      VChatController.I.nativeApi.remote.socketIo.isConnected;
  late final VVoicePlayerController voiceControllers;

  final _currentUser = VAppConstants.myProfile;

  String get roomId => vRoom.id;

  void onTitlePress(
    BuildContext context,
    String id,
    VRoomType roomType,
  );

  @override
  void close() {
    focusNode.dispose();
    inputStateController.close();
    appBarStateController.close();
    voiceControllers.close();
    VRoomTracker.instance.closeOpenedRoom(roomId);
    super.close();
  }

  void _removeAllNotifications() async {
    await VChatController.I.vChatConfig.cleanNotifications();
  }

  void onOpenSearch() {
    inputStateController.hide();
    appBarStateController.onOpenSearch();
  }

  void onCloseSearch() {
    inputStateController.unHide();
    appBarStateController.onCloseSearch();
    resetMessages();
  }

  void onSearch(String value) async {
    messageSearch(value);
  }

  void onViewMedia(BuildContext context, String roomId) {
    context.toPage(
      ChatMediaPage(
        roomId: roomId,
      ),
    );
  }

  void onMessageLongTap(VBaseMessage message) {
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
    List<VPlatformFileSource> files,
  ) async {
    final fileRes = await context.toPage(VMediaEditorView(
      files: files,
      config: VMediaEditorConfig(
        imageQuality: vConfig.compressImageQuality,
      ),
    )) as List<VBaseMediaRes>?;

    if (fileRes == null) return;

    for (var media in fileRes) {
      if (media is VMediaImageRes) {
        final localMsg = VImageMessage.buildMessage(
          roomId: vRoom.id,
          data: media.data,
        );
        _onSubmitSendMessage(localMsg);
      } else if (media is VMediaVideoRes) {
        final localMsg = VVideoMessage.buildMessage(
          data: media.data,
          roomId: vRoom.id,
        );
        _onSubmitSendMessage(localMsg);
      }
    }
    scrollDown();
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

  void onSubmitFiles(List<VPlatformFileSource> files) {
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
    final model = VSocketRoomTypingModel(
      status: typing,
      roomId: vRoom.id,
      name: _currentUser.baseUser.fullName,
      userId: _currentUser.baseUser.vChatId,
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
  Future<List<VMentionModel>> onMentionRequireSearch(
    BuildContext context,
    String query,
  );
}
