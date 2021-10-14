import 'package:flutter/foundation.dart';

enum LoadMoreStatus { loading, loaded, error, completed }

// ignore: camel_case_extensions
extension loadMoreStatus on LoadMoreStatus {
  String get inString => describeEnum(this);
}
