import 'package:get/get.dart';
import 'package:v_chat_sdk_sample/app/core/repository/user.repository.dart';
import 'package:v_chat_sdk_sample/app/core/utils/app_alert.dart';

class UsersTabController extends GetxController {
  final UserRepository repository;

  UsersTabController(this.repository);

  void onCreateGroupOrBroadcast() async {
    final res = await AppAlert.showAskListDialog(
        title: "Create Group or Broadcast?", content: ["Group", "Broadcast"]);
    print(res);
  }
}
