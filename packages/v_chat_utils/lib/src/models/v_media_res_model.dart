import 'package:v_chat_utils/v_chat_utils.dart';

abstract class VBaseMediaRes {
  bool isSelected = false;
  final String id;

  VBaseMediaRes({
    required this.id,
  });

  @override
  bool operator ==(Object other) => other is VBaseMediaRes && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class VMediaImageRes extends VBaseMediaRes {
  VMessageImageData data;

  VMediaImageRes({
    String? id,
    required this.data,
  }) : super(
          id: id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        );

  @override
  String toString() {
    return 'MediaEditorImage{data: $data }';
  }
}

class VMediaVideoRes extends VBaseMediaRes {
  VMessageVideoData data;

  VMediaVideoRes({
    String? id,
    required this.data,
  }) : super(id: id ?? DateTime.now().microsecondsSinceEpoch.toString());

  @override
  String toString() {
    return 'MediaEditorVideo{data $data}';
  }
}

class VMediaFileRes extends VBaseMediaRes {
  VPlatformFileSource data;

  VMediaFileRes({
    String? id,
    required this.data,
  }) : super(id: id ?? DateTime.now().microsecondsSinceEpoch.toString());

  @override
  String toString() {
    return 'MediaEditorFile{data $data}';
  }
}
