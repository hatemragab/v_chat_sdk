import 'package:flutter/material.dart';
import 'package:v_chat_input_ui/v_chat_input_ui.dart';
import 'package:v_chat_message_page/src/models/app_bare_state_model.dart';
import 'package:v_chat_message_page/src/models/input_state_model.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../v_message.dart';
import '../../widgets/app_bare/v_message_app_bare.dart';
import '../../widgets/app_bare/v_testing_message_app_bare.dart';
import '../../widgets/input_widgets/reply_msg_widget.dart';
import '../../widgets/input_widgets/stop_typing_widget.dart';
import '../../widgets/message_items/v_message_item.dart';

class VMessagePage extends StatefulWidget {
  const VMessagePage({
    Key? key,
    required this.vRoom,
    required this.onMentionPress,
    this.onMessageItemPress,
    this.appBare,
    this.googleMapsApiKey,
    this.onAppBarTitlePress,
  }) : super(key: key);
  final Function(String identifier) onMentionPress;

  final Function(VBaseMessage message)? onMessageItemPress;
  final Function(String id, VRoomType roomType)? onAppBarTitlePress;
  final Widget Function(MessageAppBarStateModel state)? appBare;
  final VRoom vRoom;

  ///set api if you want to make users able to pick locations
  final String? googleMapsApiKey;

  @override
  State<VMessagePage> createState() => _VMessagePageState();
}

class _VMessagePageState extends State<VMessagePage> {
  late final VMessageController controller;

  @override
  void initState() {
    super.initState();
    controller = VMessageController(
      vRoom: widget.vRoom,
      onMentionPress: widget.onMentionPress,
      isInTesting: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ValueListenableBuilder<MessageAppBarStateModel>(
          valueListenable: controller.appBarStateController.appBareState,
          builder: (context, value, child) {
            if (controller.isInTesting) {
              return VTestingMessageAppBare(
                state: value,
                onTyping: (p0) {},
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
          ValueListenableBuilder<List<VBaseMessage>>(
            valueListenable: controller.messageState.stateNotifier,
            builder: (_, value, __) {
              return Expanded(
                child: ListView.separated(
                  key: UniqueKey(),
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 10,
                  ),
                  cacheExtent: 300,
                  itemBuilder: (context, index) {
                    final message = value[index];
                    return StreamBuilder<VBaseMessage>(
                      stream: controller.messageState.messageStateStream.stream
                          .takeWhile(
                        (e) => e.localId == message.localId,
                      ),
                      initialData: message,
                      builder: (context, snapshot) {
                        return VMessageItem(
                          itemController: controller.itemController,
                          message: snapshot.data!,
                          onMentionPress: controller.onMentionPress,
                        );
                      },
                    );
                  },
                  itemCount: value.length,
                  reverse: true,
                ),
              );
            },
          ),
          ValueListenableBuilder<MessageInputModel>(
            valueListenable: controller.inputStateController.inputState,
            builder: (_, value, __) {
              return VMessageInputWidget(
                onSubmitText: controller.onSubmitText,
                onSubmitMedia: controller.onSubmitMedia,
                onSubmitVoice: controller.onSubmitVoice,
                onSubmitFiles: controller.onSubmitFiles,
                onSubmitLocation: controller.onSubmitLocation,
                onTypingChange: controller.onTypingChange,
                googleMapsApiKey: widget.googleMapsApiKey,
                replyWidget: value.replyMsg == null
                    ? null
                    : ReplyMsgWidget(vBaseMessage: value.replyMsg!),
                stopChatWidget:
                    value.isCloseInput ? const StopTypingWidget() : null,
              );
            },
          )
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
