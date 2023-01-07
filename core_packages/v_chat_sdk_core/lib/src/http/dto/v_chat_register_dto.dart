import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class VChatRegisterDto {
  final String identifier;
  final String fullName;
  final String deviceId;
  final String language;
  String? pushKey;
  final String platform;
  final String password;
  final Map<String, dynamic> deviceInfo;
  final VPlatformFileSource? image;

//<editor-fold desc="Data Methods">

  VChatRegisterDto({
    required this.identifier,
    required this.fullName,
    required this.deviceId,
    required this.language,
    this.pushKey,
    required this.platform,
    required this.password,
    required this.deviceInfo,
    this.image,
  });

  List<PartValue> toListOfPartValue() {
    return [
      PartValue('identifier', identifier),
      PartValue('fullName', fullName),
      PartValue('deviceId', deviceId),
      PartValue('password', password),
      PartValue('deviceInfo', jsonEncode(deviceInfo)),
      PartValue('language', language),
      PartValue('pushKey', pushKey),
      PartValue('platform', platform),
    ];
  }

//</editor-fold>
}