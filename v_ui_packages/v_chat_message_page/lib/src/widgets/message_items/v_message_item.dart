// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:v_chat_message_page/src/widgets/message_items/shared/center_item_holder.dart';
import 'package:v_chat_message_page/src/widgets/message_items/shared/direction_item_holder.dart';
import 'package:v_chat_message_page/src/widgets/message_items/shared/forward_item_widget.dart';
import 'package:v_chat_message_page/src/widgets/message_items/shared/group_header.dart';
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
import 'package:v_chat_utils/v_chat_utils.dart';
import 'package:v_chat_voice_player/v_chat_voice_player.dart';

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

  bool get isAllowOnTap =>
      !message.messageType.isAllDeleted &&
      !message.messageType.isVoice &&
      onTap != null;

  bool get isAllowLongTap => onLongTap != null;

  @override
  Widget build(BuildContext context) {
    //we have date divider holder
    //we have normal holder
    //we have info holder

    if (message.messageType.isCenter) {
      return CenterItemHolder(
        child: message.getMessageTextInfoTranslated(context).text.italic.medium,
      );
    }
    return InkWell(
      onLongPress: isAllowLongTap
          ? () {
              onLongTap!(message);
            }
          : null,
      onTap: isAllowOnTap
          ? () {
              onTap!(message);
            }
          : null,
      child: SwipeTo(
        key: UniqueKey(),
        onRightSwipe: onSwipe == null || message.messageType.isAllDeleted
            ? null
            : () {
                onSwipe!(message);
              },
        child: DirectionItemHolder(
          isMeSender: message.isMeSender,
          child: Column(
            crossAxisAlignment: message.isMeSender
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              message.isMeSender
                  ? const SizedBox.shrink()
                  : GroupHeader(
                      isGroup: roomType.isGroup,
                      senderImage: message.senderImageThumb,
                      senderName: message.senderName,
                      onTab: () {
                        _onMentionPress(context,message.sIdentifier);
                      },
                    ),
              ForwardItemWidget(
                isFroward: message.isForward,
              ),
              ReplyItemWidget(
                rToMessage:
                    message.messageType.isAllDeleted ? null : message.replyTo,
                onHighlightMessage: onHighlightMessage,
              ),
              _getChild(message, context),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MessageBroadcastWidget(
                    isFromBroadcast: message.isFromBroadcast,
                  ),
                  MessageTimeWidget(
                    dateTime: message.createdAtDate,
                  ),
                  MessageStatusIcon(
                    model: MessageStatusIconDataModel(
                      isSeen: message.seenAt != null,
                      isDeliver: message.deliveredAt != null,
                      emitStatus: message.emitStatus,
                      isMeSender: message.isMeSender,
                    ),
                    onReSend: () {
                      if (onReSend != null) {
                        onReSend!(message);
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _getChild(VBaseMessage message, BuildContext context) {
    switch (message.messageType) {
      case VMessageType.allDeleted:
        return AllDeletedItem(
          message: message as VAllDeletedMessage,
        );
      case VMessageType.text:
        return TextMessageItem(
          message: (message as VTextMessage).realContent,
          textStyle: context.vMessageTheme.textItemStyle(
            context,
            message.isMeSender,
          ),
          onLinkPress: (link) async {
            await VStringUtils.lunchLink(link);
          },
          onEmailPress: (email) async {
            await VStringUtils.lunchLink(email);
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
        return context.vMessageTheme.customMessageItem(
          context,
          message.isMeSender,
          (message as VCustomMessage).data.data,
        );

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
}
