// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

abstract class VMessageConstants {
  static String getMessageBody(
    VBaseMessage m,
    BuildContext context,
  ) {
    if (m is VInfoMessage) {
      final infoAtt = m.data;
      switch (infoAtt.action) {
        case VMessageInfoType.updateTitle:
          return "${infoAtt.adminName} ${VTrans.labelsOf(context).updateTitleTo} ${infoAtt.targetName}";
        case VMessageInfoType.updateImage:
          return "${infoAtt.adminName} ${VTrans.labelsOf(context).updateImage}";
        case VMessageInfoType.addGroupMember:
          return "${infoAtt.targetName} ${VTrans.labelsOf(context).joinedBy} ${infoAtt.adminName}";
        case VMessageInfoType.upAdmin:
          return "${infoAtt.targetName} ${VTrans.labelsOf(context).promotedToAdminBy} ${infoAtt.adminName}";
        case VMessageInfoType.downMember:
          return "${infoAtt.targetName} ${VTrans.labelsOf(context).dismissedToMemberBy} ${infoAtt.adminName}";
        case VMessageInfoType.leave:
          return "${infoAtt.targetName} ${VTrans.labelsOf(context).leftTheGroup}";
        case VMessageInfoType.kick:
          if (infoAtt.isMe) {
            ///todo fix trans
            return "You ${VTrans.labelsOf(context).kickedBy} ${infoAtt.adminName}";
          }
          return "${infoAtt.targetName} ${VTrans.labelsOf(context).kickedBy} ${infoAtt.adminName}";
        case VMessageInfoType.createGroup:
          return "${VTrans.labelsOf(context).groupCreatedBy} ${infoAtt.adminName}";

        case VMessageInfoType.addToBroadcast:
          return "${infoAtt.adminName} ${VTrans.labelsOf(context).addedYouToNewBroadcast} ${infoAtt.targetName}";
      }
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
