import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_sdk/src/services/v_chat_app_service.dart';
import '../../../utils/custom_widgets/connection_checker.dart';
import '../controllers/rooms_controller.dart';
import 'widgets/room_item.dart';

/// use this widget any where you want to show user chats
/// if you want to navigate to it then add this [VChatRoomsView] in the body of [Scaffold]
/// ```dart
///    Navigator.of(context).push(
///      MaterialPageRoute(
///        builder: (context) => Scaffold(
///           body: VChatRoomsView(),
///        ),
///      ),
///    );
/// ```
class VChatRoomsView extends GetView<RoomController> {
  const VChatRoomsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).brightness == Brightness.dark
          ? VChatAppService.to.dark!
          : VChatAppService.to.light!,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Builder(builder: (context) {
          return Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ConnectionChecker(),
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
                  child: Obx(() {
                    final rooms = controller.rooms;
                    final isLoading = controller.isLoading.value;
                    if (isLoading) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                    // _log.info(controller.rooms.toString());
                    return ListView.separated(
                      padding: const EdgeInsets.all(8.0),
                      controller: controller.scrollController,
                      physics: const BouncingScrollPhysics(),
                      key: const PageStorageKey<String>('RoomsTabView'),
                      itemBuilder: (context, index) {
                        return SizedBox(
                          height: 70,
                          child: RoomItem(rooms[index]),
                        );
                      },
                      itemCount: rooms.length,
                      separatorBuilder: (context, index) => const Divider(),
                    );
                  }),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
