// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class VBroadcastMember {
  final VIdentifierUser userData;
  final String createdAt;

//<editor-fold desc="Data Methods">
  const VBroadcastMember({
    required this.userData,
    required this.createdAt,
  });

  @override
  String toString() {
    return 'VBroadcastMember{userData: $userData, createdAt: $createdAt}';
  }

  VBroadcastMember copyWith({
    VIdentifierUser? user,
    String? createdAt,
  }) {
    return VBroadcastMember(
      userData: user ?? userData,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userData': userData,
      'createdAt': createdAt,
    };
  }

  factory VBroadcastMember.fromMap(Map<String, dynamic> map) {
    return VBroadcastMember(
      userData:
          VIdentifierUser.fromMap(map['userData'] as Map<String, dynamic>),
      createdAt: map['createdAt'] as String,
    );
  }

//</editor-fold>
}
