import 'package:get/get.dart';
import '../controllers/rooms_controller.dart';
import '../providers/room_api_provider.dart';

class RoomBinding {
  static void bind() {
    Get.put<RoomsApiProvider>(RoomsApiProvider());
    Get.put<RoomController>(RoomController());
  }
}
