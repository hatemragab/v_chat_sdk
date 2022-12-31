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
  final bool isInTesting;

  const VMessagePage({
    Key? key,
    required this.vRoom,
    this.isInTesting = false,
  }) : super(key: key);
  final VRoom vRoom;

  @override
  State<VMessagePage> createState() => _VMessagePageState();
}

class _VMessagePageState extends State<VMessagePage> {
  late final VMessageController controller;
  final _config = VChatController.I.vMessagePageConfig;
  @override
  void initState() {
    super.initState();
    controller = VMessageController(
      vRoom: widget.vRoom,
      onMentionPress: (userId) {
        final method = _config.onMentionPress;
        if (method != null) {
          method(context, userId);
        }
      },
      isInTesting: widget.isInTesting,
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
            return VMessageAppBare(
              state: value,
              onTitlePress: (context, id, roomType) {
                final method = _config.onAppBarTitlePress;
                if (method != null) {
                  method(context, id, roomType);
                }
              },
            );
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const VSocketStatusWidget(delay: Duration.zero),
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
                          .where(
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
                googleMapsLangKey: "en",
                maxMediaSize: _config.maxMediaSize,
                onMentionSearch: (p0) async {
                  //todo search over users
                  return <MentionWithPhoto>[];
                },
                maxRecordTime: _config.maxRecordTime,
                googleMapsApiKey: _config.googleMapsApiKey,
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
