// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class CreateGroupDto {
  final List<String> identifiers;
  final String title;
  final VPlatformFileSource? platformImage;

//<editor-fold desc="Data Methods">

  const CreateGroupDto({
    required this.identifiers,
    required this.title,
    required this.platformImage,
  });

  List<PartValue> toListOfPartValue() {
    return [
      PartValue('identifiers', jsonEncode(identifiers)),
      PartValue(
        "groupName",
        title,
      ),
    ];
  }

//</editor-fold>
}
