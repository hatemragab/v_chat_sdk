// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

/// Event for the total unread count.
class VTotalUnReadCount extends VAppEvent {
  final int count; // Total unread count.

  const VTotalUnReadCount(this.count);

  @override
  List<Object?> get props => [count];
}

/// Abstract base class for room events.
/// All room event classes should extend this class.
abstract class VRoomEvents extends VAppEvent {
  final String roomId; // The ID of the room associated with the event.

  const VRoomEvents({
    required this.roomId,
  });

  @override
  List<Object?> get props => [roomId];
}

/// Event for a group kicked action.
/// if you get kicked from a group, you will not be able to send messages to that group.
/// you should leave the group and join it again to be able to send messages.
/// all messages will be deleted from the group after you get kicked.
class VOnGroupKicked extends VRoomEvents {
  const VOnGroupKicked({
    required super.roomId,
  });
}

/// Event for inserting a room.
/// when you receive this event, you should insert the room into your rooms list.
/// this means that you should add the room to the top of the list.
/// this is new chat it may be group or single chat.
class VInsertRoomEvent extends VRoomEvents {
  final VRoom room; // The room to be inserted.

  const VInsertRoomEvent({
    required super.roomId,
    required this.room,
  });
}

/// Event for single block action.
/// when you receive this event, you should block the user in your app.
/// and you should prevent the user from sending messages to you.
class VSingleBlockEvent extends VRoomEvents {
  final VSingleBlockModel banModel; // The model for the single block action.

  const VSingleBlockEvent({
    required super.roomId,
    required this.banModel,
  });
}

/// Event for a room going online.
/// when you receive this event, you should update the room status to online.
class VRoomOnlineEvent extends VRoomEvents {
  const VRoomOnlineEvent({
    required super.roomId,
  });
}

/// Event for a room going offline.
/// when you receive this event, you should update the room status to offline.
class VRoomOfflineEvent extends VRoomEvents {
  const VRoomOfflineEvent({
    required super.roomId,
  });
}

/// Event for updating room typing status.
/// when you receive this event, you should update the typing status of the room.
class VUpdateRoomTypingEvent extends VRoomEvents {
  final VSocketRoomTypingModel typingModel; // The model for the typing status.

  const VUpdateRoomTypingEvent({
    required super.roomId,
    required this.typingModel,
  });
}

/// Event for updating room name.
/// when you receive this event, you should update the name of the room. it will be for group chat.
class VUpdateRoomNameEvent extends VRoomEvents {
  final String name; // The new name of the room.

  const VUpdateRoomNameEvent({
    required super.roomId,
    required this.name,
  });
}

/// Event for updating the translation setting.
/// when you receive this event, you should update the translation setting of the room.
/// Not supported yet.
class VUpdateTransToEvent extends VRoomEvents {
  final String? transTo; // The new translation setting.

  const VUpdateTransToEvent({
    required super.roomId,
    required this.transTo,
  });
}

/// Event for updating room image.
/// when you receive this event, you should update the image of the room. it will be for group chat.
class VUpdateRoomImageEvent extends VRoomEvents {
  final String image; // The new image of the room.

  const VUpdateRoomImageEvent({
    required super.roomId,
    required this.image,
  });
}

/// Event for updating the room unread count by one.
/// when you receive this event, you should update the unread count of the room by one add ++.
class VUpdateRoomUnReadCountByOneEvent extends VRoomEvents {
  const VUpdateRoomUnReadCountByOneEvent({
    required super.roomId,
  });
}

/// Event for setting the room unread count to zero.
/// when you receive this event, you should set the unread count of the room to zero.
class VUpdateRoomUnReadCountToZeroEvent extends VRoomEvents {
  const VUpdateRoomUnReadCountToZeroEvent({
    required super.roomId,
  });
}

/// Event for updating room mute status.
/// when you receive this event, you should update the mute status of the room.
class VUpdateRoomMuteEvent extends VRoomEvents {
  final bool isMuted; // The new mute status.

  const VUpdateRoomMuteEvent({
    required super.roomId,
    required this.isMuted,
  });
}

/// Event for deleting a room.
/// when you receive this event, you should delete the room from your rooms list.
/// this means the user try to delete the room from his chat list.
class VDeleteRoomEvent extends VRoomEvents {
  const VDeleteRoomEvent({
    required super.roomId,
  });
}
