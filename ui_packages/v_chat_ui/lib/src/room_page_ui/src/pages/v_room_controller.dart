import 'dart:async';

import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../message_page_ui/src/v_message_page.dart';

class VRoomController extends ChangeNotifier {
  final roomStateStream = StreamController<VRoom>.broadcast();
  var roomPageState = VChatLoadingState.ideal;
  final _roomPaginationModel = VPaginationModel<VRoom>(
    values: <VRoom>[],
    limit: 20,
    page: 1,
    nextPage: null,
  );

  List<VRoom> get rooms => List.unmodifiable(_roomPaginationModel.values);

  VRoomController() {
    initRooms();
  }

  Future<void> initRooms() async {
    await vSafeApiCall<List<VRoom>>(
      onLoading: () {
        roomPageState = VChatLoadingState.loading;
        notifyListeners();
      },
      request: () async {
        await Future.delayed(const Duration(milliseconds: 1200));
        return List.generate(
          2,
          (index) => VRoom.fakeRoom(
            index,
          ),
        );
      },
      onSuccess: (response) {
        _roomPaginationModel.values.addAll(response);
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
    roomStateStream.close();
  }

  void onRoomItemPress(VRoom room, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => VMessagePage(
        vRoom: room,
      ),
    ));
  }
}
