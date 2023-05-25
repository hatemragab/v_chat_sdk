// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:v_chat_message_page/src/widgets/message_items/shared/bubble/bubble_normal.dart';
import 'package:v_chat_message_page/src/widgets/message_items/shared/center_item_holder.dart';
import 'package:v_chat_message_page/src/widgets/message_items/shared/forward_item_widget.dart';
import 'package:v_chat_message_page/src/widgets/message_items/shared/message_broadcast_icon.dart';
import 'package:v_chat_message_page/src/widgets/message_items/shared/message_time_widget.dart';
import 'package:v_chat_message_page/src/widgets/message_items/shared/reply_item_widget.dart';
import 'package:v_chat_message_page/src/widgets/message_items/widgets/all_deleted_item.dart';
import 'package:v_chat_message_page/src/widgets/message_items/widgets/call_message_item.dart';
import 'package:v_chat_message_page/src/widgets/message_items/widgets/file_message_item.dart';
import 'package:v_chat_message_page/src/widgets/message_items/widgets/image_message_item.dart';
import 'package:v_chat_message_page/src/widgets/message_items/widgets/location_message_item.dart';
import 'package:v_chat_message_page/src/widgets/message_items/widgets/text_message_item.dart';
import 'package:v_chat_message_page/src/widgets/message_items/widgets/video_message_item.dart';
import 'package:v_chat_message_page/src/widgets/message_items/widgets/voice_message_item.dart';
import 'package:v_chat_message_page/v_chat_message_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart' hide TextDirection;
import 'package:v_chat_voice_player/v_chat_voice_player.dart';
import 'package:v_platform/v_platform.dart';

import '../../core/types.dart';

class VMessageItem extends StatelessWidget {
  final VBaseMessage message;
  final VMessageCallback? onSwipe;
  final VMessageCallback? onTap;
  final VMessageCallback? onLongTap;
  final VVoiceMessageController? Function(VBaseMessage message)?
      voiceController;
  final VMessageCallback? onHighlightMessage;
  final VMessageCallback? onReSend;
  final VRoomType roomType;

