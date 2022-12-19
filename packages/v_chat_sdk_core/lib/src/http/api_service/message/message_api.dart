import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:http/http.dart' hide Response, Request;
import 'package:http/io_client.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../../v_chat_sdk_core.dart';
import '../interceptors.dart';

part 'message_api.chopper.dart';

@ChopperApi(baseUrl: 'channel/{roomId}/message')
abstract class MessageApi extends ChopperService {
  ///create message to channel
  @Post(path: "/")
  @multipart
  Future<Response> createMessage(
    @Path('roomId') String roomId,
    @PartMap() List<PartValue> body,
    @PartFile("file") MultipartFile? file,
    @PartFile("file") MultipartFile? secondFile,
  );

  static MessageApi create({
    String? baseUrl,
    String? accessToken,
  }) {
    final client = ChopperClient(
      baseUrl: baseUrl ?? AppConstants.baseUrl,
      services: [
        _$MessageApi(),
      ],
      converter: const JsonConverter(),
      interceptors: [AuthInterceptor()],
      errorConverter: ErrorInterceptor(),
      client: VPlatforms.isWeb
          ? null
          : IOClient(
              HttpClient()..connectionTimeout = const Duration(seconds: 8),
            ),
    );
    return _$MessageApi(client);
  }
}
