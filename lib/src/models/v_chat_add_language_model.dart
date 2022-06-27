import 'package:v_chat_sdk/v_chat_sdk.dart';

class VChatAddLanguageModel {
  final String languageCode;
  final String? countryCode;
  final VChatLookupString lookupMessages;

  const VChatAddLanguageModel({
    required this.languageCode,
    this.countryCode,
    required this.lookupMessages,
  });
}
