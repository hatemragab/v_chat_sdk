import 'package:flutter/cupertino.dart';

import '../../../v_chat_sdk_core.dart';

class VMessagePageConfig {
  ///set api if you want to make users able to pick locations
  final String? googleMapsApiKey;

  ///set max record time
  final Duration maxRecordTime;

  ///call back when user click mention you should handle and open peer page
  final Function(BuildContext context, String id)? onMentionPress;

  ///call back when user click the app bar title in single room the id will be the user identifier
  ///so you can open the peer page on other rooms it will be the room id its important to deal with this room apis later
  final Function(
    BuildContext context,
    String id,
    VRoomType roomType,
  )? onAppBarTitlePress;

  ///set max upload files size default it 50 mb
  final int maxMediaSize;

  const VMessagePageConfig({
    this.googleMapsApiKey,
    this.onMentionPress,
    this.maxRecordTime = const Duration(minutes: 30),
    this.onAppBarTitlePress,
    this.maxMediaSize = 1024 * 1024 * 50,
  });
}
