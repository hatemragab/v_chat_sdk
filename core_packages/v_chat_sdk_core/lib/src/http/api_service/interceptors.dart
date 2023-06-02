// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class ErrorInterceptor implements ErrorConverter {
  @override
  FutureOr<Response> convertError<BodyType, InnerType>(Response response) {
    final errorMap =
        jsonDecode(response.body.toString()) as Map<String, dynamic>;
    return response.copyWith(
      bodyError: errorMap,
      body: errorMap,
    );
  }
}

void throwIfNotSuccess(Response res) {
  if (res.isSuccessful) return;
  if (res.statusCode == 400) {
    throw VChatHttpBadRequest(
      vChatException: (res.error! as Map<String, dynamic>)['data'].toString(),
    );
  } else if (res.statusCode == 404) {
    throw VChatHttpNotFound(
      vChatException: (res.error! as Map<String, dynamic>)['data'].toString(),
    );
  } else if (res.statusCode == 403) {
    throw VChatHttpForbidden(
      vChatException: (res.error! as Map<String, dynamic>)['data'].toString(),
    );
  } else if (res.statusCode == 450) {
    throw VChatHttpUnAuth(
      vChatException: (res.error! as Map<String, dynamic>)['data'].toString(),
    );
  }
  if (!res.isSuccessful) {
    throw VChatHttpBadRequest(
      vChatException: (res.error! as Map<String, dynamic>)['data'].toString(),
    );
  }
}

Map<String, dynamic> extractDataFromResponse(Response res) {
  return (res.body as Map<String, dynamic>)['data'] as Map<String, dynamic>;
}

class AuthInterceptor implements RequestInterceptor {
  final String? access;

  AuthInterceptor({this.access});

  @override
  FutureOr<Request> onRequest(Request request) {
    final oldHeaders = Map.of(request.headers);
    oldHeaders['authorization'] = "Bearer ${access ?? VAppPref.getHashedString(
          key: VStorageKeys.vAccessToken.name,
        )}";
    oldHeaders["clint-version"] = VAppConstants.clintVersion;
    return request.copyWith(
      headers: oldHeaders,
    );
  }
}
