import 'package:get/get.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class ChooseMembersController extends GetxController {
  final selected = <VIdentifierUser>[].obs;
  final members = <VIdentifierUser>[];
  VChatLoadingState loadingState = VChatLoadingState.ideal;

  void add(VIdentifierUser userModel) {
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
      VAppAlert.showErrorSnackBar(msg: "choose member", context: Get.context!);
    }
  }

  @override
  void onInit() {
    super.onInit();
    _getUsers();
  }

  void _getUsers() async {
    await vSafeApiCall<List<VIdentifierUser>>(
      request: () async {
        loadingState = VChatLoadingState.loading;
        return VChatController.I.nativeApi.remote.profile.appUsers({});
      },
      onSuccess: (response) {
        loadingState = VChatLoadingState.success;
        members.addAll(response);
      },
    );
    update();
  }
}
