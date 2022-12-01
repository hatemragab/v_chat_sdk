abstract class VChatBaseException implements Exception {
  final Object exception;
  final StackTrace? stack;

  VChatBaseException({
    required this.exception,
    this.stack,
  });

  @override
  String toString() {
    return exception.toString();
  }
}

class VChatDartException extends VChatBaseException {
  VChatDartException({required super.exception});
}
