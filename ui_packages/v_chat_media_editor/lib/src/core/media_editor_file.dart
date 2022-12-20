import 'package:v_chat_utils/v_chat_utils.dart';

abstract class VBaseMediaEditor {
  bool isSelected = false;
  final String id;

  VBaseMediaEditor({
    required this.id,
  });

  @override
  bool operator ==(Object other) => other is VBaseMediaEditor && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class VMediaEditorImage extends VBaseMediaEditor {
  VMessageImageData data;

  VMediaEditorImage({
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

class VMediaEditorVideo extends VBaseMediaEditor {
  VMessageVideoData data;

  VMediaEditorVideo({
    String? id,
    required this.data,
  }) : super(id: id ?? DateTime.now().microsecondsSinceEpoch.toString());

  @override
  String toString() {
    return 'MediaEditorVideo{data $data}';
  }
}

class VMediaEditorFile extends VBaseMediaEditor {
  VPlatformFileSource data;

  VMediaEditorFile({
    String? id,
    required this.data,
  }) : super(id: id ?? DateTime.now().microsecondsSinceEpoch.toString());

  @override
  String toString() {
    return 'MediaEditorFile{data $data}';
  }
}
