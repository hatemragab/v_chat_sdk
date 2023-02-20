// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:chopper/chopper.dart';
import 'package:v_chat_sdk_core/src/http/api_service/interceptors.dart';
import 'package:v_chat_sdk_core/src/utils/api_constants.dart';

part 'call_api.chopper.dart';

@ChopperApi(baseUrl: 'call')
abstract class CallApi extends ChopperService {
  @Get(path: "/active", optionalBody: true)
  Future<Response> getActiveCall();

  @Get(path: "/history", optionalBody: true)
  Future<Response> getCallHistory();

  @Post(path: "/create/{roomId}")
  Future<Response> createCall(
    @Path() String roomId,
    @Body() Map<String, dynamic> body,
  );

  @Post(path: "/accept/{meetId}", optionalBody: true)
  Future<Response> acceptCall(
    @Path() String meetId,
    @Body() Map<String, dynamic> body,
  );

  @Post(path: "/cancel/{meetId}", optionalBody: true)
  Future<Response> cancelCall(
    @Path() String meetId,
  );

  @Post(path: "/reject/{meetId}", optionalBody: true)
  Future<Response> rejectCall(
    @Path() String meetId,
  );

  @Post(path: "/end/{meetId}", optionalBody: true)
  Future<Response> endCall(
    @Path() String meetId,
  );

  static CallApi create({
    Uri? baseUrl,
    String? accessToken,
  }) {
    final client = ChopperClient(
      baseUrl: VAppConstants.baseUri,
      services: [
        _$CallApi(),
      ],
      converter: const JsonConverter(),
      interceptors: [AuthInterceptor()],
      errorConverter: ErrorInterceptor(),
    );
    return _$CallApi(client);
  }
}
