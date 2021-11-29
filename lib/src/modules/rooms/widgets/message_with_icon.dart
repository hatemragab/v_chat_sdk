import 'package:flutter/material.dart';
import 'package:textless/textless.dart';

import '../../../enums/message_type.dart';
import '../../../enums/room_type.dart';
import '../../../models/v_chat_room.dart';
import '../../../services/v_chat_app_service.dart';
import '../../../utils/custom_widgets/auto_direction.dart';
import '../../../utils/custom_widgets/circle_image.dart';

class MessageWithIcon extends StatelessWidget {
  final VChatRoom _room;
  final _myModel = VChatAppService.instance.vChatUser!;

  MessageWithIcon(this._room, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_room.lastMessage.messageType == MessageType.info) {
      return _room.lastMessage.content.b1.maxLine(1).alignStart.overflowEllipsis;
    }

    return Row(
      children: [
        const SizedBox(
          width: 5,
        ),
        Flexible(
          child: AutoDirection(
            text: _room.lastMessage.content,
            child: getMessageText(context),
          ),
        ),
      ],
    );
  }

  Widget getMessageText(BuildContext context) {
    /// i the receiver
    if (_room.lastMessage.senderId != _myModel.id) {
      final _isMeSeen = _room.lastMessageSeenBy.contains(_myModel.id);

      /// I read the message
      if (_isMeSeen) {
        return _room.lastMessage.content.b1.color(Colors.grey).maxLine(1).alignStart.overflowEllipsis;
      } else {
        /// I not read  the message yet
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(flex: 4, child: _room.lastMessage.content.b1.bold.maxLine(1)),
            Flexible(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.blueGrey,
                  shape: BoxShape.circle,
                ),
                child: "    ".s2.color(Colors.white),
              ),
            )
          ],
        );
      }
    } else {
      /// i the sender
      final _isPeerSeen = _room.lastMessageSeenBy.length == 2;
      if (_room.roomType == RoomType.single && _isPeerSeen) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: _room.lastMessage.content.b1.color(Colors.grey).maxLine(1).alignStart.overflowEllipsis,
            ),
            CircleImage.network(path: _room.thumbImage, radius: 10),
          ],
        );
      }

      return _room.lastMessage.content.b1.color(Colors.grey).maxLine(1).alignStart.overflowEllipsis;
    }
  }
}
