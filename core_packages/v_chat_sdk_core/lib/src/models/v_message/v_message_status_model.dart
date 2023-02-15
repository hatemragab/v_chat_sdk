// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/src/models/models.dart';

class VMessageStatusModel {
  final String deliveredAt;
  final String? seenAt;
  final VIdentifierUser identifierUser;

//<editor-fold desc="Data Methods">
  const VMessageStatusModel({
    required this.deliveredAt,
    this.seenAt,
    required this.identifierUser,
  });

  DateTime get delivered => DateTime.parse(deliveredAt).toLocal();
  DateTime? get seen =>
      seenAt == null ? null : DateTime.parse(seenAt!).toLocal();
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VMessageStatusModel &&
          runtimeType == other.runtimeType &&
          deliveredAt == other.deliveredAt &&
          seenAt == other.seenAt &&
          identifierUser == other.identifierUser);

  @override
  int get hashCode =>
      deliveredAt.hashCode ^ seenAt.hashCode ^ identifierUser.hashCode;

  @override
  String toString() {
    return 'VMessageStatusModel{deliveredAt: $deliveredAt, seenAt: $seenAt,  identifierUser: $identifierUser}';
  }

  VMessageStatusModel copyWith({
    String? dAt,
    String? sAt,
    VIdentifierUser? identifierUser,
  }) {
    return VMessageStatusModel(
      deliveredAt: dAt ?? deliveredAt,
      seenAt: sAt ?? seenAt,
      identifierUser: identifierUser ?? this.identifierUser,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dAt': deliveredAt,
      'sAt': seenAt,
      'userData': identifierUser.toMap(),
    };
  }

  factory VMessageStatusModel.fromMap(Map<String, dynamic> map) {
    return VMessageStatusModel(
      deliveredAt: map['dAt'] as String,
      seenAt: map['sAt'] as String?,
      identifierUser:
          VIdentifierUser.fromMap(map['userData'] as Map<String, dynamic>),
    );
  }

//</editor-fold>
}
