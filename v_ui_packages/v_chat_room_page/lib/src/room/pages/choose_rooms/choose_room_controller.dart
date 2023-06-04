// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

/// Controller for selecting from a list of rooms. /// /// Extends [ValueNotifier] to allow [List ] to be listened to and updated. class ChooseRoomsController extends ValueNotifier<List > { /// The currently selected room ID. final String? currentId;
/// Create a new instance of [ChooseRoomsController]. /// /// Initializes an empty list of rooms and calls [_getRooms()] to fetch them. ChooseRoomsController(this.currentId) : super([]) { _getRooms(); } }
class ChooseRoomsController extends ValueNotifier<List<VRoom>> {
  final String? currentId;

  ChooseRoomsController(this.currentId) : super([]) {
    _getRooms();
  }

  void close() {}
  final maxForward = VChatController.I.vChatConfig.maxForward;

  bool get isThereSelection =>
      value.firstWhereOrNull((e) => e.isSelected) == null;

  void onDone(BuildContext context) {
    final l = <String>[];
    for (var element in value) {
      if (element.isSelected) {
        l.add(element.id);
      }
    }
    Navigator.pop(context, l);
  }

  void _getRooms() async {
    final vRooms =
        (await VChatController.I.nativeApi.local.room.getRooms(limit: 120))
            .where((e) => e.id != currentId && !e.roomType.isBroadcast)
            .toList();
    value = vRooms;
  }

  int get selectedCount => value.where((e) => e.isSelected).length;

  void onRoomItemPress(VRoom room, BuildContext context) {
    if (selectedCount >= maxForward) {
      return;
    }
    value.firstWhere((e) => e == room).toggleSelect();
    notifyListeners();
  }
}
