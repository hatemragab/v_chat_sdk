// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

abstract class VMessageConstants {
  static String getMessageBody(VBaseMessage m, BuildContext context) {
    if (m is VInfoMessage) {
      final infoAtt = m.data;
      final messages = {
        VMessageInfoType.updateTitle:
            "${infoAtt.adminName} ${VTrans.labelsOf(context).updateTitleTo} ${infoAtt.targetName}",
        VMessageInfoType.updateImage:
            "${infoAtt.adminName} ${VTrans.labelsOf(context).updateImage}",
        VMessageInfoType.addGroupMember:
            "${infoAtt.targetName} ${VTrans.labelsOf(context).joinedBy} ${infoAtt.adminName}",
        VMessageInfoType.upAdmin:
            "${infoAtt.targetName} ${VTrans.labelsOf(context).promotedToAdminBy} ${infoAtt.adminName}",
        VMessageInfoType.downMember:
            "${infoAtt.targetName} ${VTrans.labelsOf(context).dismissedToMemberBy} ${infoAtt.adminName}",
        VMessageInfoType.leave:
            "${infoAtt.targetName} ${VTrans.labelsOf(context).leftTheGroup}",
        VMessageInfoType.kick: infoAtt.isMe
            ? "${VTrans.labelsOf(context).you} ${VTrans.labelsOf(context).kickedBy} ${infoAtt.adminName}"
            : "${infoAtt.targetName} ${VTrans.labelsOf(context).kickedBy} ${infoAtt.adminName}",
        VMessageInfoType.createGroup:
            "${VTrans.labelsOf(context).groupCreatedBy} ${infoAtt.adminName}",
        VMessageInfoType.addToBroadcast:
            "${infoAtt.adminName} ${VTrans.labelsOf(context).addedYouToNewBroadcast} ${infoAtt.targetName}",
      };
      return messages[infoAtt.action] ?? m.realContent;
    }
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
