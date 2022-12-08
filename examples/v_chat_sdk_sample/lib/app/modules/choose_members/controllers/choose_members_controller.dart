import 'package:get/get.dart';
import 'package:v_chat_sdk_sample/app/core/models/user.model.dart';
import 'package:v_chat_sdk_sample/app/core/utils/app_alert.dart';

class ChooseMembersController extends GetxController {
  final selected = <UserModel>[].obs;

  void add(UserModel userModel) {
    if (selected.contains(userModel)) {
      selected.remove(userModel);
    } else {
      selected.add(userModel);
    }
  }

  void onDone() {
    if (selected.isNotEmpty) {
      Get.back(result: selected.value);
    } else {
      AppAlert.showErrorSnackBar(msg: "choose member");
    }
  }
}
