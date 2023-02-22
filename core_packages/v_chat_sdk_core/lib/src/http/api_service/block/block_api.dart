// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:chopper/chopper.dart';
import 'package:v_chat_sdk_core/src/http/api_service/interceptors.dart';
import 'package:v_chat_sdk_core/src/utils/api_constants.dart';

part 'block_api.chopper.dart';

@ChopperApi(baseUrl: 'user-ban')
abstract class BlockApi extends ChopperService {
  @Post(path: "/{identifier}/ban", optionalBody: true)
  Future<Response> banUser(
    @Path() String identifier,
  );

  @Post(path: "/{identifier}/un-ban", optionalBody: true)
  Future<Response> unBanUser(
    @Path() String identifier,
  );

  @Get(path: "/{identifier}/ban", optionalBody: true)
  Future<Response> checkBan(
    @Path() String identifier,
  );

  static BlockApi create({
    Uri? baseUrl,
    String? accessToken,
  }) {
    final client = ChopperClient(
      baseUrl: VAppConstants.baseUri,
      services: [
        _$BlockApi(),
      ],
      converter: const JsonConverter(),
      interceptors: [AuthInterceptor()],
      errorConverter: ErrorInterceptor(),
    );
    return _$BlockApi(client);
  }
}
