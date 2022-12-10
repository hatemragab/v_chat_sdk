import '../../../../v_chat_sdk_core.dart';
import 'channel_api.dart';

class ChannelApiService {
  static late final ChannelApi _channelApi;

  ChannelApiService._();

  static ChannelApiService init({
    String? baseUrl,
    String? accessToken,
  }) {
    _channelApi = ChannelApi.create(
      accessToken: accessToken,
      baseUrl: baseUrl ?? AppConstants.baseUrl,
    );
    return ChannelApiService._();
  }
}
