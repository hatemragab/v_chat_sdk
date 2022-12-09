import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

abstract class BaseMediaEditor {
  bool isSelected = false;
  final String id;

  BaseMediaEditor({
    required this.id,
  });

  @override
  bool operator ==(Object other) => other is BaseMediaEditor && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class MediaEditorImage extends BaseMediaEditor {
  MessageImageData data;

  MediaEditorImage({
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

class MediaEditorVideo extends BaseMediaEditor {
  MessageVideoData data;

  MediaEditorVideo({
    String? id,
    required this.data,
  }) : super(id: id ?? DateTime.now().microsecondsSinceEpoch.toString());

  @override
  String toString() {
    return 'MediaEditorVideo{data $data}';
  }
}
