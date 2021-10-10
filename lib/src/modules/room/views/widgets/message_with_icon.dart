import 'package:auto_direction/auto_direction.dart';
import 'package:flutter/material.dart';
import 'package:textless/textless.dart';
import '../../../../enums/message_type.dart';
import '../../../../enums/room_type.dart';
import '../../../../models/v_chat_room.dart';
import '../../../../services/vchat_app_service.dart';
import '../../../../utils/custom_widgets/circle_image.dart';



class MessageWithIcon extends StatelessWidget {
  final VChatRoom _room;
  final _myModel = VChatAppService.to.vChatUser!;

  MessageWithIcon(this._room, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_room.lastMessage.messageType == MessageType.info) {
      return _room.lastMessage.content.s1
          .maxLine(1)
          .size(17)
          .alignStart
          .overflowEllipsis;
    }

    return Row(
      children: [
        const SizedBox(
          width: 5,
        ),
        Flexible(
            child: AutoDirection(
                text: _room.lastMessage.content,
                child: getMessageText())),
      ],
    );
  }

  Widget getMessageText() {
    if (_room.lastMessage.senderId != _myModel.id) {
      // i the receiver
      final _isMeSeen = _room.lastMessageSeenBy.contains(_myModel.id);

      if (_isMeSeen) {
        return _room.lastMessage.content.s1
            .maxLine(1)
            .size(17)
            .alignStart
            .overflowEllipsis;
      } else {
        return _room.lastMessage.content.h6
            .maxLine(1)
            .size(17.5)
            .alignStart
            .overflowEllipsis
            .black;
      }
    } else {
      // i the sender
      final _isPeerSeen = _room.lastMessageSeenBy.length == 2;
      if (_room.roomType == RoomType.single && _isPeerSeen) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: _room.lastMessage.content.s1
                  .maxLine(1)
                  .size(17)
                  .alignStart
                  .overflowEllipsis,
            ),
            CircleImage.network(path: _room.thumbImage ,radius: 10),
          ],
        );
      }

      return _room.lastMessage.content.s1
          .maxLine(1)
          .alignStart
          .overflowEllipsis;
    }
  }
}
