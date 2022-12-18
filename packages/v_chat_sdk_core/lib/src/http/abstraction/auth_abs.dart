import 'dart:ui';

import 'package:v_chat_utils/v_chat_utils.dart';

import '../../models/v_user/v_base_user.dart';

abstract class AuthEndPoints {
  Future<VIdentifierUser> login({
    required String identifier,
    required Locale deviceLanguage,
  });

  Future<VIdentifierUser> register({
    required String identifier,
    required String fullName,
    PlatformFileSource? image,
    required Locale deviceLanguage,
  });

  Future<void> logout();
}
