import 'package:get/get.dart';
import 'package:v_chat_room_page/v_chat_room_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class HomeController extends GetxController {
  final roomController = VRoomController(isTesting: true);
  void onRoomLongTap(VRoom room) {}

  void onRoomTap(VRoom room) {}
}
