import 'package:chopper/chopper.dart';
import 'package:http/http.dart' as http;

class VMessageUploadModel {
  final List<PartValue> body;
  final http.MultipartFile? file1;
  final http.MultipartFile? file2;
  final String roomId;
  final String msgLocalId;

  const VMessageUploadModel({
    required this.body,
    required this.roomId,
    required this.msgLocalId,
    this.file1,
    this.file2,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VMessageUploadModel &&
          runtimeType == other.runtimeType &&
          msgLocalId == other.msgLocalId;

  @override
  int get hashCode => msgLocalId.hashCode;

  VMessageUploadModel copyWith({
    List<PartValue>? body,
    http.MultipartFile? file1,
    http.MultipartFile? file2,
    String? roomId,
    String? msgLocalId,
  }) {
    return VMessageUploadModel(
      body: body ?? this.body,
      file1: file1 ?? this.file1,
      file2: file2 ?? this.file2,
      roomId: roomId ?? this.roomId,
      msgLocalId: msgLocalId ?? this.msgLocalId,
    );
  }
}
