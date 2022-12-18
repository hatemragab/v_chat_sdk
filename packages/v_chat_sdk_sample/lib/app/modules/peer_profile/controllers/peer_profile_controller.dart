import 'package:get/get.dart';
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
      onError: (exception) {
        apiCallStatus.value = ApiCallStatus.error;
        print(exception);
      },
    );
  }

  void onStartChat() {}
}
