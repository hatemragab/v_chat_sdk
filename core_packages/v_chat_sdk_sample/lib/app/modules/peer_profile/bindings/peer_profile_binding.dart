import 'package:get/get.dart';

import '../controllers/peer_profile_controller.dart';

class PeerProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<PeerProfileController>(
      PeerProfileController(Get.arguments as String, ),
    );
  }
}
