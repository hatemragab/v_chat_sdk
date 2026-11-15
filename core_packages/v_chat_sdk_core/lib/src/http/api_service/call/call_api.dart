// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:chopper/chopper.dart';
import 'package:v_chat_sdk_core/src/http/api_service/interceptors.dart';
import 'package:v_chat_sdk_core/src/utils/api_constants.dart';

part 'call_api.chopper.dart';

@ChopperApi(baseUrl: 'call')
abstract class CallApi extends ChopperService {
  @GET(path: "/active")
  Future<Response> getActiveCall();

  @GET(path: "/history")
  Future<Response> getCallHistory();

  @GET(path: "/agora-access/{roomId}")
  Future<Response> getAgoraAccess(@Path() String roomId);

  @POST(path: "/create/{roomId}")
  Future<Response> createCall(
    @Path() String roomId,
    @Body() Map<String, dynamic> body,
  );

  @POST(path: "/accept/{meetId}", optionalBody: true)
  Future<Response> acceptCall(
    @Path() String meetId,
    @Body() Map<String, dynamic> body,
  );

  @POST(path: "/reject/{meetId}", optionalBody: true)
  Future<Response> rejectCall(@Path() String meetId);

  @POST(path: "/end/v2/{meetId}", optionalBody: true)
  Future<Response> endCallV2(@Path() String meetId);

  @DELETE(path: "/history/clear")
  Future<Response> clearHistory();

  @DELETE(path: "/history/clear/{id}")
  Future<Response> deleteOneHistory(@Path() String id);

  static CallApi create({Uri? baseUrl, String? accessToken}) {
    final client = ChopperClient(
      baseUrl: VAppConstants.baseUri,
      services: [_$CallApi()],
      converter: const JsonConverter(),
      interceptors: [AuthInterceptor()],
      errorConverter: ErrorInterceptor(),
    );
    return _$CallApi(client);
  }
}
