abstract class VChatBaseException implements Exception {
  final Object exception;
  final Object? stack;

  VChatBaseException({
    required this.exception,
    this.stack,
  });

  @override
  String toString() {
    return exception.toString();
  }
}
