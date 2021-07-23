class ServerDefaultResponse {
  dynamic data;
  bool success;

  ServerDefaultResponse({required this.data,required this.success});

  factory ServerDefaultResponse.fromMap(Map<String, dynamic> map) {
    return ServerDefaultResponse(
      data: map['data'] ,
      success: map['success'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'data': data,
      'success': success,
    } as Map<String, dynamic>;
  }

  @override
  String toString() {
    return '$data';
  }
}
