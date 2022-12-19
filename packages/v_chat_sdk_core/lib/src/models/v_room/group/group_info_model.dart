import 'package:v_chat_sdk_core/src/models/v_room/group/room_data_member_model.dart';

import '../../../../v_chat_sdk_core.dart';

class VGroupInfoModel {
  VRoomDataMemberModel roomDataMemberModel;
  GroupMemberRole myRole;
  String? groupDescription;
  int memberCount;

//<editor-fold desc="Data Methods">

  VGroupInfoModel({
    required this.roomDataMemberModel,
    required this.myRole,
    required this.memberCount,
    this.groupDescription,
  });

  @override
  String toString() {
    return 'GroupSettingModel{ roomDataMemberModel: $roomDataMemberModel, groupMemberRole: $myRole, memberCount: $memberCount,}';
  }

  bool get isMeAdmin => myRole == GroupMemberRole.admin;

  bool get isMeAdminOrSuperAdmin => isMeAdmin || isMeSuperAdmin;

  bool get isMeSuperAdmin => myRole == GroupMemberRole.superAdmin;

  bool get isMember => myRole == GroupMemberRole.member;

  Map<String, dynamic> toMap() {
    return {
      'roomData': roomDataMemberModel.toMap(),
      'groupMember': {"gR": myRole.name},
      'groupSettings': {"desc": groupDescription},
      'memberCount': memberCount,
    };
  }

  factory VGroupInfoModel.fromMap(Map<String, dynamic> map) {
    return VGroupInfoModel(
      roomDataMemberModel: VRoomDataMemberModel.fromMap(
        map['roomData'] as Map<String, dynamic>,
      ),
      myRole: GroupMemberRole.values.byName(
        (map['groupMember'] as Map<String, dynamic>)['gR'] as String,
      ),
      memberCount: map['memberCount'] as int,
      groupDescription:
          (map['groupSettings'] as Map<String, dynamic>)['desc'] as String?,
    );
  }
//</editor-fold>
}
