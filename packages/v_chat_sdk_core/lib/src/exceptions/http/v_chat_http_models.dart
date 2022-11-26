class VChatHttpRequest {
  final String url;
  final Map<String, Object> requestMap;

  VChatHttpRequest({required this.url, required this.requestMap});
}

class VChatHttpResponse {
  final Map<String, Object> responseMap;

  VChatHttpResponse({required this.responseMap});
}
