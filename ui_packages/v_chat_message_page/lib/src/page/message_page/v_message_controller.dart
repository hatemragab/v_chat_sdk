import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:v_chat_message_page/src/page/message_page/message_state.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../message_uploader/message_queue.dart';
import '../../models/app_bare_state.dart';
import '../../models/input_state.dart';
import '../../widgets/message_items/v_message_item_controller.dart';
import 'message_provider.dart';

class VMessageController {
  final Function(String userId) onMentionPress;
  late final StreamSubscription _messagesStream;
  final VRoom vRoom;
  final _provider = MessageProvider();
  final messageState = MessageState();
  late final ValueNotifier<AppBareState> appBareState;
  final _inputState = ValueNotifier<InputState>(InputState());
  final _localStorage = VChatController.I.nativeApi.local;
  final _remoteStorage = VChatController.I.nativeApi.remote;

  ValueNotifier<InputState> get inputState => _inputState;

  final itemController = VMessageItemController();

  List<VBaseMessage> get messages => messageState.stateMessages;
  final bool isInTesting;

  VMessageController({
    required this.vRoom,
    required this.onMentionPress,
    this.isInTesting = false,
  }) {
    appBareState = ValueNotifier<AppBareState>(
      AppBareState(
        vRoom,
      ),
    );
    _initLocalMessages();
    _listenToMessageStream();
  }

  Future<void> _initLocalMessages() async {
    await vSafeApiCall<List<VBaseMessage>>(
      request: () async {
        if (isInTesting) {
          return await _provider.getFakeMessages();
        } else {
          return await VChatController.I.nativeApi.local.message
              .getRoomMessages(vRoom.id);
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
          return VChatController.I.nativeApi.remote.remoteMessage.apiService
              .getRoomMessages(
            roomId: vRoom.id,
            dto: const VRoomMessagesDto(),
          );
        }
      },
      onSuccess: (response) {
        messageState.updateCacheState(response);
      },
    );
  }

  void onMessageItemPress(VBaseMessage message) {}

  void onTyping(VSocketRoomTypingModel p1) {
    if (appBareState.value.typingModel.isTyping) {
      vRoom.typingStatus = VSocketRoomTypingModel.offline;
    } else {
      vRoom.typingStatus = p1;
    }
    appBareState.notifyListeners();
  }

  Future<void> _onSubmitSendMessage(VBaseMessage localMsg) async {
    localMsg.replyTo = _inputState.value.replyMsg;
    await _localStorage.message.insertMessage(localMsg);
    MessageUploaderQueue.instance.addToQueue(
      await MessageFactory.createUploadMessage(localMsg),
    );
    _inputState.value.replyMsg = null;
    _inputState.notifyListeners();
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

  void onTypingChange(VRoomTypingEnum typing) {}

  void dispose() {
    messageState.close();
    _messagesStream.cancel();
  }

  void _listenToMessageStream() {
    _messagesStream = _localStorage.message.messageStream
        .takeWhile((e) => e.roomId == vRoom.id)
        .listen((event) {
      if (event is VInsertMessageEvent) {
        //insert the message
        return messageState.insertMessage(event.messageModel);
      }
      if (event is VUpdateMessageEvent) {
        return messageState.updateMessage(event.messageModel);
      }
      if (event is VDeleteMessageEvent) {
        return messageState.deleteMessage(event.localId);
      }
      if (event is VUpdateMessageTypeEvent) {
        return messageState.updateMessageType(event.localId, event.messageType);
      }
      if (event is VUpdateMessageStatusEvent) {
        return messageState.updateMessageStatus(event.localId, event.emitState);
      }
      if (event is VUpdateMessageSeenEvent) {
        return messageState.seenAll(event.model);
      }
      if (event is VUpdateMessageDeliverEvent) {
        return messageState.deliverAll(event.model);
      }
    });
  }
}
