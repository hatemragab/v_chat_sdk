// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/src/models/v_chat_base_exception.dart';

// Abstract base class for all HTTP exceptions in the VChat system.
abstract class VChatBaseHttpException extends VChatBaseException {
  final int statusCode; // HTTP status code associated with the exception.

  VChatBaseHttpException({
    required this.statusCode,
    required super.exception,
  });
}

// Exception representing a 400 Bad Request HTTP response.
class VChatHttpBadRequest extends VChatBaseHttpException {
  final String vChatException; // Detailed exception message.

  VChatHttpBadRequest({
    required this.vChatException,
  }) : super(
          statusCode: 400,
          exception: vChatException,
        );
}

// Exception representing a 403 Forbidden HTTP response.
class VChatHttpForbidden extends VChatBaseHttpException {
  final Object vChatException; // Detailed exception message.

  VChatHttpForbidden({
    required this.vChatException,
  }) : super(
          statusCode: 403,
          exception: vChatException,
        );
}

// Exception representing a 450 Unauthenticated HTTP response.
class VChatHttpUnAuth extends VChatBaseHttpException {
  final Object vChatException; // Detailed exception message.

  VChatHttpUnAuth({
    required this.vChatException,
  }) : super(
          statusCode: 450,
          exception: vChatException,
        );
}

// Exception representing a 404 Not Found HTTP response.
class VChatHttpNotFound extends VChatBaseHttpException {
  final Object vChatException; // Detailed exception message.

  VChatHttpNotFound({
    required this.vChatException,
  }) : super(
          statusCode: 404,
          exception: vChatException,
        );
}