  const VMessageItem({
    Key? key,
    this.onLongTap,
    required this.roomType,
    this.onTap,
    this.voiceController,
    required this.message,
    this.onSwipe,
    this.onReSend,
    this.onHighlightMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (message.messageType.isCenter) {
      return CenterItemHolder(
        child: message.getMessageTextInfoTranslated(context).text.italic.medium,
      );
    }

    return InkWell(
      onLongPress: () => onLongTap?.call(message),
      onTap: () => onTap?.call(message),
      child: SwipeTo(
        key: UniqueKey(),
        onRightSwipe: message.isAllDeleted
            ? null
            : () {
                onSwipe?.call(message);
              },
        child: Row(
          mainAxisAlignment: message.isMeSender
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _getGroupUserAvatar(context),
            Visibility(
              visible: !message.isMeSender ? false : !message.isContainReply,
              child: _getMessageActions,
            ),
            Column(
              crossAxisAlignment: message.isMeSender
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                _getGroupUserTitle(context),
                const SizedBox(
                  height: 5,
                ),
                ReplyItemWidget(
                  rToMessage: message.isAllDeleted ? null : message.replyTo,
                  onHighlightMessage: onHighlightMessage,
                  isMeSender: message.isMeSender,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Visibility(
                      visible:
                          !message.isMeSender ? false : message.isContainReply,
                      child: _getMessageActions,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: VPlatforms.isMobile
                            ? MediaQuery.of(context).size.width * .73
                            : MediaQuery.of(context).size.width * .40,
                      ),
                      child: BubbleNormal(
                        isSender: message.isMeSender,
                        tail: true,
                        bubbleRadius: 10,
                        color: message.messageType.isMedia
                            ? Colors.transparent
                            : message.isMeSender
                                ? context.vMessageTheme.senderBubbleColor
                                : context.vMessageTheme.receiverBubbleColor,
                        child: _getChild(context),
                      ),
                    ),
                    Visibility(
                      visible:
                          message.isMeSender ? false : message.isContainReply,
                      child: _getMessageActions,
                    ),
                  ],
                ),
              ],
            ),
            Visibility(
              visible: message.isMeSender ? false : !message.isContainReply,
              child: _getMessageActions,
            ),
          ],
        ),
      ),
    );
  }

  Widget get _getMessageActions {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          MessageTimeWidget(
            dateTime: message.createdAtDate,
          ),
          const SizedBox(
            width: 1,
          ),
          MessageBroadcastWidget(
            isFromBroadcast: message.isFromBroadcast,
          ),
          const SizedBox(
            width: 1,
          ),
          ForwardItemWidget(
            isFroward: message.isForward,
          ),
          const SizedBox(
            width: 1,
          ),
          MessageStatusIcon(
            model: MessageStatusIconDataModel(
              isSeen: message.seenAt != null,
              isDeliver: message.deliveredAt != null,
              emitStatus: message.emitStatus,
              isMeSender: message.isMeSender,
            ),
            onReSend: () {
              onReSend?.call(message);
            },
          ),
          const SizedBox(
            width: 1,
          ),
        ],
      ),
    );
  }

  Widget _getChild(BuildContext context) {
    if (message.allDeletedAt != null) {
      return AllDeletedItem(
        message: message,
      );
    }
    switch (message.messageType) {
      case VMessageType.text:
        return TextMessageItem(
          message: (message as VTextMessage).realContent,
          textStyle: message.isMeSender
              ? context.vMessageTheme.senderTextStyle
              : context.vMessageTheme.receiverTextStyle,
          onLinkPress: (link) async {
            await VStringUtils.lunchLink(link);
          },
          onEmailPress: (email) async {
            await VStringUtils.lunchEmail(email);
          },
          onMentionPress: _onMentionPress,
          onPhonePress: (phone) async {
            await VStringUtils.lunchLink(phone);
          },
        );

      case VMessageType.image:
        return ImageMessageItem(
          message: message as VImageMessage,
        );
      case VMessageType.file:
        return FileMessageItem(
          message: message as VFileMessage,
        );
      case VMessageType.video:
        return VideoMessageItem(
          message: message as VVideoMessage,
        );
      case VMessageType.voice:
        return VoiceMessageItem(
          message: message as VVoiceMessage,
          voiceController: voiceController!,
        );
      case VMessageType.location:
        return LocationMessageItem(
          message: message as VLocationMessage,
        );

      case VMessageType.call:
        return CallMessageItem(
          message: message as VCallMessage,
        );
      case VMessageType.custom:
        return context.vMessageTheme.customMessageItem?.call(
              context,
              message.isMeSender,
              (message as VCustomMessage).data.data,
            ) ??
            const Text(
                "custom message not implemented you need to add this data inside VInheritedMessageTheme which should be at the top of your app material widget");

      case VMessageType.info:
        throw "MessageType.info should not render her it center render!";
    }
  }

  void _onMentionPress(BuildContext context, String identifier) {
    final method =
        VChatController.I.vNavigator.messageNavigator.toUserProfilePage;
    if (method != null) {
      method(context, identifier);
    }
  }

  Widget _getGroupUserAvatar(BuildContext context) {
    if (roomType.isGroup && !message.isMeSender) {
      return InkWell(
        onTap: () {
          _onMentionPress(context, message.sIdentifier);
        },
        child: Row(
          children: [
            VCircleAvatar(
              fullUrl: message.senderImageThumb,
              radius: 14,
            ),
            const SizedBox(
              width: 5,
            )
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _getGroupUserTitle(BuildContext context) {
    if (roomType.isGroup && !message.isMeSender) {
      return InkWell(
        onTap: () {
          _onMentionPress(context, message.sIdentifier);
        },
        child: message.senderName.cap,
      );
    }
    return const SizedBox.shrink();
  }
}
