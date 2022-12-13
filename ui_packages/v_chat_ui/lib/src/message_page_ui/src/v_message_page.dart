import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_ui/src/message_page_ui/src/v_message_controller.dart';
import 'package:v_chat_ui/src/message_page_ui/src/widgets/v_message_app_bare.dart';
import 'package:v_chat_ui/src/message_page_ui/src/widgets/v_message_item.dart';

class VMessagePage extends StatefulWidget {
  const VMessagePage({
    Key? key,
    required this.vRoom,
    this.onMessageItemPress,
  }) : super(key: key);

  final Function(VBaseMessage message)? onMessageItemPress;
  final VRoom vRoom;

  @override
  State<VMessagePage> createState() => _VMessagePageState();
}

class _VMessagePageState extends State<VMessagePage> {
  late final VMessageController controller;

  @override
  void initState() {
    super.initState();
    controller = VMessageController(widget.vRoom);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: VMessageAppBare(
          title: 'V chat appbar',
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ChangeNotifierProvider<VMessageController>.value(
              value: controller,
              builder: (context, child) {
                final controller = context.watch<VMessageController>();
                return VAsyncWidgetsBuilder(
                  loadingState: controller.roomPageState,
                  onRefresh: controller.initMessages,
                  successWidget: () {
                    return ListView.builder(
                      key: UniqueKey(),
                      cacheExtent: 300,
                      itemBuilder: (context, index) {
                        final message = controller.messages[index];
                        return StreamBuilder<VBaseMessage>(
                          stream: controller.messageStateStream.stream.where(
                            (e) => e.id == message.id,
                          ),
                          initialData: message,
                          builder: (context, snapshot) {
                            return VMessageItem(
                              message: snapshot.data!,
                              onMessageItemPress: widget.onMessageItemPress ??
                                  controller.onMessageItemPress,
                            );
                          },
                        );
                      },
                      itemCount: controller.messages.length,
                      reverse: true,
                    );
                  },
                );
              },
            ),
          ),
          // const VMessageInput()
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
