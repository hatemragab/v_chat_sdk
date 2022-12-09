import 'package:get/get.dart';

import '../../../core/enums.dart';
import '../../../core/models/user.model.dart';
import '../../../core/repository/user.repository.dart';
import '../../../core/utils/async_ui_notifier.dart';

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
    await safeApiCall<UserModel>(
      apiState: apiCallStatus,
      request: () {
        return repository.getId(uuId);
      },
      onSuccess: (response) {
        peerData = response;
      },
    );
  }

  void onStartChat() {}
}
