import 'package:chopper/chopper.dart';

import '../v_chat_base_exception.dart';

abstract class VChatBaseHttpException extends VChatBaseException {
  final int statusCode;
  final Response chopperRes;

  VChatBaseHttpException({
    required this.statusCode,
    required this.chopperRes,
    required super.exception,
  });
}

class VChatHttpBadRequest extends VChatBaseHttpException {
  final Response vChatChopperRes;

  final String vChatException;

  VChatHttpBadRequest({
    required this.vChatChopperRes,
    required this.vChatException,
  }) : super(
          statusCode: 400,
          exception: vChatException,
          chopperRes: vChatChopperRes,
        );
}

class VChatHttpForbidden extends VChatBaseHttpException {
  final Response vChatChopperRes;

  final Object vChatException;

  VChatHttpForbidden({
    required this.vChatChopperRes,
    required this.vChatException,
  }) : super(
          statusCode: 403,
          exception: vChatException,
          chopperRes: vChatChopperRes,
        );
}

class VChatHttpNotFound extends VChatBaseHttpException {
  final Response vChatChopperRes;

  final Object vChatException;

  VChatHttpNotFound({
    required this.vChatChopperRes,
    required this.vChatException,
  }) : super(
          statusCode: 404,
          exception: vChatException,
          chopperRes: vChatChopperRes,
        );
}
