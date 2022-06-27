import 'package:flutter/material.dart';
import 'package:textless/textless.dart';
import 'package:v_chat_sdk/src/enums/room_type.dart';
import 'package:v_chat_sdk/src/models/v_chat_room.dart';
import 'package:v_chat_sdk/src/services/v_chat_app_service.dart';
import 'package:v_chat_sdk/src/utils/custom_widgets/auto_direction.dart';
import 'package:v_chat_sdk/src/utils/custom_widgets/circle_image.dart';
import 'package:v_chat_sdk/src/utils/helpers/helpers.dart';

class MessageWithIcon extends StatelessWidget {
  final VChatRoom _room;
  final _myModel = VChatAppService.instance.vChatUser!;

  MessageWithIcon(this._room, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String messageContent = Helpers.getMessageBody(
      _room.lastMessage,
      VChatAppService.instance.getTrans(context),
    );

    return Row(
      children: [
        const SizedBox(
          width: 5,
        ),
        Flexible(
          child: AutoDirection(
            text: messageContent,
            child: getMessageText(context, messageContent),
          ),
        ),
      ],
    );
  }

  Widget getMessageText(BuildContext context, String messageContent) {
    /// i the receiver
    if (_room.lastMessage.senderId != _myModel.id) {
      final _unReadCount = _room.unReadCount;

      /// I read the message
      if (_unReadCount == 0) {
        return messageContent.b1
            .color(Colors.grey)
            .maxLine(1)
            .alignStart
            .overflowEllipsis;
      } else {
        /// I not read  the message yet
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 4,
              child: messageContent.b1.bold.maxLine(1),
            ),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.blueGrey,
                  shape: BoxShape.circle,
                ),
                child: _unReadCount.toString().s2.color(Colors.white),
              ),
            )
          ],
        );
      }
    } else {
      /// i the sender
      final _isPeerSeen = _room.ifPeerReadMyLastMessage == 1;
      if (_room.roomType == RoomType.single && _isPeerSeen) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: messageContent.b1
                  .color(Colors.grey)
                  .maxLine(1)
                  .alignStart
                  .overflowEllipsis,
            ),
            CircleImage.network(path: _room.thumbImage, radius: 10),
          ],
        );
      }

      return messageContent.b1
          .color(Colors.grey)
          .maxLine(1)
          .alignStart
          .overflowEllipsis;
    }
  }
}
