import 'package:get/get.dart';
import 'package:v_chat_room_page/v_chat_room_page.dart';
import 'package:v_chat_sdk_sample/app/core/models/user.model.dart';
import 'package:v_chat_sdk_sample/app/routes/app_pages.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class ChatsTabController extends GetxController {
  final vRoomController = VRoomController(isTesting: false);

  void onCreateGroupOrBroadcast() async {
    final l = ["Group", "Broadcast"];
    final res = await VAppAlert.showAskListDialog(
      context: Get.context!,
      title: "Create Group or Broadcast?",
      content: l,
    );
    if (res == l[0]) {
      final users =
          await Get.toNamed(Routes.CHOOSE_MEMBERS) as List<UserModel>?;
      if (users != null) {
        Get.toNamed(Routes.CREATE_GROUP, arguments: users);
      }
    } else if (res == l[1]) {
      final users =
          await Get.toNamed(Routes.CHOOSE_MEMBERS) as List<UserModel>?;
      if (users != null) {
        Get.toNamed(Routes.CREATE_BROADCAST, arguments: users);
      }
    }
  }
}
