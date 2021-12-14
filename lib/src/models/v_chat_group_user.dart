import 'package:v_chat_sdk/src/enums/v_chat_user_group_role.dart';
import 'package:v_chat_sdk/src/utils/api_utils/server_config.dart';

class VChatGroupUser {
  final String id;
  final String email;
  final String mame;
  final String image;
  final VChatUserGroupRole vChatUserGroupRole;

//<editor-fold desc="Data Methods">

  const VChatGroupUser({
    required this.id,
    required this.email,
    required this.mame,
    required this.image,
    required this.vChatUserGroupRole,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VChatGroupUser &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          mame == other.mame &&
          image == other.image &&
          vChatUserGroupRole == other.vChatUserGroupRole);

  @override
  int get hashCode =>
      email.hashCode ^
      mame.hashCode ^
      image.hashCode ^
      vChatUserGroupRole.hashCode;

  @override
  String toString() {
    return 'VChatGroupUser{' +
        ' id: $id,' +
        ' email: $email,' +
        ' mame: $mame,' +
        ' image: $image,' +
        ' vChatUserGroupRole: $vChatUserGroupRole,' +
        '}';
  }

  VChatGroupUser copyWith({
    String? id,
    String? email,
    String? mame,
    String? image,
    VChatUserGroupRole? vChatUserGroupRole,
  }) {
    return VChatGroupUser(
      id: id ?? this.id,
      email: email ?? this.email,
      mame: mame ?? this.mame,
      image: image ?? this.image,
      vChatUserGroupRole: vChatUserGroupRole ?? this.vChatUserGroupRole,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'email': email,
      'mame': mame,
      'image': image,
      'role': vChatUserGroupRole.inString,
    };
  }

  factory VChatGroupUser.fromMap(Map<String, dynamic> map) {
    return VChatGroupUser(
      id: map['_id'] as String,
      email: map['email'] as String,
      mame: map['name'] as String,
      image: ServerConfig.profileImageBaseUrl + (map['imageThumb'] as String),
      vChatUserGroupRole: map['role'] == VChatUserGroupRole.admin.inString
          ? VChatUserGroupRole.admin
          : VChatUserGroupRole.member,
    );
  }

//</editor-fold>
}
