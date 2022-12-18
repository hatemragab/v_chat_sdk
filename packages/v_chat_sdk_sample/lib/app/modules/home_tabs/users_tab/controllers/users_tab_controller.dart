import 'package:get/get.dart';
import 'package:v_chat_sdk_sample/app/core/repository/user.repository.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class UsersTabController extends GetxController {
  final UserRepository repository;

  UsersTabController(this.repository);

  void onCreateGroupOrBroadcast() async {
    final res = await VAppAlert.showAskListDialog(
      title: "Create Group or Broadcast?",
      context: Get.context!,
      content: ["Group", "Broadcast"],
    );
    print(res);
  }
}
