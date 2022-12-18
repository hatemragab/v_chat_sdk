import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../models/app_bare_state.dart';
import '../models/input_state.dart';

class VMessageController extends ChangeNotifier {
  final VRoom _vRoom;
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

  List<VBaseMessage> get messages =>
      List.unmodifiable(_messagePaginationModel.values);
  final bool isInTesting;

  VMessageController(this._vRoom, [this.isInTesting = false]) {
    appBareState = ValueNotifier<AppBareState>(
      AppBareState(
        _vRoom,
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
          (index) => VTextMessage.buildFakeMessage(
            index.toString(),
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

  void onTyping(RoomTypingModel p1) {
    if (appBareState.value.typingModel.isTyping) {
      _vRoom.typingStatus = RoomTypingModel.offline;
    } else {
      _vRoom.typingStatus = p1;
    }
    appBareState.notifyListeners();
  }

  onSubmitText(String message) {}

  onMentionRequireSearch(String text) {}

  onSubmitMedia(List<PlatformFileSource> files) {}

  onSubmitVoice(VMessageVoiceData data) {}

  onSubmitFiles(List<PlatformFileSource> files) {}

  onSubmitLocation(VLocationMessageData data) {}

  onTypingChange(RoomTypingEnum typing) {}
}
