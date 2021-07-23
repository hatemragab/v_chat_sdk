import 'package:auto_direction/auto_direction.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:textless/textless.dart';
import '../../../enums/message_type.dart';
import '../../../enums/room_type.dart';
import '../../../models/vchat_message.dart';
import '../../../utils/custom_widgets/circle_image.dart';
import '../controllers/message_controller.dart';
import 'render_message_send_at_day_item.dart';
import 'widgets/message_file_view.dart';
import 'widgets/message_image_item.dart';
import 'widgets/message_video_item.dart';
import 'widgets/message_voice_view.dart';

class MessageItemView extends GetView<MessageController> {
  final VchatMessage _message;
  final int index;

  MessageItemView(this._message, this.index);

  @override
  Widget build(BuildContext context) {
    final isSender = controller.myModel!.id == _message.senderId;
    final paddingWidth = MediaQuery.of(context).size.width * .80;

    // handle  join && leave
    if (_message.messageType == MessageType.info) {
      return getJoinOrLeaveMessage();
    }

    return InkWell(
      onLongPress: () {
        controller.showMessageLongPress(
            isSender: isSender, selectedMessage: _message, context: context);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: getCrossAlign(isSender: isSender),
        children: [
          IgnorePointer(
            ignoring: true,
            child: RenderMessageSendAtDayItem(
              index: index,
              message: _message,
              messages: controller.messagesList,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          !isSender && controller.currentRoom!.roomType == RoomType.groupChat
              ? InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      CircleImage.network(
                        path: _message.senderImageThumb,
                        width: 25,
                        height: 25,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      _message.senderName.cap,
                    ],
                  ),
                )
              : const SizedBox.shrink(),
          const SizedBox(
            height: 5,
          ),
          Container(
            constraints: BoxConstraints(maxWidth: paddingWidth),
            padding: _message.messageType == MessageType.text
                ? EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5)
                : EdgeInsets.zero,
            decoration: BoxDecoration(
              color: isSender
                  ? Theme.of(context).brightness == Brightness.dark
                      ? Color(0xff876969)
                      : Colors.tealAccent
                  : Theme.of(context).brightness == Brightness.dark
                      ? Color(0xff453131)
                      : Colors.blueGrey[100],
              borderRadius: getContainerBorder(isSender: isSender),
              border: Border.all(color: Colors.black12),
            ),
            child: getItemBody(isSender: isSender, context: context),
          ),
          const SizedBox(height: 2),
          if (isSender)
            Row(
              mainAxisAlignment: getMainAxisAlign(isSender: isSender),
              children: [
                _message.createdAtString.toString().cap,
                const SizedBox(width: 2),
              ],
            )
          else
            _message.createdAtString.toString().cap,
        ],
      ),
    );
  }

  BorderRadius getContainerBorder({required bool isSender}) {
    final radius = 17.0;
    if (isSender) {
      return BorderRadius.only(
        topLeft: Radius.circular(radius),
        bottomLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
      );
    } else {
      return BorderRadius.only(
        topRight: Radius.circular(radius),
        bottomRight: Radius.circular(radius),
        topLeft: Radius.circular(radius),
      );
    }
  }

  Widget getItemBody({required bool isSender,required BuildContext context}) {
    switch (_message.messageType) {
      case MessageType.text:
        return AutoDirection(
          text: _message.content,
          child: ReadMoreText(
            _message.content.toString(),
            trimLines: 5,
            trimMode: TrimMode.Line,
            trimCollapsedText: 'Show more',
            trimExpandedText: 'Show less',
            moreStyle: Get.textTheme.bodyText2!.copyWith(color: Colors.red),
            style: Theme.of(context).textTheme.subtitle2,
          ),
        );
      case MessageType.voice:
        return MessageVoiceView(
          _message,
          isSender: isSender,
        );
      case MessageType.image:
        return MessageImageItem(_message, isSender: isSender);
      case MessageType.video:
        return MessageVideoItem(
          _message,
          isSender: isSender,
        );

      case MessageType.file:
        return MessageFileView(
          _message,
          isSender: isSender,
        );

      case MessageType.reply:
        // TODO: Handle this case.
        break;

      case MessageType.allDeleted:
        // TODO: Handle this case.
        break;
      default:
        throw ("getItemBody Not Supported");
    }
    return SizedBox.shrink();
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

  Widget getJoinOrLeaveMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.lightBlue),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              "${_message.content}".b1.size(15).maxLine(1),
              "Time".cap
            ],
          ),
        ),
      ],
    );
  }
}
