import 'package:v_chat_sdk_core/src/models/models.dart';

class VMessageStatusModel {
  final String? deliveredAt;
  final String? seenAt;
  final String sendAt;
  final VIdentifierUser identifierUser;

//<editor-fold desc="Data Methods">
  const VMessageStatusModel({
    this.deliveredAt,
    this.seenAt,
    required this.sendAt,
    required this.identifierUser,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VMessageStatusModel &&
          runtimeType == other.runtimeType &&
          deliveredAt == other.deliveredAt &&
          seenAt == other.seenAt &&
          sendAt == other.sendAt &&
          identifierUser == other.identifierUser);

  @override
  int get hashCode =>
      deliveredAt.hashCode ^ seenAt.hashCode ^ sendAt.hashCode ^ identifierUser.hashCode;


  @override
  String toString() {
    return 'VMessageStatusModel{deliveredAt: $deliveredAt, seenAt: $seenAt, sendAt: $sendAt, identifierUser: $identifierUser}';
  }

  VMessageStatusModel copyWith({
    String? dAt,
    String? sAt,
    String? cAt,
    VIdentifierUser? identifierUser,
  }) {
    return VMessageStatusModel(
      deliveredAt: dAt ?? deliveredAt,
      seenAt: sAt ?? seenAt,
      sendAt: cAt ?? sendAt,
      identifierUser: identifierUser ?? this.identifierUser,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dAt': deliveredAt,
      'sAt': seenAt,
      'cAt': sendAt,
      'user': identifierUser.toMap(),
    };
  }

  factory VMessageStatusModel.fromMap(Map<String, dynamic> map) {
    return VMessageStatusModel(
      deliveredAt: map['dAt'] as String?,
      seenAt: map['sAt'] as String?,
      sendAt: map['cAt'] as String,
      identifierUser:
          VIdentifierUser.fromMap(map['user'] as Map<String, dynamic>),
    );
  }

//</editor-fold>
}
