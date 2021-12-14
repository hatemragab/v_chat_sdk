import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:textless/textless.dart';
import 'package:v_chat_sdk/src/enums/room_type.dart';
import 'package:v_chat_sdk/src/models/v_chat_room.dart';
import 'package:v_chat_sdk/src/services/v_chat_app_service.dart';
import 'package:v_chat_sdk/src/utils/custom_widgets/circle_image.dart';

import '../../../../enums/message_type.dart';
import '../../../../models/v_chat_message.dart';
import '../../cubit/message_cubit.dart';
import 'message_file_view.dart';
import 'message_image_item.dart';
import 'message_text_item.dart';
import 'message_video_item.dart';
import 'message_voice_view.dart';
import 'render_message_send_at_day_item.dart';

class MessageItemView extends StatelessWidget {
  final VChatMessage message;
  final int index;
  final String myId;
  final VChatRoom chatRoom;

  const MessageItemView(
      {required this.myId,
      required this.message,
      required this.index,
      required this.chatRoom,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSender = myId == message.senderId;
    final maxPaddingWidth = MediaQuery.of(context).size.width * .80;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isLightMessageType(message.messageType)) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            VChatAppService.instance.vcBuilder
                .infoLightMessage(message.content, context),
            SizedBox(
              height: 5,
            ),
            message.createdAtString.toString().cap,
          ],
        ),
      );
    }
    if (isDarkMessageType(message.messageType)) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            VChatAppService.instance.vcBuilder
                .infoDarkMessage(message.content, context),
            SizedBox(
              height: 5,
            ),
            message.createdAtString.toString().cap,
          ],
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: getCrossAlign(isSender: isSender),
      children: [
        IgnorePointer(
          ignoring: true,
          child: RenderMessageSendAtDayItem(
            index: index,
            message: message,
            messages: context.read<MessageCubit>().messages,
          ),
        ),
        chatRoom.roomType == RoomType.groupChat
            ? !isSender
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          message.senderName.text,
                        ],
                      ),
                      CircleImage.network(
                          path: message.senderImageThumb, radius: 10)
                    ],
                  )
                : const SizedBox.shrink()
            : const SizedBox.shrink(),
        const SizedBox(
          height: 5,
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxPaddingWidth),
          child:
              getItemBody(isSender: isSender, context: context, isDark: isDark),
        ),
        const SizedBox(height: 2),
        if (isSender)
          Row(
            mainAxisAlignment: getMainAxisAlign(isSender: isSender),
            children: [
              message.createdAtString.toString().cap,
              const SizedBox(width: 2),
            ],
          )
        else
          message.createdAtString.toString().cap,
      ],
    );
  }

  Widget getItemBody({
    required bool isSender,
    required BuildContext context,
    required bool isDark,
  }) {
    switch (message.messageType) {
      case MessageType.text:
        return MessageTextItem(
          isSender: isSender,
          message: message,
        );
      case MessageType.voice:
        return MessageVoiceView(
          message,
          isSender: isSender,
        );
      case MessageType.image:
        return MessageImageItem(message, isSender: isSender);
      case MessageType.video:
        return MessageVideoItem(
          message,
          isSender: isSender,
        );

      case MessageType.file:
        return MessageFileView(
          message,
          isSender: isSender,
        );

      case MessageType.reply:
        return message.content.text;

      case MessageType.allDeleted:
        return message.content.text;

      default:
        return message.content.text;
    }
  }

  MainAxisAlignment getMainAxisAlign({required bool isSender}) {
    if (isSender) {
      return MainAxisAlignment.end;
    } else {
      return MainAxisAlignment.start;
    }
  }

  CrossAxisAlignment getCrossAlign({required bool isSender}) {
    if (isSender) {
      return CrossAxisAlignment.end;
    } else {
      return CrossAxisAlignment.start;
    }
  }

  bool isLightMessageType(MessageType t) {
    return t == MessageType.join ||
        t == MessageType.create ||
        t == MessageType.upgrade ||
        t == MessageType.info;
  }

  bool isDarkMessageType(MessageType t) {
    return t == MessageType.leave ||
        t == MessageType.downgrade ||
        t == MessageType.kick;
  }
}
