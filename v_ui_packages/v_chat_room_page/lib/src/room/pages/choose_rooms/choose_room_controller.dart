import 'package:flutter/cupertino.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class ChooseRoomsController extends ValueNotifier<List<VRoom>> {
  final String currentId;

  ChooseRoomsController(this.currentId) : super([]) {
    _getRooms();
  }

  void close() {}

  void onDone(BuildContext context) {
    context.pop(value);
  }

  void _getRooms() async {
    value = await VChatController.I.nativeApi.local.room.getRooms(limit: 5);
  }

  onRoomItemPress(VRoom room, BuildContext context) {}
}
