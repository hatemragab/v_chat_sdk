// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:chopper/chopper.dart';
import 'package:v_platform/v_platform.dart';

/// Data Transfer Object for registration in VChat system.
class VChatRegisterDto {
  final String identifier; // The unique identifier for the user.
  final String? fullName; // The full name of the user.
  final String deviceId; // The unique device ID of the user's device.
  final String? language; // The preferred language of the user.
  String?
      pushKey; // The push notification key. it can be null. if you not support push notifications it can be the fcm token or onesignal id.
  final String platform; // The platform of the user's device.
  final String password; // The password for the user.
  final VPlatformFile? image; // The profile image for the user.

  /// Creates an instance of VChatRegisterDto.
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

  /// Converts the properties to a list of PartValue.
  /// The PartValue objects represent the individual data parts
  /// to be included in a multipart request.
  List<PartValue> toListOfPartValue() {
    // We create a Map first, then convert it to List<PartValue>.
    // This avoids creating a List with null values if optional parameters are null.
    final map = {
      'identifier': identifier,
      if (fullName != null) 'fullName': fullName,
      'deviceId': deviceId,
      'password': password,
      if (language != null) 'language': language,
      'pushKey': pushKey,
      'platform': platform,
    };

    return map.entries.map((e) => PartValue(e.key, e.value)).toList();
  }
}
