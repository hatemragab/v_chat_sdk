// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:ui';

import 'package:v_chat_sdk_core/src/models/v_user/v_base_user.dart';
import 'package:v_platform/v_platform.dart';

abstract class AuthEndPoints {
  Future<VIdentifierUser> connect({
    required String identifier,
    required String fullName,
    VPlatformFile? image,
    required Locale deviceLanguage,
  });

  Future<void> logout();
}
