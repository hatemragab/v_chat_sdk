import 'package:path/path.dart';
import 'package:v_chat_sdk/src/enums/enums.dart';
import 'package:v_chat_sdk/src/utils/v_chat_config.dart';

class VChatGroupChatInfo {
  final String title;
  final String imageThumb;
  final int totalGroupMembers;
  final VChatUserGroupRole role;
  final bool isGroupCreator;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const VChatGroupChatInfo({
    required this.title,
    required this.imageThumb,
    required this.role,
    required this.isGroupCreator,
    required this.totalGroupMembers,
  });

  bool get isAdmin => role == VChatUserGroupRole.admin;

  @override
  String toString() {
    return 'VChatGroupChatInfo{title: $title, imageThumb: $imageThumb, totalGroupMembers: $totalGroupMembers, role: $role, isGroupCreator: $isGroupCreator}';
  }

  factory VChatGroupChatInfo.fromMap(Map<String, dynamic> map) {
    return VChatGroupChatInfo(
      title: map['name'] as String,
      totalGroupMembers: map['roomMembersCount'] as int,
      role: map['role'] == VChatUserGroupRole.admin.inString
          ? VChatUserGroupRole.admin
          : VChatUserGroupRole.member,
      isGroupCreator: map['isGroupCreator'] as bool,
      imageThumb:
          VChatConfig.profileImageBaseUrl + (map['imageThumb'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'name': title,
      'roomMembersCount': totalGroupMembers,
      'imageThumb': basename(imageThumb),
      'isGroupCreator': isGroupCreator,
      'role': role.inString,
    } as Map<String, dynamic>;
  }

  VChatGroupChatInfo copyWith({
    String? title,
    String? imageThumb,
    int? totalGroupMembers,
    VChatUserGroupRole? role,
    bool? isGroupCreator,
  }) {
    return VChatGroupChatInfo(
      title: title ?? this.title,
      imageThumb: imageThumb ?? this.imageThumb,
      totalGroupMembers: totalGroupMembers ?? this.totalGroupMembers,
      role: role ?? this.role,
      isGroupCreator: isGroupCreator ?? this.isGroupCreator,
    );
  }
//</editor-fold>

}
