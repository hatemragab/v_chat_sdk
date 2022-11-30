import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class HttpModel {
  final String endpoint;
  VChatLoadingState state;
  final VChatHttpMethods method;
  bool isExpanded;

  HttpModel({
    required this.endpoint,
    required this.state,
    required this.method,
    required this.isExpanded,
  });
}
