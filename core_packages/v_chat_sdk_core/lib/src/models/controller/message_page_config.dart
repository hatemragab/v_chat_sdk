import 'package:flutter/cupertino.dart';

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class VMessagePageConfig {
  ///set api if you want to make users able to pick locations
  final String? googleMapsApiKey;

  ///set max record time
  final Duration maxRecordTime;

  ///call back when user click mention you should handle and open peer page
  final Function(BuildContext context, String id) onMentionPress;

  ///call back when user click the app bar title in single room the id will be the user identifier
  ///so you can open the peer page on other rooms it will be the room id its important to deal with this room apis later
  final Function(
    BuildContext context,
    String id,
    VRoomType roomType,
  )? onAppBarTitlePress;

  final Future<List<VMentionModel>> Function(
    BuildContext context,
    VRoomType roomType,
    String query,
  ) onMentionRequireSearch;

  ///set max upload files size default it 50 mb
  final int maxMediaSize;

  const VMessagePageConfig({
    this.googleMapsApiKey,
    required this.onMentionPress,
    required this.onMentionRequireSearch,
    this.maxRecordTime = const Duration(minutes: 30),
    this.onAppBarTitlePress,
    this.maxMediaSize = 1024 * 1024 * 50,
  });
}
