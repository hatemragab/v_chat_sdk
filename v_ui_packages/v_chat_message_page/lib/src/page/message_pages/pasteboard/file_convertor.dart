import 'dart:typed_data';

import 'package:universal_html/html.dart' as html;

abstract class IFileConvertor {
  Future<Uint8List> htmlFileToBytes(html.File file);
}

class FileConvertor implements IFileConvertor {
  @override
  Future<Uint8List> htmlFileToBytes(html.File file) async {
    try {
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);
      await reader.onLoad.first;
      return reader.result as Uint8List;
    } catch (e) {
      rethrow;
    }
  }
}
