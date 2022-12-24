import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../models/app_bare_state.dart';
import '../../models/input_state.dart';
import '../../widgets/message_items/v_message_item_controller.dart';

class VMessageController extends ChangeNotifier {
  final Function(String userId) onMentionPress;

  final VRoom vRoom;
  late final ValueNotifier<AppBareState> appBareState;
  final inputState = ValueNotifier<InputState>(InputState());
  final messageStateStream = StreamController<VBaseMessage>.broadcast();
  var roomPageState = VChatLoadingState.ideal;
  final _messagePaginationModel = VPaginationModel<VBaseMessage>(
    values: <VBaseMessage>[],
    limit: 20,
    page: 1,
    nextPage: null,
  );
  final itemController = VMessageItemController();

  List<VBaseMessage> get messages =>
      List.unmodifiable(_messagePaginationModel.values);
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
    initMessages();
  }

  Future<void> initMessages() async {
    await vSafeApiCall<List<VBaseMessage>>(
      onLoading: () {
        roomPageState = VChatLoadingState.loading;
        notifyListeners();
      },
      request: () async {
        await Future.delayed(const Duration(milliseconds: 1200));
        return List.generate(
          20,
          (index) => index == 2
              ? VImageMessage.buildFakeMessage(width: 1024, high: 1024)
              : VTextMessage.buildFakeMessage(
                  index,
                ),
        );
      },
      onSuccess: (response) {
        _messagePaginationModel.values.addAll(response);
        roomPageState = VChatLoadingState.success;
        notifyListeners();
      },
      onError: (exception) {
        roomPageState = VChatLoadingState.error;
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    messageStateStream.close();
    super.dispose();
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

  onSubmitText(String message) {}

  onMentionRequireSearch(String text) {}

  onSubmitMedia(List<VBaseMediaRes> files) {}

  onSubmitVoice(VMessageVoiceData data) {}

  onSubmitFiles(List<VPlatformFileSource> files) {}

  onSubmitLocation(VLocationMessageData data) {}

  onTypingChange(VRoomTypingEnum typing) {}
}
