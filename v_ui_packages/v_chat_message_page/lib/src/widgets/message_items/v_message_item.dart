import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:v_chat_message_page/src/widgets/message_items/shared/center_item_holder.dart';
import 'package:v_chat_message_page/src/widgets/message_items/shared/direction_item_holder.dart';
import 'package:v_chat_message_page/src/widgets/message_items/shared/forward_ttem_widget.dart';
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
  final VRoom room;
  final VMessageCallback onSwipe;
  final VMessageCallback? onTap;
  final VMessageCallback? onLongTap;
  final VVoiceMessageController? Function(VBaseMessage message) voiceController;
  final VMessageCallback onHighlightMessage;
  final VMessageCallback onReSend;

  const VMessageItem({
    Key? key,
    required this.room,
    this.onLongTap,
    this.onTap,
    required this.voiceController,
    required this.message,
    required this.onSwipe,
    required this.onReSend,
    required this.onHighlightMessage,
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
        onRightSwipe: () {
          onSwipe(message);
        },
        child: DirectionItemHolder(
          isMeSender: message.isMeSender,
          child: Column(
            crossAxisAlignment: message.isMeSender
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
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
                    isDeliver: message.deliveredAt != null,
                    isSeen: message.seenAt != null,
                    isMeSender: message.isMeSender,
                    vBaseMessage: message,
                    onReSend: onReSend,
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
      case MessageType.allDeleted:
        return AllDeletedItem(
          message: message as VAllDeletedMessage,
        );
      case MessageType.text:
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
          onMentionPress: (context, userId) {
            final method =
                VChatController.I.vNavigator.messageNavigator.toUserProfile;
            if (method != null) {
              method(context, userId);
            }
          },
          onPhonePress: (phone) async {
            await VStringUtils.lunchLink(phone);
          },
        );

      case MessageType.image:
        return ImageMessageItem(
          message: message as VImageMessage,
        );
      case MessageType.file:
        return FileMessageItem(
          message: message as VFileMessage,
        );
      case MessageType.video:
        return VideoMessageItem(
          message: message as VVideoMessage,
        );
      case MessageType.voice:
        return VoiceMessageItem(
          message: message as VVoiceMessage,
          voiceController: voiceController,
        );
      case MessageType.location:
        return LocationMessageItem(
          message: message as VLocationMessage,
        );

      case MessageType.call:
        return CallMessageItem(
          message: message as VCallMessage,
        );
      case MessageType.custom:
        return context.vMessageTheme.customMessageItem(
          context,
          message.isMeSender,
          (message as VCustomMessage).data.data,
        );

      case MessageType.info:
        throw "MessageType.info should not render her it center render!";
    }
  }
}
