import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_ui/src/room_page_ui/src/pages/v_room_controller.dart';
import 'package:v_chat_ui/src/room_page_ui/src/widgets/v_room_item.dart';

class VRoomBody extends StatelessWidget {
  const VRoomBody({
    Key? key,
    required this.controller,
    this.onRoomItemPress,
  }) : super(key: key);
  final VRoomController controller;
  final Function(VRoom room)? onRoomItemPress;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<VRoomController>.value(
      value: controller,
      builder: (context, child) {
        final controller = context.watch<VRoomController>();
        return VAsyncWidgetsBuilder(
          loadingState: controller.roomPageState,
          onRefresh: controller.initRooms,
          successWidget: () {
            return ListView.builder(
              key: UniqueKey(),
              cacheExtent: 300,
              itemBuilder: (context, index) {
                final room = controller.rooms[index];
                return StreamBuilder<VRoom>(
                  stream: controller.roomStateStream.stream.skipWhile(
                    (e) => e.id != room.id,
                  ),
                  initialData: room,
                  builder: (context, snapshot) {
                    return VRoomItem(
                      room: snapshot.data!,
                      onRoomItemPress: (room) {
                        if (onRoomItemPress != null) {
                          onRoomItemPress!(room);
                        }
                        controller.onRoomItemPress(room, context);
                      },
                    );
                  },
                );
              },
              itemCount: controller.rooms.length,
            );
          },
        );
      },
    );
  }
}
