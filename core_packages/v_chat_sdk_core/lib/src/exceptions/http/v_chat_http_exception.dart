// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_utils/v_chat_utils.dart';

abstract class VChatBaseHttpException extends VChatBaseException {
  final int statusCode;

  VChatBaseHttpException({
    required this.statusCode,
    required super.exception,
  });
}

class VChatHttpBadRequest extends VChatBaseHttpException {
  final String vChatException;

  VChatHttpBadRequest({
    required this.vChatException,
  }) : super(
          statusCode: 400,
          exception: vChatException,
        );
}

class VChatHttpForbidden extends VChatBaseHttpException {
  final Object vChatException;

  VChatHttpForbidden({
    required this.vChatException,
  }) : super(
          statusCode: 403,
          exception: vChatException,
        );
}

class VChatHttpUnAuth extends VChatBaseHttpException {
  final Object vChatException;

  VChatHttpUnAuth({
    required this.vChatException,
  }) : super(
          statusCode: 450,
          exception: vChatException,
        );
}

class VChatHttpNotFound extends VChatBaseHttpException {
  final Object vChatException;

  VChatHttpNotFound({
    required this.vChatException,
  }) : super(
          statusCode: 404,
          exception: vChatException,
        );
}
