// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:http/http.dart' hide Response, Request;
import 'package:http/io_client.dart';
import 'package:v_chat_sdk_core/src/http/api_service/interceptors.dart';
import 'package:v_chat_sdk_core/src/utils/api_constants.dart';
import 'package:v_platform/v_platform.dart';

part 'auth_api.chopper.dart';

@ChopperApi(baseUrl: 'auth')
abstract class AuthApi extends ChopperService {
  @Post(path: "/connect")
  @multipart
  Future<Response> connect(
    @PartMap() List<PartValue> body,
    @PartFile("file") MultipartFile? file,
  );

  @Post(path: "/logout", optionalBody: true)
  Future<Response> logout();

  static AuthApi create({
    Uri? baseUrl,
    String? accessToken,
  }) {
    final client = ChopperClient(
      baseUrl: VAppConstants.baseUri,
      services: [
        _$AuthApi(),
      ],
      converter: const JsonConverter(),
      interceptors: [AuthInterceptor()],
      errorConverter: ErrorInterceptor(),
      client: VPlatforms.isWeb
          ? null
          : IOClient(
              HttpClient()..connectionTimeout = const Duration(seconds: 15),
            ),
    );
    return _$AuthApi(client);
  }
}
