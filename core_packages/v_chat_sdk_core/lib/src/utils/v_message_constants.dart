import 'package:flutter/cupertino.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

abstract class VMessageConstants {
  static String getMessageBody(
    VBaseMessage m,
    BuildContext context,
  ) {
    //todo fix
    // if (m is VInfoMessage) {
    //   final infoAtt = m.data;
    //   switch (infoAtt.action) {
    //     case MessageInfoType.updateTitle:
    //       return "${infoAtt.adminName} ${S.of(context).updateTitleTo} ${infoAtt.targetName}";
    //     case MessageInfoType.updateImage:
    //       return "${infoAtt.adminName} ${S.of(context).updateImage}";
    //     case MessageInfoType.addGroupMember:
    //       return "${infoAtt.targetName} ${S.of(context).joinedBy} ${infoAtt.adminName}";
    //     case MessageInfoType.upAdmin:
    //       return "${infoAtt.targetName} ${S.of(context).promotedToAdminBy} ${infoAtt.adminName}";
    //     case MessageInfoType.downMember:
    //       return "${infoAtt.targetName} ${S.of(context).dismissedToMemberBy} ${infoAtt.adminName}";
    //     case MessageInfoType.leave:
    //       return "${infoAtt.targetName} ${S.of(context).leftTheGroup}";
    //     case MessageInfoType.kick:
    //       if (infoAtt.isMe) {
    //         return "You ${S.of(context).kickedBy} ${infoAtt.adminName}";
    //       }
    //       return "${infoAtt.targetName} ${S.of(context).kickedBy} ${infoAtt.adminName}";
    //     case MessageInfoType.createGroup:
    //       return "${S.of(context).groupCreatedBy} ${infoAtt.adminName}";
    //
    //     case MessageInfoType.addToBroadcast:
    //       return "${infoAtt.adminName} ${S.of(context).addedYouToNewBroadcast} ${infoAtt.targetName}";
    //   }
    // }
    return m.realContent;
  }

  static const String heart = "\u{2764}";
  static const String faceWithTears = "\u{1F602}";
  static const String disappointedFace = "\u{1F625}";
  static const String angryFace = "\u{1F621}";
  static const String astonishedFace = "\u{1F632}";
  static const String thumbsUp = "\u{1F44D}";

  static const thisContentIsFile = "📁";
  static const thisContentIsVoice = "🎤";
  static const thisContentIsImage = "📷";
  static const thisContentIsVideo = "🎥";
  static const thisContentIsLocation = "📍";
}
