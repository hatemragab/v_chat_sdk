import 'package:get/get.dart';

class MessageInputController extends GetxController {
  final logs = <InputLog>[].obs;
}

class InputLog {
  final String fName;
  final String data;

  InputLog(this.fName, this.data);
}
