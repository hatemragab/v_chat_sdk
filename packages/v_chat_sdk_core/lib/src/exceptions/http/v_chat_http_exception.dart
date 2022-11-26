import 'package:v_chat_sdk_core/src/exceptions/http/v_chat_http_models.dart';

import '../v_chat_base_exception.dart';

abstract class VChatBaseHttpException extends VChatBaseException {
  final int statusCode;
  final VChatHttpRequest request;
  final VChatHttpResponse response;

  VChatBaseHttpException({
    required this.statusCode,
    required this.request,
    required this.response,
    required super.exception,
  });
}

class VChatHttpBadRequest extends VChatBaseHttpException {
  final VChatHttpRequest vChatRequest;

  final VChatHttpResponse vChatResponse;

  final Object vChatException;

  VChatHttpBadRequest({
    required this.vChatRequest,
    required this.vChatResponse,
    required this.vChatException,
  }) : super(
          statusCode: 400,
          exception: vChatException,
          request: vChatRequest,
          response: vChatResponse,
        );
}

class VChatHttpForbidden extends VChatBaseHttpException {
  final VChatHttpRequest vChatRequest;

  final VChatHttpResponse vChatResponse;

  final Object vChatException;

  VChatHttpForbidden({
    required this.vChatRequest,
    required this.vChatResponse,
    required this.vChatException,
  }) : super(
          statusCode: 403,
          exception: vChatException,
          request: vChatRequest,
          response: vChatResponse,
        );
}

class VChatHttpNotFound extends VChatBaseHttpException {
  final VChatHttpRequest vChatRequest;

  final VChatHttpResponse vChatResponse;

  final Object vChatException;

  VChatHttpNotFound({
    required this.vChatRequest,
    required this.vChatResponse,
    required this.vChatException,
  }) : super(
          statusCode: 404,
          exception: vChatException,
          request: vChatRequest,
          response: vChatResponse,
        );
}
