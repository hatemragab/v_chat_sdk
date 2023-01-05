import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:v_chat_input_ui/v_chat_input_ui.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../models/app_bare_state_model.dart';
import '../../models/input_state_model.dart';
import '../../v_message.dart';
import '../../widgets/app_bare/v_message_app_bare.dart';
import '../../widgets/arrow_down.dart';
import '../../widgets/input_widgets/reply_msg_widget.dart';
import '../../widgets/input_widgets/stop_typing_widget.dart';
import '../../widgets/message_items/v_message_item.dart';
import '../../widgets/message_items/widgets/date_divider_item.dart';

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
          Expanded(
            child: Stack(
              children: [
                ValueListenableBuilder<List<VBaseMessage>>(
                  valueListenable: controller.messageState.stateNotifier,
                  builder: (_, value, __) {
                    return Scrollbar(
                      interactive: true,
                      thickness: 5,
                      key: UniqueKey(),
                      controller: controller.autoScrollTagController,
                      child: ListView.separated(
                        controller: controller.autoScrollTagController,
                        key: const PageStorageKey("VListViewItems"),
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                        cacheExtent: 300,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final message = value[index];
                          final msgItem = StreamBuilder<VBaseMessage>(
                            stream: controller
                                .messageState.messageStateStream.stream
                                .where(
                              (e) => e.localId == message.localId,
                            ),
                            initialData: message,
                            builder: (context, snapshot) {
                              return AutoScrollTag(
                                controller: controller.autoScrollTagController,
                                key: ValueKey(message.localId),
                                index: index,
                                highlightColor: context.isDark
                                    ? Colors.white.withOpacity(0.2)
                                    : Colors.black.withOpacity(0.2),
                                child: VMessageItem(
                                  itemController: controller.itemController,
                                  message: snapshot.data!,
                                  voiceController: controller.voiceControllers
                                      .getVoiceController(
                                    snapshot.data!,
                                  ),
                                  room: controller.vRoom,
                                  onSwipe: controller.setReply,
                                  onHighlightMessage:
                                      controller.onHighlightMessage,
                                  onMentionPress: controller.onMentionPress,
                                ),
                              );
                            },
                          );

                          final isTopMessage =
                              _isTopMessage(value.length, index);
                          final dividerDate = _getDateDiff(
                            bigDate: message.createdAtDate,
                            smallDate: isTopMessage
                                ? value[index].createdAtDate
                                : value[index + 1].createdAtDate,
                          );
                          if (dividerDate != null || isTopMessage) {
                            //set date divider
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                DateDividerItem(
                                  dateTime:
                                      dividerDate ?? message.createdAtDate,
                                ),
                                msgItem,
                              ],
                            );
                          }
                          return msgItem;
                        },
                        itemCount: value.length,
                        reverse: true,
                      ),
                    );
                  },
                ),
                PositionedDirectional(
                  bottom: 10,
                  end: 20,
                  child: ListViewArrowDown(
                    scrollController: controller.autoScrollTagController,
                    onPress: controller.scrollDown,
                  ),
                ),
              ],
            ),
          ),
          ValueListenableBuilder<MessageInputModel>(
            valueListenable: controller.inputStateController.inputState,
            builder: (_, value, __) {
              return VMessageInputWidget(
                onSubmitText: controller.onSubmitText,
                onSubmitMedia: (files) =>
                    controller.onSubmitMedia(context, files),
                onSubmitVoice: controller.onSubmitVoice,
                onSubmitFiles: controller.onSubmitFiles,
                onSubmitLocation: controller.onSubmitLocation,
                onTypingChange: controller.onTypingChange,
                googleMapsLangKey: "en",
                maxMediaSize: _config.maxMediaSize,
                onMentionSearch: controller.onMentionRequireSearch,
                maxRecordTime: _config.maxRecordTime,
                googleMapsApiKey: _config.googleMapsApiKey,
                replyWidget: value.replyMsg == null
                    ? null
                    : ReplyMsgWidget(
                        vBaseMessage: value.replyMsg!,
                        onDismiss: controller.dismissReply,
                      ),
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

  bool _isTopMessage(int listLength, int index) {
    return listLength - 1 == index;
  }

  DateTime? _getDateDiff({
    required DateTime bigDate,
    required DateTime smallDate,
  }) {
    final difference = bigDate.difference(smallDate);
    if (difference.isNegative) {
      return null;
    }
    if (difference.inHours < 24) {
      final d1 = bigDate.day;
      final d2 = smallDate.day;
      if (d1 == d2) {
        return null;
      } else {
        return bigDate;
      }
    }
    return bigDate;
  }
}
