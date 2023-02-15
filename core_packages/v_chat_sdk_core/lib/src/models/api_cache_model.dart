// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:v_chat_sdk_core/src/local_db/tables/api_cache_table.dart';

class ApiCacheModel {
  final String endPoint;
  final Map<String, dynamic> value;

//<editor-fold desc="Data Methods">

  const ApiCacheModel({
    required this.endPoint,
    required this.value,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiCacheModel &&
          runtimeType == other.runtimeType &&
          endPoint == other.endPoint;

  @override
  int get hashCode => endPoint.hashCode;

  @override
  String toString() {
    return 'ApiCacheModel{ endPoint: $endPoint, value: $value,}';
  }

  Map<String, dynamic> toLocalMap() {
    return {
      ApiCacheTable.columnId: endPoint,
      ApiCacheTable.columnJsonValue: jsonEncode(value),
    };
  }

  factory ApiCacheModel.fromLocalMap(Map<String, dynamic> map) {
    return ApiCacheModel(
      endPoint: map[ApiCacheTable.columnId] as String,
      value: jsonDecode(map[ApiCacheTable.columnJsonValue] as String)
          as Map<String, dynamic>,
    );
  }

//</editor-fold>
}
