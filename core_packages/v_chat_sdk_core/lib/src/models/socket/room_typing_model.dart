// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/src/utils/api_constants.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

/// A model class representing a user's typing status in a specific chat room.
class VSocketRoomTypingModel {
  final VRoomTypingEnum status;
  final String roomId;
  final String userId;
  final String userName;

  /// Checks if the user is the current user.
  bool get isMe => VAppConstants.myId == userId;

  const VSocketRoomTypingModel({
    required this.status,
    required this.roomId,
    this.userName = "",
    this.userId = "",
  });

  /// A predefined status for an offline user.
  static const VSocketRoomTypingModel offline = VSocketRoomTypingModel(
    userName: "offline",
    roomId: "offline",
    status: VRoomTypingEnum.stop,
    userId: "offline",
  );

  /// A predefined status for a user who is typing.
  static const VSocketRoomTypingModel typing = VSocketRoomTypingModel(
    userName: "fake typing",
    roomId: "fake",
    status: VRoomTypingEnum.typing,
    userId: "fake",
  );

  /// A predefined status for a user who is recording.
  static const VSocketRoomTypingModel recoding = VSocketRoomTypingModel(
    userName: "fake recoding",
    roomId: "fake",
    status: VRoomTypingEnum.recording,
    userId: "fake",
  );

  /// Copies this object but with the given fields replaced with the new values.
  VSocketRoomTypingModel copyWith({
    String? roomId,
    String? userId,
    String? name,
    VRoomTypingEnum? status,
  }) {
    return VSocketRoomTypingModel(
      roomId: roomId ?? this.roomId,
      userId: userId ?? this.userId,
      userName: name ?? userName,
      status: status ?? this.status,
    );
  }

  /// Checks if the user is typing.
  bool get isTyping => status == VRoomTypingEnum.typing;

  /// Checks if the user is recording.
  bool get isRecording => status == VRoomTypingEnum.recording;

  /// Checks if the user has stopped typing.
  bool get isStopTyping => status == VRoomTypingEnum.stop;

  /// Returns a string representation of the model.
  @override
  String toString() {
    return 'RoomTyping{status: $status, roomId: $roomId, name: $userName userId:$userId}';
  }

  // /// Returns a string representation of the typing status.
  // String? inSingleText(BuildContext context) {
  //   return _statusInText(context);
  // }
  //
  // /// Converts the typing status to a localized text.
  // String? _statusInText(BuildContext context) {
  //   switch (status) {
  //     case VRoomTypingEnum.stop:
  //       return null;
  //     case VRoomTypingEnum.typing:
  //       return language.typing;
  //     case VRoomTypingEnum.recording:
  //       return language.recording;
  //   }
  // }

  // /// Returns a string representation of the typing status in a group.
  // String? inGroupText(BuildContext context) {
  //   if (_statusInText(context) == null) return null;
  //   return "$name ${_statusInText(context)!}";
  // }

  factory VSocketRoomTypingModel.fromMap(Map<String, dynamic> map) {
    return VSocketRoomTypingModel(
      status: VRoomTypingEnum.values.byName(map['status'] as String),
      userName: map['name'] as String,
      userId: map['userId'] as String,
      roomId: map['roomId'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status.name,
      'roomId': roomId,
    };
  }

//</editor-fold>
}
