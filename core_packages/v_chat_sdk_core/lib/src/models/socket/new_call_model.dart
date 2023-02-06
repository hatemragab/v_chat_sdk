import 'dart:convert';

import 'package:v_chat_sdk_core/src/models/models.dart';

class VNewCallModel {
  final String roomId;
  final String meetId;
  final bool withVideo;
  final VIdentifierUser identifierUser;
  final Map<String, dynamic> payload;

  const VNewCallModel({
    required this.roomId,
    required this.meetId,
    required this.withVideo,
    required this.identifierUser,
    required this.payload,
  });

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'meetId': meetId,
      'withVideo': withVideo,
      'payload': payload,
      'userData': identifierUser.toMap(),
    };
  }

  factory VNewCallModel.fromMap(Map<String, dynamic> map) {
    return VNewCallModel(
      roomId: map['roomId'] as String,
      meetId: map['meetId'] as String,
      withVideo: map['withVideo'] as bool,
      payload:jsonDecode(map['payload'] as String)  as Map<String, dynamic>,
      identifierUser: VIdentifierUser.fromMap(
        map['userData'] as Map<String, dynamic>,
      ),
    );
  }
}
