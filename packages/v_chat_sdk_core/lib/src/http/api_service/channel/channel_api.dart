import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:http/io_client.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../../v_chat_sdk_core.dart';
import '../interceptors.dart';

part 'channel_api.chopper.dart';

@ChopperApi(baseUrl: 'channel')
abstract class ChannelApi extends ChopperService {
  static ChannelApi create({
    String? baseUrl,
    String? accessToken,
  }) {
    final client = ChopperClient(
      baseUrl: baseUrl ?? AppConstants.baseUrl,
      services: [
        _$ChannelApi(),
      ],
      converter: const JsonConverter(),
      interceptors: [AuthInterceptor()],
      errorConverter: ErrorInterceptor(),
      client: Platforms.isWeb
          ? null
          : IOClient(
              HttpClient()..connectionTimeout = const Duration(seconds: 8),
            ),
    );
    return _$ChannelApi(client);
  }
}
