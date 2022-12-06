import 'package:get/get.dart';
import 'package:v_chat_sdk_sample/app/core/repository/user.repository.dart';

import 'clould/cloud_firestore_api.dart';

class LazyInjection extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserRepository>(
      () => UserRepository(
        apiClient: CloudFireStoreApi(collection: "users"),
      ),
      fenix: true,
    );
  }
}
