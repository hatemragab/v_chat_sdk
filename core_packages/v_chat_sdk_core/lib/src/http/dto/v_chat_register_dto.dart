// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:chopper/chopper.dart';
import 'package:v_platform/v_platform.dart';

class VChatRegisterDto {
  final String identifier;
  final String? fullName;
  final String? deviceId;
  final String? language;
  String? pushKey;
  final String platform;
  final String password;
  final VPlatformFile? image;

//<editor-fold desc="Data Methods">

  VChatRegisterDto({
    required this.identifier,
    required this.fullName,
    required this.deviceId,
    this.language,
    this.pushKey,
    required this.platform,
    required this.password,
    this.image,
  });

  List<PartValue> toListOfPartValue() {
    return [
      PartValue('identifier', identifier),
      if (fullName != null) PartValue('fullName', fullName),
      PartValue('deviceId', deviceId),
      PartValue('password', password),
      if (language != null) PartValue('language', language),
      PartValue('pushKey', pushKey),
      PartValue('platform', platform),
    ];
  }

//</editor-fold>
}
