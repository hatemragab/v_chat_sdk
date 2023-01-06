import 'package:get/get.dart';
import 'package:v_chat_room_page/v_chat_room_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../core/enums.dart';
import '../../../core/models/user.model.dart';
import '../../../core/repository/user.repository.dart';

class PeerProfileController extends GetxController {
  final String uuId;
  final UserRepository repository;
  late UserModel peerData;

  PeerProfileController(this.uuId, this.repository);

  final apiCallStatus = ApiCallStatus.holding.obs;

  @override
  void onInit() {
    getUser();
    super.onInit();
  }

  Future getUser() async {
    await vSafeApiCall<UserModel>(
      onLoading: () {
        apiCallStatus.value = ApiCallStatus.loading;
      },
      request: () {
        return repository.getId(uuId);
      },
      onSuccess: (response) {
        apiCallStatus.value = ApiCallStatus.success;
        peerData = response;
      },
      onError: (exception, trace) {
        apiCallStatus.value = ApiCallStatus.error;
        print(exception);
      },
    );
  }

  void onStartChat() async {
    await vSafeApiCall<VRoom>(
      request: () {
        return VChatController.I.roomApi.getPeerRoom(peerIdentifier: uuId);
      },
      onSuccess: (response) {
        Get.to(
          () => VMessagePage(
            vRoom: response,
            isInTesting: false,
          ),
        );
      },
    );
  }
}
