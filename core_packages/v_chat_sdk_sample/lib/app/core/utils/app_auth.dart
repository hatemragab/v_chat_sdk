// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_sdk_sample/app/core/models/user.model.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

abstract class AppAuth {
  static UserModel get getMyModel {
    return UserModel.fromMap(VAppPref.getMap(VStorageKeys.vMyProfile.name)!);
  }
}
