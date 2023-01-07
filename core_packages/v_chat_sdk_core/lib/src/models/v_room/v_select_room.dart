import 'package:v_chat_sdk_core/src/models/models.dart';

class VSelectRoom {
  bool isSelected;
  final VRoom vRoom;

  VSelectRoom({
    this.isSelected = false,
    required this.vRoom,
  });

  void toggle() {
    isSelected = !isSelected;
  }
}
