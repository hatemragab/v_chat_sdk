// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/src/utils/api_constants.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class VMsgInfoAtt {
  /// [updateTitle,updateImage,addGroupMember,   upAdmin,   downMember,   leave,   kick,   createGroup,   addToBroadcast]
  /// it can be one from this list
  final VMessageInfoType action;

  /// the target name it can be the action name or the target name
  final String targetName;

  /// the target id it can be the room id or the user id
  final String targetId;

  /// the admin name if the action is from group admin
  final String adminName;

//<editor-fold desc="Data Methods">

  VMsgInfoAtt({
    required this.action,
    required this.targetName,
    required this.targetId,
    required this.adminName,
  });

  @override
  String toString() {
    return 'MsgInfoAtt{ action: $action, targetName: $targetName, adminName: $adminName,}';
  }

  bool get isMe => VAppConstants.myId == targetId;

  bool get isDark {
    if (action == VMessageInfoType.kick) {
      return true;
    }
    return false;
  }

  Map<String, dynamic> toMap() {
    return {
      'action': action.name,
      'targetName': targetName,
      'adminName': adminName,
      'targetId': targetId,
    };
  }

  factory VMsgInfoAtt.fromMap(Map<String, dynamic> map) {
    return VMsgInfoAtt(
      action: VMessageInfoType.values.byName(map['action'] as String),
      targetName: map['targetName'] as String,
      adminName: map['adminName'] as String,
      targetId: map['targetId'] as String,
    );
  }

//</editor-fold>
}
