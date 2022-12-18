import '../../v_chat_sdk_core.dart';

class VFullUrlModel {
  final String originalUrl;
  late final String fullUrl;

  VFullUrlModel(this.originalUrl, {bool isFullUrl = false}) {
    if (isFullUrl) {
      fullUrl = originalUrl;
    } else {
      fullUrl = "${AppConstants.getMediaBaseUrl}$originalUrl";
    }
  }

  VFullUrlModel.fromFullUrl(this.fullUrl) : originalUrl = fullUrl;

  // to String
  @override
  String toString() {
    return originalUrl;
  }
}
