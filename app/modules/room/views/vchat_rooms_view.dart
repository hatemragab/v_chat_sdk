import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/custom_widgets/connection_checker.dart';
import '../controllers/rooms_controller.dart';
import 'widgets/room_item.dart';

class VChatRoomsView extends GetView<RoomController> {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ConnectionChecker(),
          const SizedBox(
            height: 2,
          ),
          const SizedBox(
            height: 5,
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: Scrollbar(
              child: Obx(() {
                final rooms = controller.rooms;
                final isLoading = controller.isLoading.value;
                if (isLoading) {
                  return Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                // _log.info(controller.rooms.toString());
                return ListView.separated(
                  controller: controller.scrollController,
                  physics: BouncingScrollPhysics(),
                  key: PageStorageKey<String>('RoomsTabView'),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: 70,
                      child: RoomItem(rooms[index]),
                    );
                  },
                  itemCount: rooms.length,
                  separatorBuilder: (context, index) => Divider(),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
