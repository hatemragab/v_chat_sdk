import 'package:get/get.dart';
import 'package:v_chat_sdk_sample/app/core/repository/user.repository.dart';

class UsersTabController extends GetxController {
  final UserRepository repository;

  UsersTabController(this.repository);
}
