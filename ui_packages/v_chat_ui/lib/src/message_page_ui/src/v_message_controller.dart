import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class VMessageController extends ChangeNotifier {
  final VRoom vRoom;
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

  VMessageController(this.vRoom) {
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
          (index) => VTextMessage.getFakeMessage(
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
    super.dispose();
    messageStateStream.close();
  }

  void onMessageItemPress(VBaseMessage message) {}
}
