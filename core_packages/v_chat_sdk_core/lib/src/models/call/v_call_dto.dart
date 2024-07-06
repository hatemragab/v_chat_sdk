// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

/// Represents a Data Transfer Object (DTO) for a caller in the VChat application.
class VCallDto {
  final bool isVideoEnable;
  final String roomId;
  final String? meetId;
  final VBaseUser peerUser;
  final bool isCaller;

  /// Create a new [VCallDto].
  ///
  /// - [isVideoEnable]: A boolean indicating if the video is enabled for the call.
  /// - [roomId]: The unique peerId of the room where the call is taking place.
  /// - [peerName]: The name of the peer user in the call.
  /// - [peerImage]: The display picture of the peer user.
  const VCallDto({
    required this.isVideoEnable,
    required this.roomId,
    this.meetId,
    required this.peerUser,
    required this.isCaller,
  });

  // int get getAgoraUserId {
  //   final concatenatedNumber =
  //       int.parse(peerUser.id.replaceAll(RegExp(r'\D'), ''), radix: 10);
  //   return concatenatedNumber;
  // }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VCallDto &&
          runtimeType == other.runtimeType &&
          peerUser == other.peerUser;

  @override
  int get hashCode => peerUser.hashCode;
}
