import 'package:v_chat_sdk_core/src/models/models.dart';
import 'package:v_chat_sdk_core/src/models/v_message/core/message_factory.dart';
import 'package:v_chat_sdk_core/src/utils/enums.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class GroupInfo {
  bool isMeOut;
  int membersCount;
  final GroupMemberRole myRole;
  final GroupSettings groupSettings;

//<editor-fold desc="Data Methods">

  GroupInfo({
    required this.isMeOut,
    required this.membersCount,
    required this.myRole,
    required this.groupSettings,
  });

  GroupInfo.empty()
      : membersCount = 0,
        myRole = GroupMemberRole.member,
        groupSettings = GroupSettings.empty(),
        isMeOut = false;

  @override
  String toString() {
    return 'MyGroupInfo{ isMeOut: $isMeOut, membersCount: $membersCount,}';
  }

  Map<String, dynamic> toMap() {
    return {
      'isMeOut': isMeOut,
      'membersCount': membersCount,
      'myRole': myRole.name,
      'groupSettings': groupSettings.toMap(),
    };
  }

  factory GroupInfo.fromMap(Map<String, dynamic> map) {
    return GroupInfo(
      isMeOut: map['isMeOut'] as bool,
      membersCount: map['membersCount'] as int,
      groupSettings: GroupSettings.fromMap(
        map['groupSettings'] as Map<String, dynamic>,
      ),
      myRole: GroupMemberRole.values.byName(map['myRole'] as String),
    );
  }

//</editor-fold>
}

class GroupSettings {
  final String gName;
  final String cId;
  final VFullUrlModel gImg;
  final VBaseMessage? pinMsg;
  final String? desc;

//<editor-fold desc="Data Methods">

  const GroupSettings({
    required this.gName,
    required this.cId,
    required this.gImg,
    this.pinMsg,
    this.desc,
  });

  GroupSettings.empty()
      : gName = "",
        cId = "",
        gImg = VFullUrlModel.fromFakeUrl(),
        desc = null,
        pinMsg = null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupSettings &&
          runtimeType == other.runtimeType &&
          gName == other.gName &&
          cId == other.cId &&
          gImg == other.gImg &&
          pinMsg == other.pinMsg &&
          desc == other.desc);

  @override
  int get hashCode =>
      gName.hashCode ^
      cId.hashCode ^
      gImg.hashCode ^
      pinMsg.hashCode ^
      desc.hashCode;

  @override
  String toString() {
    return 'GroupSettings{' +
        ' gName: $gName,' +
        ' cId: $cId,' +
        ' gImg: $gImg,' +
        ' pinMsg: $pinMsg,' +
        ' desc: $desc,' +
        '}';
  }

  GroupSettings copyWith({
    String? gName,
    String? cId,
    VFullUrlModel? gImg,
    VBaseMessage? pinMsg,
    String? desc,
  }) {
    return GroupSettings(
      gName: gName ?? this.gName,
      cId: cId ?? this.cId,
      gImg: gImg ?? this.gImg,
      pinMsg: pinMsg ?? this.pinMsg,
      desc: desc ?? this.desc,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'gName': gName,
      'cId': cId,
      'gImg': gImg.originalUrl,
      'pinMsg': pinMsg == null ? null : pinMsg!.toRemoteMap(),
      'desc': desc,
    };
  }

  factory GroupSettings.fromMap(Map<String, dynamic> map) {
    return GroupSettings(
      gName: map['gName'] as String,
      cId: map['cId'] as String,
      gImg: VFullUrlModel(map['gImg']),
      pinMsg: map['pinMsg'] == null
          ? null
          : MessageFactory.createBaseMessage(
              map['pinMsg'] as Map<String, dynamic>),
      desc: map['desc'] as String?,
    );
  }

//</editor-fold>
}
