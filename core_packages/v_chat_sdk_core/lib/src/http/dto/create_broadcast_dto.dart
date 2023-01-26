import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class CreateBroadcastDto {
  final List<String> identifiers;
  final String title;
  final VPlatformFileSource? platformImage;

//<editor-fold desc="Data Methods">

  const CreateBroadcastDto({
    required this.identifiers,
    required this.title,
    required this.platformImage,
  });

  List<PartValue> toListOfPartValue() {
    return [
      PartValue('identifiers', jsonEncode(identifiers)),
      PartValue(
        "broadcastName",
        title,
      ),
    ];
  }

//</editor-fold>
}
