// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/src/utils/api_constants.dart';
import 'package:v_chat_sdk_core/src/utils/enums.dart';

class VMyGroupInfo {
  final bool isMeOut;
  final int membersCount;
  final int totalOnline;
  final VGroupMemberRole myRole;
  final VMyGroupSettings? groupSettings;

//<editor-fold desc="Data Methods">

  const VMyGroupInfo({
    required this.isMeOut,
    required this.membersCount,
    required this.totalOnline,
    required this.myRole,
    required this.groupSettings,
  });

  bool get isMeMember => myRole == VGroupMemberRole.member;

  bool get isMeAdmin => myRole == VGroupMemberRole.admin;

  bool get isMeSuperAdmin => myRole == VGroupMemberRole.superAdmin;

  bool get isMeAdminOrSuperAdmin => isMeAdmin || isMeSuperAdmin;

  VMyGroupInfo.empty()
      : membersCount = 0,
        totalOnline = 0,
        myRole = VGroupMemberRole.member,
        groupSettings = VMyGroupSettings.empty(),
        isMeOut = false;

  @override
  String toString() {
    return 'VMyGroupInfo{isMeOut: $isMeOut, totalOnline:$totalOnline,membersCount: $membersCount, myRole: $myRole, groupSettings: $groupSettings}';
  }

  Map<String, dynamic> toMap() {
    return {
      'isMeOut': isMeOut,
      'membersCount': membersCount,
      'totalOnline': totalOnline,
      'myRole': myRole.name,
      'groupSettings': groupSettings?.toMap(),
    };
  }

  factory VMyGroupInfo.fromMap(Map<String, dynamic> map) {
    return VMyGroupInfo(
      isMeOut: map['isMeOut'] as bool,
      membersCount: map['membersCount'] as int,
      totalOnline: map['totalOnline'] as int,
      groupSettings: (map['groupSettings'] as Map<String, dynamic>?) == null
          ? null
          : VMyGroupSettings.fromMap(
              map['groupSettings'] as Map<String, dynamic>,
            ),
      myRole: VGroupMemberRole.values.byName(map['myRole'] as String),
    );
  }

  VMyGroupInfo copyWith({
    bool? isMeOut,
    int? membersCount,
    int? totalOnline,
    VGroupMemberRole? myRole,
    VMyGroupSettings? groupSettings,
  }) {
    return VMyGroupInfo(
      isMeOut: isMeOut ?? this.isMeOut,
      membersCount: membersCount ?? this.membersCount,
      totalOnline: totalOnline ?? this.totalOnline,
      myRole: myRole ?? this.myRole,
      groupSettings: groupSettings ?? this.groupSettings,
    );
  }
//</editor-fold>
}

class VMyGroupSettings {
  final String creatorId;
  final Map<String, dynamic>? pinMsg;
  final Map<String, dynamic>? extraData;
  final String? desc;
  final String createdAt;

//<editor-fold desc="Data Methods">

  const VMyGroupSettings({
    required this.creatorId,
    this.pinMsg,
    this.extraData,
    this.desc,
    required this.createdAt,
  });

  DateTime get createAtDate => DateTime.parse(createdAt).toLocal();

  bool get isMeCreator => VAppConstants.myId == creatorId;

  VMyGroupSettings.empty()
      : creatorId = "",
        desc = null,
        extraData = null,
        createdAt = DateTime.now().toIso8601String(),
        pinMsg = null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VMyGroupSettings &&
          runtimeType == other.runtimeType &&
          creatorId == other.creatorId &&
          pinMsg == other.pinMsg &&
          desc == other.desc);

  @override
  int get hashCode => creatorId.hashCode ^ pinMsg.hashCode ^ desc.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'cId': creatorId,
      'pinMsg': pinMsg,
      'extraData': extraData,
      'desc': desc,
      'createdAt': createdAt,
    };
  }

  @override
  String toString() {
    return 'VMyGroupSettings{creatorId: $creatorId, pinMsg: $pinMsg, extraData: $extraData, desc: $desc createdAt $createdAt}';
  }

  factory VMyGroupSettings.fromMap(Map<String, dynamic> map) {
    return VMyGroupSettings(
      creatorId: map['cId'] as String,
      pinMsg: map['pinMsg'] as Map<String, dynamic>?,
      extraData: map['extraData'] as Map<String, dynamic>?,
      desc: map['desc'] as String?,
      createdAt: map['createdAt'] as String,
    );
  }

  VMyGroupSettings copyWith({
    String? creatorId,
    Map<String, dynamic>? pinMsg,
    Map<String, dynamic>? extraData,
    String? desc,
    String? createdAt,
  }) {
    return VMyGroupSettings(
      creatorId: creatorId ?? this.creatorId,
      pinMsg: pinMsg ?? this.pinMsg,
      extraData: extraData ?? this.extraData,
      desc: desc ?? this.desc,
      createdAt: createdAt ?? this.createdAt,
    );
  }
//</editor-fold>
}
