import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class CreateBroadcastDto {
  final List<String> peerIds;
  final String title;
  final VPlatformFileSource? platformImage;

//<editor-fold desc="Data Methods">

  const CreateBroadcastDto({
    required this.peerIds,
    required this.title,
    required this.platformImage,
  });

  List<PartValue> toListOfPartValue() {
    return [
      PartValue('peerIds', jsonEncode(peerIds)),
      PartValue(
        "broadcastName",
        title,
      ),
    ];
  }

//</editor-fold>
}
