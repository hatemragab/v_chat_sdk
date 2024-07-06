// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

/// A model class that represents a new call.<br />
class VNewCallModel {
  /// The ID of the room for the call.<br />
  final String roomId;

  /// The ID of the meeting for the call.<br />
  final String meetId;

  /// A boolean that indicates whether the call has video or not.<br />
  final bool withVideo;

  /// An object that represents the peerId user of the call.<br />
  final VBaseUser peerUser;

  /// A map that represents the payload of the call.<br />
  final Map<String, dynamic>? payload;

  /// Creates a new instance of [VNewCallModel].<br />
  const VNewCallModel({
    required this.roomId,
    required this.meetId,
    required this.withVideo,
    required this.peerUser,
    required this.payload,
  });

  /// Converts the [VNewCallModel] object to a map.<br />
  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'meetId': meetId,
      'withVideo': withVideo,
      'payload': payload,
      'userData': peerUser.toMap(),
    };
  }

  /// Creates a new instance of [VNewCallModel] from the given map.<br />
  factory VNewCallModel.fromMap(Map<String, dynamic> map) {
    return VNewCallModel(
      roomId: map['roomId'] as String,
      meetId: map['meetId'] as String,
      withVideo: map['withVideo'] as bool,
      payload: map['payload'] as Map<String, dynamic>?,
      peerUser: VBaseUser.fromMap(
        map['userData'] as Map<String, dynamic>,
      ),
    );
  }
}
