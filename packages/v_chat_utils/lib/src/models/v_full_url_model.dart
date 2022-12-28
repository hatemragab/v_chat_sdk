String? mediaBaseUrl;

class VFullUrlModel {
  final String originalUrl;
  late final String fullUrl;

  VFullUrlModel(
    this.originalUrl, {
    bool isFullUrl = false,
  }) {
    if (originalUrl.startsWith("http")) {
      fullUrl = originalUrl;
      return;
    }

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
  VFullUrlModel.fromFakeUrl()
      : fullUrl = "https://picsum.photos/500/500",
        originalUrl = "https://picsum.photos/500/500";

  // to String
  @override
  String toString() {
    return originalUrl;
  }
}
