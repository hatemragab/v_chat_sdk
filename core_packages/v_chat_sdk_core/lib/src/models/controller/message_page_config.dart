import 'package:flutter/cupertino.dart';

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

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

  const VMessagePageConfig({
    this.googleMapsApiKey,
    this.onReportUserPress,
    this.onUserBlockAnother,
    this.onUserUnBlockAnother,
    this.maxRecordTime = const Duration(minutes: 30),
    this.maxMediaSize = 1024 * 1024 * 50,
  });
}
