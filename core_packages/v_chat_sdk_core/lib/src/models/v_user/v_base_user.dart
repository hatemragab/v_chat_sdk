// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/src/utils/api_constants.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class VBaseUser {
  final String vChatId;
  final String fullName;
  final VUserImage userImages;

//<editor-fold desc="Data Methods">

  const VBaseUser({
    required this.vChatId,
    required this.fullName,
    required this.userImages,
  });

  bool get isMe => VAppConstants.myId == vChatId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VBaseUser && vChatId == other.vChatId);

  @override
  int get hashCode => vChatId.hashCode;

  @override
  String toString() {
    return 'VBaseUser{ vChatId: $vChatId, fullName: $fullName, userImages: $userImages,}';
  }

  VBaseUser copyWith({
    String? vChatId,
    String? fullName,
    VUserImage? userImages,
  }) {
    return VBaseUser(
      vChatId: vChatId ?? this.vChatId,
      fullName: fullName ?? this.fullName,
      userImages: userImages ?? this.userImages,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': vChatId,
      'fullName': fullName,
      'userImages': userImages.toMap(),
    };
  }

  factory VBaseUser.fromMap(Map<String, dynamic> map) {
    return VBaseUser(
      vChatId: map['_id'] as String,
      fullName: map['fullName'] as String,
      userImages: VUserImage.fromMap(map['userImages'] as Map<String, dynamic>),
    );
  }

  factory VBaseUser.fromFakeData() {
    return VBaseUser(
      vChatId: "fake vChatId",
      fullName: "fake FullName",
      userImages: VUserImage.fromFakeSingleUrl(),
    );
  }

//</editor-fold>
}

class VIdentifierUser {
  final String identifier;
  final VBaseUser baseUser;

//<editor-fold desc="Data Methods">

  const VIdentifierUser({
    required this.identifier,
    required this.baseUser,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VIdentifierUser &&
          runtimeType == other.runtimeType &&
          identifier == other.identifier &&
          baseUser == other.baseUser);

  @override
  int get hashCode => identifier.hashCode ^ baseUser.hashCode;

  bool get isMe => baseUser.isMe;

  @override
  String toString() {
    return 'VIdentifierUser{ identifier: $identifier, baseUser: $baseUser,}';
  }

  VIdentifierUser copyWith({
    String? identifier,
    VBaseUser? baseUser,
  }) {
    return VIdentifierUser(
      identifier: identifier ?? this.identifier,
      baseUser: baseUser ?? this.baseUser,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'identifier': identifier,
      ...baseUser.toMap(),
    };
  }

  factory VIdentifierUser.fromMap(Map<String, dynamic> map) {
    return VIdentifierUser(
      identifier: map['identifier'] as String,
      baseUser: VBaseUser.fromMap(map),
    );
  }

//</editor-fold>
}
