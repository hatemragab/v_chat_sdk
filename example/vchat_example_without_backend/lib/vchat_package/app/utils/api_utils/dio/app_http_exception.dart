class AppHttpException implements Exception {
  String data;

  AppHttpException(this.data);

  @override
  String toString() {
    return '$data';
  }
}
