// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

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
import '../../widgets/drag_drop_if_web_desk.dart';
import '../../widgets/input_widgets/ban_widget.dart';
import '../../widgets/input_widgets/reply_msg_widget.dart';
import '../../widgets/message_items/v_message_item.dart';

typedef X = Widget Function(
  MessageAppBarStateModel state,
  Function(String) onSearch,
  Function() onCloseSearch,
);

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
      context: context,
      isInTesting: widget.isInTesting,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ValueListenableBuilder<MessageAppBarStateModel>(
          valueListenable: controller.appBarStateController,
          builder: (context, value, child) {
            if (value.isSearching) {
              return VSearchAppBare(
                onClose: controller.onCloseSearch,
                onSearch: controller.onSearch,
              );
            }
            return VMessageAppBare(
              state: value,
              onSearch: controller.onOpenSearch,
              onCreateCall: controller.onCreateCall,
              onViewMedia: () => controller.onViewMedia(context, value.roomId),
              onTitlePress: controller.onTitlePress,
            );
          },
        ),
      ),
      body: Container(
        decoration: context.vMessageTheme.scaffoldDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const VSocketStatusWidget(
              delay: Duration.zero,
            ),
            Expanded(
              child: Stack(
                children: [
                  DragDropIfWeb(
                    onDragDone: controller.onSubmitFiles,
                    child: ValueListenableBuilder<List<VBaseMessage>>(
                      valueListenable: controller.messageState,
                      builder: (_, value, __) {
                        return Scrollbar(
                          interactive: true,
                          thickness: 5,
                          controller: controller.autoScrollTagController,
                          child: ListView.separated(
                            controller: controller.autoScrollTagController,
                            // key: const PageStorageKey("VListViewItems"),
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 8,
                            ),
                            cacheExtent: 300,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Builder(
                                key: UniqueKey(),
                                builder: (context) {
                                  final message = value[index];
                                  final msgItem = StreamBuilder<VBaseMessage>(
                                    stream: controller
                                        .messageState.messageStateStream.stream
                                        .where(
                                      (e) => e.localId == message.localId,
                                    ),
                                    initialData: message,
                                    builder: (context, snapshot) {
                                      if (message.isDeleted) {
                                        return const SizedBox.shrink();
                                      }
                                      return AutoScrollTag(
                                        key: UniqueKey(),
                                        controller:
                                            controller.autoScrollTagController,
                                        index: index,
                                        highlightColor: context.isDark
                                            ? Colors.white.withOpacity(0.2)
                                            : Colors.black.withOpacity(0.2),
                                        child: VMessageItem(
                                          onTap: controller.onMessageTap,
                                          roomType: widget.vRoom.roomType,
                                          onLongTap:
                                              controller.onMessageLongTap,
                                          message: snapshot.data!,
                                          voiceController: (message) {
                                            if (message is VVoiceMessage) {
                                              return controller.voiceControllers
                                                  .getVoiceController(message);
                                            }
                                            return null;
                                          },
                                          //room: controller.vRoom,
                                          onSwipe: controller.setReply,
                                          onHighlightMessage:
                                              controller.onHighlightMessage,
                                          onReSend: controller.onReSend,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        context.vMessageTheme.dateDividerWidget(
                                          context,
                                          dividerDate ?? message.createdAtDate,
                                        ),
                                        msgItem,
                                      ],
                                    );
                                  }
                                  return msgItem;
                                },
                              );
                            },
                            itemCount: value.length,
                            reverse: true,
                          ),
                        );
                      },
                    ),
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
            const SizedBox(
              height: 5,
            ),
            SafeArea(
              child: ValueListenableBuilder<MessageInputModel>(
                valueListenable: controller.inputStateController,
                builder: (_, value, __) {
                  if (value.isHidden) return const SizedBox.shrink();
                  return VMessageInputWidget(
                    onSubmitText: controller.onSubmitText,
                    autofocus:
                        !VPlatforms.isWebRunOnMobile && !VPlatforms.isMobile,
                    language: VInputLanguage(
                      files: VTrans.of(context).labels.shareFiles,
                      location: VTrans.of(context).labels.shareLocation,
                      media: VTrans.of(context).labels.media,
                      shareMediaAndLocation:
                          VTrans.of(context).labels.shareMediaAndLocation,
                      textFieldHint: VTrans.of(context).labels.typeYourMessage,
                    ),
                    focusNode: controller.focusNode,
                    onSubmitMedia: (files) =>
                        controller.onSubmitMedia(context, files),
                    onSubmitVoice: controller.onSubmitVoice,
                    onSubmitFiles: controller.onSubmitFiles,
                    onSubmitLocation: controller.onSubmitLocation,
                    onTypingChange: controller.onTypingChange,
                    googleMapsLangKey: VAppConstants.sdkLanguage,
                    maxMediaSize: _config.maxMediaSize,
                    onMentionSearch: (query) =>
                        controller.onMentionRequireSearch(context, query),
                    maxRecordTime: _config.maxRecordTime,
                    googleMapsApiKey: _config.googleMapsApiKey,
                    replyWidget: value.replyMsg == null
                        ? null
                        : ReplyMsgWidget(
                            vBaseMessage: value.replyMsg!,
                            onDismiss: controller.dismissReply,
                          ),
                    stopChatWidget: value.isCloseInput
                        ? BanWidget(
                            isMy: false,
                            onUnBan: () {},
                          )
                        : null,
                  );
                },
              ),
            )
          ],
        ),
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
