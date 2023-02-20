// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

typedef UserActionType = Function(
  BuildContext context,
  String id,
  VRoomType roomType,
);

class VMessagePageConfig {
  ///set api if you want to make users able to pick locations
  final String? googleMapsApiKey;

  ///set max record time
  final Duration maxRecordTime;

  final UserActionType? onReportUserPress;

  final Function(
    BuildContext context,
    String peerIdentifer,
  )? onUserBlockAnother;

  final Function(
    BuildContext context,
    String peerIdentifer,
  )? onUserUnBlockAnother;

  ///set max upload files size default it 50 mb
  final int maxMediaSize;
  final int maxForward;

  const VMessagePageConfig({
    this.googleMapsApiKey,
    this.onReportUserPress,
    this.onUserBlockAnother,
    this.onUserUnBlockAnother,
    this.maxRecordTime = const Duration(minutes: 30),
    this.maxMediaSize = 1024 * 1024 * 50,
    this.maxForward = 7,
  });

  Map<String, dynamic> toMap() {
    return {
      'googleMapsApiKey': googleMapsApiKey,
      'maxRecordTime': maxRecordTime,
      'onReportUserPress': onReportUserPress,
      'onUserBlockAnother': onUserBlockAnother,
      'onUserUnBlockAnother': onUserUnBlockAnother,
      'maxMediaSize': maxMediaSize,
    };
  }

  factory VMessagePageConfig.fromMap(Map<String, dynamic> map) {
    return VMessagePageConfig(
      googleMapsApiKey: map['googleMapsApiKey'] as String,
      maxRecordTime: map['maxRecordTime'] as Duration,
      onReportUserPress: map['onReportUserPress'] as UserActionType,
      onUserBlockAnother: map['onUserBlockAnother'] as Function(
        BuildContext context,
        String peerIdentifer,
      ),
      onUserUnBlockAnother: map['onUserUnBlockAnother'] as Function(
        BuildContext context,
        String peerIdentifer,
      ),
      maxMediaSize: map['maxMediaSize'] as int,
    );
  }

  VMessagePageConfig copyWith({
    String? googleMapsApiKey,
    Duration? maxRecordTime,
    UserActionType? onReportUserPress,
    Function(
      BuildContext context,
      String peerIdentifer,
    )?
        onUserBlockAnother,
    Function(
      BuildContext context,
      String peerIdentifer,
    )?
        onUserUnBlockAnother,
    int? maxMediaSize,
  }) {
    return VMessagePageConfig(
      googleMapsApiKey: googleMapsApiKey ?? this.googleMapsApiKey,
      maxRecordTime: maxRecordTime ?? this.maxRecordTime,
      onReportUserPress: onReportUserPress ?? this.onReportUserPress,
      onUserBlockAnother: onUserBlockAnother ?? this.onUserBlockAnother,
      onUserUnBlockAnother: onUserUnBlockAnother ?? this.onUserUnBlockAnother,
      maxMediaSize: maxMediaSize ?? this.maxMediaSize,
    );
  }
}
