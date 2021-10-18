/// custom VChatSdkException
class VChatSdkException implements Exception {
  String data;

  VChatSdkException(this.data);

  @override
  String toString() {
    return data;
  }
}
