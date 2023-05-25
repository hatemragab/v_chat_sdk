// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:v_platform/v_platform.dart';

class CreateBroadcastDto {
  final List<String> identifiers;
  final String title;
  final VPlatformFile? platformImage;

//<editor-fold desc="Data Methods">

  const CreateBroadcastDto({
    required this.identifiers,
    required this.title,
    required this.platformImage,
  });

  List<PartValue> toListOfPartValue() {
    return [
      PartValue('identifiers', jsonEncode(identifiers)),
      PartValue(
        "broadcastName",
        title,
      ),
    ];
  }

//</editor-fold>
}
