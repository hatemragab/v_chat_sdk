import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../models/app_bare_state.dart';
import '../../v_message.dart';
import '../../widgets/app_bare/v_message_app_bare.dart';
import '../../widgets/app_bare/v_testing_message_app_bare.dart';
import '../../widgets/v_message_item.dart';

class VMessagePage extends StatefulWidget {
  const VMessagePage({
    Key? key,
    required this.vRoom,
    this.onMessageItemPress,
    this.appBare,
  }) : super(key: key);

  final Function(VBaseMessage message)? onMessageItemPress;
  final Widget Function(AppBareState state)? appBare;
  final VRoom vRoom;

  @override
  State<VMessagePage> createState() => _VMessagePageState();
}

class _VMessagePageState extends State<VMessagePage> {
  late final VMessageController controller;

  @override
  void initState() {
    super.initState();
    controller = VMessageController(widget.vRoom, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ValueListenableBuilder<AppBareState>(
          valueListenable: controller.appBareState,
          builder: (context, value, child) {
            if (controller.isInTesting) {
              return VTestingMessageAppBare(
                state: value,
                onTyping: controller.onTyping,
              );
            }
            return widget.appBare == null
                ? VMessageAppBare(
                    state: value,
                  )
                : widget.appBare!(value);
          },
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
                          stream:
                              controller.messageStateStream.stream.takeWhile(
                            (e) => e.localId == message.localId,
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
          // ValueListenableBuilder<InputState>(
          //   valueListenable: controller.inputState,
          //   builder: (_, value, __) {
          //     return VMessageInputWidget(
          //       onSubmitText: controller.onSubmitText,
          //       onSubmitMedia: controller.onSubmitMedia,
          //       onSubmitVoice: controller.onSubmitVoice,
          //       onSubmitFiles: controller.onSubmitFiles,
          //       onSubmitLocation: controller.onSubmitLocation,
          //       onTypingChange: controller.onTypingChange,
          //       googleMapsApiKey: "test",
          //       replyWidget: value.replyMsg == null
          //           ? null
          //           : ReplyMsgWidget(vBaseMessage: value.replyMsg!),
          //       stopChatWidget:
          //           value.isCloseInput ? const StopTypingWidget() : null,
          //     );
          //   },
          // )
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
