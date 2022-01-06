import 'package:v_chat_sdk/src/enums/v_chat_user_group_role.dart';
import 'package:v_chat_sdk/src/utils/v_chat_config.dart';

class VChatGroupUser {
  final String id;
  final String email;
  final String name;
  final String image;
  final VChatUserGroupRole vChatUserGroupRole;

//<editor-fold desc="Data Methods">

  const VChatGroupUser({
    required this.id,
    required this.email,
    required this.name,
    required this.image,
    required this.vChatUserGroupRole,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VChatGroupUser &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          name == other.name &&
          image == other.image &&
          vChatUserGroupRole == other.vChatUserGroupRole);

  @override
  int get hashCode =>
      email.hashCode ^
      name.hashCode ^
      image.hashCode ^
      vChatUserGroupRole.hashCode;

  @override
  String toString() {
    return 'VChatGroupUser{ id: $id, email: $email, mame: $name, image: $image, vChatUserGroupRole: $vChatUserGroupRole,}';
  }

  VChatGroupUser copyWith({
    String? id,
    String? email,
    String? name,
    String? image,
    VChatUserGroupRole? vChatUserGroupRole,
  }) {
    return VChatGroupUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      image: image ?? this.image,
      vChatUserGroupRole: vChatUserGroupRole ?? this.vChatUserGroupRole,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'email': email,
      'mame': name,
      'image': image,
      'role': vChatUserGroupRole.inString,
    };
  }

  factory VChatGroupUser.fromMap(Map<String, dynamic> map) {
    return VChatGroupUser(
      id: map['_id'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      image: VChatConfig.profileImageBaseUrl + (map['imageThumb'] as String),
      vChatUserGroupRole: map['role'] == VChatUserGroupRole.admin.inString
          ? VChatUserGroupRole.admin
          : VChatUserGroupRole.member,
    );
  }

//</editor-fold>
}
