import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../../v_chat_room_page.dart';
import 'choose_room_controller.dart';

class ChooseRoomsPage extends StatefulWidget {
  final String currentRoomId;

  const ChooseRoomsPage({
    Key? key,
    required this.currentRoomId,
  }) : super(key: key);

  @override
  State<ChooseRoomsPage> createState() => _ChooseRoomsPageState();
}

class _ChooseRoomsPageState extends State<ChooseRoomsPage> {
  late final ChooseRoomsController controller;

  @override
  void initState() {
    super.initState();
    controller = ChooseRoomsController(widget.currentRoomId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //todo trans
        title: const Text("Choose Rooms"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.send),
        onPressed: () => controller.onDone(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ValueListenableBuilder<List<VRoom>>(
            valueListenable: controller,
            builder: (_, value, __) {
              return ListView.builder(
                cacheExtent: 300,
                itemBuilder: (context, index) {
                  return VRoomItem(
                    room: value[index],
                    onRoomItemLongPress: (room) =>
                        controller.onRoomItemPress(room, context),
                    onRoomItemPress: (room) =>
                        controller.onRoomItemPress(room, context),
                  );
                },
                itemCount: value.length,
              );
            }),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.close();
  }
}
