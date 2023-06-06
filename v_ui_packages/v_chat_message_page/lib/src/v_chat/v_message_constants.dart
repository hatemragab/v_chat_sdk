// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../v_chat_message_page.dart';

abstract class VMessageConstants {
  static String getMessageBody(VBaseMessage m, VMessagesInfoTrans language) {
    if (m is VInfoMessage) {
      final infoAtt = m.data;
      final messages = {
        VMessageInfoType.updateTitle:
            "${infoAtt.adminName} ${language.updateTitleTo} ${infoAtt.targetName}",
        VMessageInfoType.updateImage:
            "${infoAtt.adminName} ${language.updateImage}",
        VMessageInfoType.addGroupMember:
            "${infoAtt.targetName} ${language.joinedBy} ${infoAtt.adminName}",
        VMessageInfoType.upAdmin:
            "${infoAtt.targetName} ${language.promotedToAdminBy} ${infoAtt.adminName}",
        VMessageInfoType.downMember:
            "${infoAtt.targetName} ${language.dismissedToMemberBy} ${infoAtt.adminName}",
        VMessageInfoType.leave:
            "${infoAtt.targetName} ${language.leftTheGroup}",
        VMessageInfoType.kick: infoAtt.isMe
            ? "${language.you} ${language.kickedBy} ${infoAtt.adminName}"
            : "${infoAtt.targetName} ${language.kickedBy} ${infoAtt.adminName}",
        VMessageInfoType.createGroup:
            "${language.groupCreatedBy} ${infoAtt.adminName}",
        VMessageInfoType.addToBroadcast:
            "${infoAtt.adminName} ${language.addedYouToNewBroadcast} ${infoAtt.targetName}",
      };
      return messages[infoAtt.action] ?? m.realContent;
    }
    return m.contentTr ?? m.realContent;
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
