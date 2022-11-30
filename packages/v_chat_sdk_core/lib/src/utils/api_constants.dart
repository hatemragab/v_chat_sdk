import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

abstract class ApiConstants {
  const ApiConstants._();

  static String clintVersion = "2.0.0";

  static String get baseServerIp {
    return VChatController.instance.config.baseUrl.toString();
  }

  static String get baseUrl {
    return "$baseServerIp/api/v2";
  }

  static String get getMediaBaseUrl {
    final s3BucketUrl = VChatController.instance.config.s3BucketUrl;
    if (s3BucketUrl != null) {
      return s3BucketUrl;
    }
    return "$baseUrl/public/";
  }
}
