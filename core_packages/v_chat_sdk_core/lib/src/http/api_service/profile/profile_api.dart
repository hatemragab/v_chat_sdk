import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:http/http.dart' hide Response, Request;
import 'package:http/io_client.dart';
import 'package:v_chat_sdk_core/src/http/api_service/interceptors.dart';
import 'package:v_chat_sdk_core/src/utils/api_constants.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

part 'profile_api.chopper.dart';

@ChopperApi(baseUrl: 'profile')
abstract class ProfileApi extends ChopperService {
  ///update image
  @Patch(path: '/image')
  @multipart
  Future<Response> updateImage(
    @PartFile("file") MultipartFile file,
  );

  ///update password
  @Patch(path: "/lang")
  Future<Response> updateLang(@Body() Map<String, dynamic> body);

  ///update name
  @Patch(path: "/name")
  Future<Response> updateUserName(@Body() Map<String, dynamic> body);

  ///add fcm
  @Post(path: "/fcm")
  Future<Response> addFcm(@Body() Map<String, dynamic> body);

  ///delete fcm
  @Delete(path: "/fcm")
  Future<Response> deleteFcm();

  @Get(path: "/users/{peerId}/last-seen", optionalBody: true)
  Future<Response> getLastSeenAt(
    @Path("peerId") String peerId,
  );

  static ProfileApi create({
    Uri? baseUrl,
    String? accessToken,
  }) {
    final client = ChopperClient(
      baseUrl: VAppConstants.baseUri,
      services: [
        _$ProfileApi(),
      ],
      converter: const JsonConverter(),
      //, HttpLoggingInterceptor()
      interceptors: [AuthInterceptor()],
      errorConverter: ErrorInterceptor(),
      client: VPlatforms.isWeb
          ? null
          : IOClient(
              HttpClient()..connectionTimeout = const Duration(seconds: 10),
            ),
    );
    return _$ProfileApi(client);
  }
}
