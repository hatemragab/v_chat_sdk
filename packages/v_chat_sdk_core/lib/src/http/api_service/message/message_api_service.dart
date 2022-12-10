import '../../../../v_chat_sdk_core.dart';
import 'message_api.dart';

class MessageApiService {
  static late final MessageApi _messageApi;

  MessageApiService._();

  static MessageApiService init({
    String? baseUrl,
    String? accessToken,
  }) {
    _messageApi = MessageApi.create(
      accessToken: accessToken,
      baseUrl: baseUrl ?? AppConstants.baseUrl,
    );
    return MessageApiService._();
  }
}
