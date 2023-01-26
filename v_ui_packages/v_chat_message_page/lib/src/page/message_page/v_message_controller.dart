import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:v_chat_input_ui/v_chat_input_ui.dart';
import 'package:v_chat_media_editor/v_chat_media_editor.dart';
import 'package:v_chat_message_page/src/page/message_page/states/app_bar_state_controller.dart';
import 'package:v_chat_message_page/src/page/message_page/states/input_state_controller.dart';
import 'package:v_chat_message_page/src/page/message_page/states/message_state_controller.dart';
import 'package:v_chat_message_page/src/page/message_page/v_voice_controller.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../models/app_bare_state_model.dart';
import '../../models/input_state_model.dart';
import '../chat_media/chat_media_page.dart';
import 'message_provider.dart';
import 'states/message_stream_state.dart';
import 'v_message_item_controller.dart';

class VMessageController {
  final bool isInTesting;
  final VRoom vRoom;
  final _messageProvider = MessageProvider();
  late final MessageStateController messageState;

  late final AppBarStateController appBarStateController;
  late final InputStateController inputStateController;

  final _localStorage = VChatController.I.nativeApi.local;

  // final _remoteStorage = VChatController.I.nativeApi.remote;
  final autoScrollTagController = AutoScrollController(
    axis: Axis.vertical,
    suggestedRowHeight: 200,
  );
  final _vConfig = VChatController.I.vChatConfig;
  late final VMessageItemController _itemController;
  final focusNode = FocusNode();
  late final MessageStreamState _localStreamChanges;
  final _currentUser = VAppConstants.myProfile;

  final voiceControllers = VVoicePlayerController((localId) => null);

  ///Getters
  List<VBaseMessage> get messages => messageState.stateMessages;

  MessageInputModel get inputState => inputStateController.value;

  MessageAppBarStateModel get appBareState => appBarStateController.value;

  String get roomId => vRoom.id;

  VMessageController({
    required this.vRoom,
    this.isInTesting = false,
    required BuildContext context,
  }) {
    messageState = MessageStateController(
      vRoom,
      _messageProvider,
      isInTesting,
      context,
      autoScrollTagController,
    );
    appBarStateController = AppBarStateController(vRoom, _messageProvider);
    inputStateController = InputStateController(vRoom, _messageProvider);
    _localStreamChanges = MessageStreamState(
      nativeApi: VChatController.I.nativeApi,
      messageState: messageState,
      appBarStateController: appBarStateController,
      inputStateController: inputStateController,
      currentRoom: vRoom,
    );
    _itemController = VMessageItemController(_messageProvider, context);
    _messageProvider.setSeen(roomId);
    VRoomTracker.instance.addToOpenRoom(roomId: roomId);
    _removeAllNotifications();
  }

  Future<void> _onSubmitSendMessage(VBaseMessage localMsg) async {
    localMsg.replyTo = inputState.replyMsg;
    await _localStorage.message.insertMessage(localMsg);
    MessageUploaderQueue.instance.addToQueue(
      await MessageFactory.createUploadMessage(localMsg),
    );
    inputStateController.dismissReply();
  }

  void onSubmitText(String message) {
    final isEnable = _vConfig.enableMessageEncryption;
    final localMsg = VTextMessage.buildMessage(
      content: isEnable ? VMessageEncryption.encryptMessage(message) : message,
      isEncrypted: isEnable,
      roomId: vRoom.id,
    );
    scrollDown();
    _onSubmitSendMessage(localMsg);
  }

  Future<List<VMentionModel>> onMentionRequireSearch(
    BuildContext context,
    String query,
  ) async {
    return VChatController.I.vMessagePageConfig.onMentionRequireSearch(
      context,
      vRoom.roomType,
      query,
    );
  }

  void onSubmitMedia(
    BuildContext context,
    List<VBaseMediaRes> files,
  ) async {
    final fileRes = await context.toPage(VMediaEditorView(
      files: files.map((e) {
        return e.getVPlatformFile();
      }).toList(),
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
    );
    _onSubmitSendMessage(localMsg);
    scrollDown();
  }

  void onSubmitFiles(List<VPlatformFileSource> files) {
    for (var file in files) {
      final localMsg = VFileMessage.buildMessage(
        data: VMessageFileData(fileSource: file),
        roomId: vRoom.id,
        isEncrypted: false,
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
    _messageProvider.emitTypingChanged(model);
  }

  bool get isSocketConnected =>
      VChatController.I.nativeApi.remote.socketIo.isConnected;

  void dispose() {
    _localStreamChanges.close();
    messageState.close();
    appBarStateController.close();
    inputStateController.close();
    voiceControllers.close();
    focusNode.dispose();
    autoScrollTagController.dispose();
    VRoomTracker.instance.closeOpenedRoom(roomId);
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

  void scrollDown() {
    autoScrollTagController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  Future<void> onHighlightMessage(VBaseMessage message) async {
    final i = messages.indexOf(message);
    if (i == -1) {
      final x = await messageState.loadMoreMessages();
      if (x == null || x.isEmpty) {
        return;
      }
      onHighlightMessage(message);
    } else {
      _highlightTo(i);
    }
  }

  void _highlightTo(int index) {
    autoScrollTagController.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.end,
      duration: const Duration(milliseconds: 500),
    );
    autoScrollTagController.highlight(index);
  }

  void onReSend(VBaseMessage message) async {
    MessageUploaderQueue.instance.addToQueue(
      await MessageFactory.createUploadMessage(message),
    );
  }

  void onOpenSearch() {
    inputStateController.hide();
    appBarStateController.onOpenSearch();
  }

  void onCloseSearch() {
    inputStateController.unHide();
    appBarStateController.onCloseSearch();
    messageState.onCloseSearch();
  }

  void onSearch(String value) async {
    messageState.onSearch(value);
  }

  void onViewMedia(BuildContext context, String roomId) {
    context.toPage(
      ChatMediaPage(
        roomId: roomId,
      ),
    );
  }

  void onMessageLongTap(VBaseMessage message) {
    return _itemController.onMessageItemLongPress(
      message,
      vRoom,
      setReply,
    );
  }

  void onMessageTap(VBaseMessage message) async {
    return _itemController.onMessageItemPress(
      message,
    );
  }

  void _removeAllNotifications() async {
    await VChatController.I.vChatConfig.cleanNotifications();
  }
}
