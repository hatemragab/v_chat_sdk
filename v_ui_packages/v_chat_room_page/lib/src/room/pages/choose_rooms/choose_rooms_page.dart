// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../../v_chat_room_page.dart';
import 'choose_room_controller.dart';

/// A stateful widget that displays a list of available rooms and allows the user to select one. /// /// The [currentRoomId] parameter is used to highlight the
class VChooseRoomsPage extends StatefulWidget {
  final String? currentRoomId;

  const VChooseRoomsPage({
    super.key,
    required this.currentRoomId,
  });

  @override
  State<VChooseRoomsPage> createState() => _VChooseRoomsPageState();
}

class _VChooseRoomsPageState extends State<VChooseRoomsPage> {
  late final ChooseRoomsController controller;

  @override
  void initState() {
    super.initState();
    controller = ChooseRoomsController(widget.currentRoomId);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<VRoom>>(
        valueListenable: controller,
        builder: (_, value, __) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("choose Rooms"),
            ),
            floatingActionButton: controller.isThereSelection
                ? null
                : FloatingActionButton(
                    child: const Icon(Icons.send),
                    onPressed: () => controller.onDone(context),
                  ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                cacheExtent: 300,
                itemBuilder: (context, index) {
                  return VRoomItem(
                    language: VRoomLanguage.fromEnglish(),
                    room: value[index],
                    isIconOnly: false,
                    onRoomItemLongPress: (room) =>
                        controller.onRoomItemPress(room, context),
                    onRoomItemPress: (room) =>
                        controller.onRoomItemPress(room, context),
                  );
                },
                itemCount: value.length,
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    controller.close();
  }
}
