import 'package:get/get.dart';

import '../../chats_tab/controllers/chats_tab_controller.dart';
import '../../explore_tab/controllers/explore_tab_controller.dart';
import '../../settings_tab/controllers/settings_tab_controller.dart';
import '../../users_tab/controllers/users_tab_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<UsersTabController>(
      UsersTabController(),
    );
    Get.put<ChatsTabController>(
      ChatsTabController(),
    );
    Get.put<ExploreTabController>(
      ExploreTabController(),
    );
    Get.put<SettingsTabController>(
      SettingsTabController(Get.find()),
    );
    Get.put<HomeController>(
      HomeController(),
    );
  }
}
