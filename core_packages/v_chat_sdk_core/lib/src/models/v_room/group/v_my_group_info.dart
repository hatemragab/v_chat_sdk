import 'package:v_chat_sdk_core/src/models/models.dart';
import 'package:v_chat_sdk_core/src/utils/enums.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class VMyGroupInfo {
  final bool isMeOut;
  final int membersCount;
  final GroupMemberRole myRole;
  final VMyGroupSettings? groupSettings;

//<editor-fold desc="Data Methods">

  const VMyGroupInfo({
    required this.isMeOut,
    required this.membersCount,
    required this.myRole,
    required this.groupSettings,
  });

  VMyGroupInfo.empty()
      : membersCount = 0,
        myRole = GroupMemberRole.member,
        groupSettings = VMyGroupSettings.empty(),
        isMeOut = false;


  @override
  String toString() {
    return 'VMyGroupInfo{isMeOut: $isMeOut, membersCount: $membersCount, myRole: $myRole, groupSettings: $groupSettings}';
  }

  Map<String, dynamic> toMap() {
    return {
      'isMeOut': isMeOut,
      'membersCount': membersCount,
      'myRole': myRole.name,
      'groupSettings': groupSettings?.toMap(),
    };
  }

  factory VMyGroupInfo.fromMap(Map<String, dynamic> map) {
    return VMyGroupInfo(
      isMeOut: map['isMeOut'] as bool,
      membersCount: map['membersCount'] as int,
      groupSettings: (map['groupSettings'] as Map<String, dynamic>?) == null
          ? null
          : VMyGroupSettings.fromMap(
              map['groupSettings'] as Map<String, dynamic>,
            ),
      myRole: GroupMemberRole.values.byName(map['myRole'] as String),
    );
  }

//</editor-fold>
}

class VMyGroupSettings {
  final String creatorId;
  final Map<String, dynamic>? pinMsg;
  final Map<String, dynamic>? extraData;
  final String? desc;

//<editor-fold desc="Data Methods">

  const VMyGroupSettings({
    required this.creatorId,
    this.pinMsg,
    this.extraData,
    this.desc,
  });

  VMyGroupSettings.empty()
      : creatorId = "",
        desc = null,
        extraData = null,
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
    };
  }

  @override
  String toString() {
    return 'VMyGroupSettings{creatorId: $creatorId, pinMsg: $pinMsg, extraData: $extraData, desc: $desc}';
  }

  factory VMyGroupSettings.fromMap(Map<String, dynamic> map) {
    return VMyGroupSettings(
      creatorId: map['cId'] as String,
      pinMsg: map['pinMsg'] as Map<String, dynamic>?,
      extraData: map['extraData'] as Map<String, dynamic>?,
      desc: map['desc'] as String?,
    );
  }

//</editor-fold>
}
