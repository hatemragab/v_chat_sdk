import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:http/http.dart' hide Response, Request;
import 'package:http/io_client.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../utils/api_constants.dart';
import '../interceptors.dart';

part 'message_api.chopper.dart';

@ChopperApi(baseUrl: 'channel')
abstract class MessageApi extends ChopperService {
  ///create message to channel
  @Post(path: "/{roomId}/message/")
  @multipart
  Future<Response> createMessage(
    @Path('roomId') String roomId,
    @PartMap() List<PartValue> body,
    @PartFile("file") MultipartFile? file,
    @PartFile("file") MultipartFile? secondFile,
  );

  @Get(path: "/{roomId}/message/")
  Future<Response> getRoomMessages(
    @Path("roomId") String roomId,
    @QueryMap() Map<String, dynamic> query,
  );

  @Delete(path: "/{roomId}/message/{messageId}/delete/me")
  Future<Response> deleteMessageFromMe(
    @Path("roomId") String roomId,
    @Path("messageId") String messageId,
  );

  @Delete(path: "/{roomId}/message/{messageId}/delete/all")
  Future<Response> deleteMessageFromAll(
    @Path("roomId") String roomId,
    @Path("messageId") String mId,
  );

  @Get(path: "/{roomId}/message/{messageId}/status/summary")
  Future<Response> getMessageStatusSummary(
    @Path("roomId") String roomId,
    @Path("messageId") String messageId,
  );

  @Get(path: "/{roomId}/message/{messageId}/status/{type}", optionalBody: true)
  Future<Response> getMessageStatus(
    @Path("roomId") String roomId,
    @Path("messageId") String mId,

    ///it can be seen or deliver
    @QueryMap() Map<String, Object> query,
    @Path("type") String type,
  );

  static MessageApi create({
    Uri? baseUrl,
    String? accessToken,
  }) {
    final client = ChopperClient(
      baseUrl: VAppConstants.baseUri,
      services: [
        _$MessageApi(),
      ],
      converter: const JsonConverter(),
      //, HttpLoggingInterceptor()
      interceptors: [AuthInterceptor()],
      errorConverter: ErrorInterceptor(),
      client: VPlatforms.isWeb
          ? null
          : IOClient(
              HttpClient()..connectionTimeout = const Duration(seconds: 6),
            ),
    );
    return _$MessageApi(client);
  }
}
