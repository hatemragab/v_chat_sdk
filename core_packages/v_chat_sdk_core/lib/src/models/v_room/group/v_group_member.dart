// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class VGroupMember {
  final VIdentifierUser userData;
  final VGroupMemberRole role;

//<editor-fold desc="Data Methods">
  const VGroupMember({
    required this.userData,
    required this.role,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VGroupMember &&
          runtimeType == other.runtimeType &&
          userData == other.userData &&
          role == other.role);

  @override
  int get hashCode => userData.hashCode ^ role.hashCode;

  @override
  String toString() {
    return 'VGroupMember{userData: $userData, role: $role}';
  }

  VGroupMember copyWith({
    VIdentifierUser? user,
    VGroupMemberRole? role,
  }) {
    return VGroupMember(
      userData: user ?? userData,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userData': userData,
      'gR': role.name,
    };
  }

  factory VGroupMember.fromMap(Map<String, dynamic> map) {
    return VGroupMember(
      userData:
          VIdentifierUser.fromMap(map['userData'] as Map<String, dynamic>),
      role: VGroupMemberRole.values.byName(map['gR'] as String),
    );
  }

//</editor-fold>
}
