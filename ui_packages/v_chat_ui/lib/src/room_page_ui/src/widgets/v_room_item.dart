import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class VRoomItem extends StatelessWidget {
  final VRoom vBaseRoom;
  final Function(VRoom room) onRoomItemPress;
  const VRoomItem(
      {Key? key, required this.vBaseRoom, required this.onRoomItemPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onRoomItemPress(vBaseRoom),
      title: Text(vBaseRoom.title),
      subtitle: Text(vBaseRoom.createdAt.toString()),
    );
  }
}
