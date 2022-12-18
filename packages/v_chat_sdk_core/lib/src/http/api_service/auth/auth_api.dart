import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:http/http.dart' hide Response, Request;
import 'package:http/io_client.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../../v_chat_sdk_core.dart';
import '../interceptors.dart';

part 'auth_api.chopper.dart';

@ChopperApi(baseUrl: 'auth')
abstract class AuthApi extends ChopperService {
  @Post(path: "/login")
  Future<Response> login(@Body() Map<String, dynamic> body);

  @Post(path: "/register")
  @multipart
  Future<Response> register(
    @PartMap() List<PartValue> body,
    @PartFile("file") MultipartFile? file,
  );

  @Post(path: "/logout")
  Future<Response> logout();

  static AuthApi create({
    String? baseUrl,
    String? accessToken,
  }) {
    final client = ChopperClient(
      baseUrl: baseUrl ?? AppConstants.baseUrl,
      services: [
        _$AuthApi(),
      ],
      converter: const JsonConverter(),
      interceptors: [AuthInterceptor()],
      errorConverter: ErrorInterceptor(),
      client: Platforms.isWeb
          ? null
          : IOClient(
              HttpClient()..connectionTimeout = const Duration(seconds: 7),
            ),
    );
    return _$AuthApi(client);
  }
}
