import 'dart:async';

import 'package:v_chat_message_page/src/models/app_bare_state_model.dart';
import 'package:v_chat_message_page/src/models/input_state_model.dart';
import 'package:v_chat_message_page/src/page/message_page/states/app_bar_state_controller.dart';
import 'package:v_chat_message_page/src/page/message_page/states/input_state_controller.dart';
import 'package:v_chat_message_page/src/page/message_page/states/message_state.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../widgets/message_items/v_message_item_controller.dart';
import '../message_stream_state.dart';
import 'message_provider.dart';

class VMessageController with VSocketStatusStream, VSocketIntervalStream {
  final bool isInTesting;
  final Function(String userId) onMentionPress;
  final VRoom vRoom;
  final _provider = MessageProvider();
  final messageState = MessageState();
  late final AppBarStateController appBarStateController;
  late final InputStateController inputStateController;

  final _localStorage = VChatController.I.nativeApi.local;
  final _remoteStorage = VChatController.I.nativeApi.remote;

  final itemController = VMessageItemController();
  late final MessageStreamState _localStreamChanges;
  final _currentUser = VAppConstants.myProfile;

  ///Getters
  List<VBaseMessage> get messages => messageState.stateMessages;

  MessageInputModel get inputState => inputStateController.inputState.value;

  MessageAppBarStateModel get appBareState =>
      appBarStateController.appBareState.value;

  String get roomId => vRoom.id;

  VMessageController({
    required this.vRoom,
    required this.onMentionPress,
    this.isInTesting = false,
  }) {
    _initLocalMessages();
    appBarStateController = AppBarStateController(vRoom);
    inputStateController = InputStateController(vRoom.blockerId != null);
    _localStreamChanges = MessageStreamState(
      nativeApi: VChatController.I.nativeApi,
      messageState: messageState,
      appBarStateController: appBarStateController,
      inputStateController: inputStateController,
      currentRoom: vRoom,
    );
    initSocketStatusStream(
      VChatController.I.nativeApi.remote.remoteSocketIo.socketStatusStream,
    );
    _provider.setSeen(roomId);
    initSocketIntervalStream(
      VChatController.I.nativeApi.remote.remoteSocketIo.socketIntervalStream,
    );
    _setAppBareState();
  }

  Future<void> _initLocalMessages() async {
    await vSafeApiCall<List<VBaseMessage>>(
      request: () async {
        if (isInTesting) {
          return await _provider.getFakeLocalMessages();
        } else {
          return _provider.getLocalMessages(roomId: vRoom.id);
        }
      },
      onSuccess: (response) {
        messageState.updateCacheState(response);
      },
    );
    await getApiMessages();
  }

  Future<void> getApiMessages() async {
    await vSafeApiCall<List<VBaseMessage>>(
      request: () async {
        if (isInTesting) {
          return await _provider.getFakeApiMessages();
        } else {
          return _provider.getApiMessages(
            roomId: vRoom.id,
            dto: const VRoomMessagesDto(
              limit: 20,
            ),
          );
        }
      },
      onSuccess: (response) {
        messageState.updateCacheState(response);
      },
    );
  }

  void onMessageItemPress(VBaseMessage message) {}

  Future<void> _onSubmitSendMessage(VBaseMessage localMsg) async {
    localMsg.replyTo = inputState.replyMsg;
    await _localStorage.message.insertMessage(localMsg);
    MessageUploaderQueue.instance.addToQueue(
      await MessageFactory.createUploadMessage(localMsg),
    );
    inputStateController.dismiseReply();
  }

  void onSubmitText(String message) {
    final localMsg = VTextMessage.buildMessage(
      content: message,
      roomId: vRoom.id,
    );
    _onSubmitSendMessage(localMsg);
  }

  void onMentionRequireSearch(String text) {}

  void onSubmitMedia(List<VBaseMediaRes> files) {}

  void onSubmitVoice(VMessageVoiceData data) {}

  void onSubmitFiles(List<VPlatformFileSource> files) {}

  void onSubmitLocation(VLocationMessageData data) {}

  void onTypingChange(VRoomTypingEnum typing) {
    final model = VSocketRoomTypingModel(
      status: typing,
      roomId: vRoom.id,
      name: _currentUser.baseUser.fullName,
      userId: _currentUser.baseUser.vChatId,
    );
    _remoteStorage.remoteSocketIo.emitUpdateRoomStatus(model);
  }

  void dispose() {
    _localStreamChanges.close();
    messageState.close();
    appBarStateController.close();
    inputStateController.close();
    closeSocketStatusStream();
    closeSocketIntervalStream();
  }

  @override
  void onSocketConnected() {
    //todo improve the call here
    getApiMessages();
    _provider.setSeen(roomId);
  }

  bool get isSocketConnected =>
      VChatController.I.nativeApi.remote.remoteSocketIo.isConnected;

  @override
  void onIntervalFire() async {
    if (vRoom.roomType.isSingleOrOrder) {
      if (!vRoom.isOnline && appBareState.lastSeenAt == null) {
        final date = await _provider.getLastSeenAt(vRoom.peerId!);
        appBarStateController.updateLastSeen(date);
      }
    }
  }

  void _setAppBareState() async {
    if (!vRoom.isOnline) {
      final date = await _provider.getLastSeenAt(vRoom.peerId!);
      appBarStateController.updateLastSeen(date);
    }
  }
}
