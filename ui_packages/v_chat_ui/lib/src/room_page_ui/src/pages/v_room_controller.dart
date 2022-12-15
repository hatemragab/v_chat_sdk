import 'dart:async';

import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../message_page_ui/src/page/v_message_page.dart';
import '../widgets/room_item/room_item_controller.dart';

class VRoomController extends ChangeNotifier {
  VRoomController() {
    initRooms();
    //VChatController.I.nativeApi.local.room.roomStream.listen((event) {});
  }

  final roomStateStream = StreamController<VRoom>.broadcast();
  final roomItemController = RoomItemController();
  var roomPageState = VChatLoadingState.ideal;
  final _roomPaginationModel = VPaginationModel<VRoom>(
    values: <VRoom>[],
    limit: 20,
    page: 1,
    nextPage: null,
  );

  List<VRoom> get rooms => List.unmodifiable(_roomPaginationModel.values);

  Future<void> initRooms() async {
    await vSafeApiCall<List<VRoom>>(
      onLoading: () {
        roomPageState = VChatLoadingState.loading;
        notifyListeners();
      },
      request: () async {
        await Future.delayed(const Duration(milliseconds: 1200));
        return List.generate(
          12,
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

  void onRoomItemLongPress(VRoom room, BuildContext context) async {
    switch (room.roomType) {
      case RoomType.s:
        await roomItemController.openForSingle(room, context);
        break;
      case RoomType.g:
        await roomItemController.openForGroup(room, context);
        break;
      case RoomType.b:
        await roomItemController.openForBroadcast(room, context);
        break;
    }
  }
}
