import 'package:get/get.dart';

import '../../../../core/utils/app_alert.dart';

class ChatsTabController extends GetxController {
  void onCreateGroupOrBroadcast() async {
    final res = await AppAlert.showAskListDialog(
        title: "Create Group or Broadcast?", content: ["Group", "Broadcast"]);
    print(res);
  }
}
