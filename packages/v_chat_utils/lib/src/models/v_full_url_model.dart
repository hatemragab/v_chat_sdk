class VFullUrlModel {
  final String originalUrl;
  late final String fullUrl;
  static String? mediaBaseUrl;

  VFullUrlModel(
    this.originalUrl, {
    bool isFullUrl = false,
  }) {
    if (isFullUrl) {
      fullUrl = originalUrl;
    } else {
      if (mediaBaseUrl == null) {
        throw "You have to set the media base url first call (VFullUrlModel.mediaBaseUrl = 'YOUR_MEDIA_BASE_URL')";
      }
      fullUrl = "$mediaBaseUrl$originalUrl";
    }
  }

  VFullUrlModel.fromFullUrl(this.fullUrl) : originalUrl = fullUrl;

  // to String
  @override
  String toString() {
    return originalUrl;
  }
}
