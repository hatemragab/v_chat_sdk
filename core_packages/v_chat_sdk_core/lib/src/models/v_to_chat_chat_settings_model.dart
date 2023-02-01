import 'package:v_chat_sdk_core/src/models/models.dart';

class VToChatSettingsModel {
  final String title;
  final String image;
  final String roomId;
  final VRoom room;

  const VToChatSettingsModel({
    required this.title,
    required this.image,
    required this.roomId,
    required this.room,
  });

  @override
  String toString() {
    return 'VToChatSettingsModel{title: $title, image: $image, roomId: $roomId room $room}';
  }

  VToChatSettingsModel copyWith({
    String? title,
    String? image,
    String? roomId,
    VRoom? room,
  }) {
    return VToChatSettingsModel(
      title: title ?? this.title,
      image: image ?? this.image,
      roomId: roomId ?? this.roomId,
      room: room ?? this.room,
    );
  }
}
