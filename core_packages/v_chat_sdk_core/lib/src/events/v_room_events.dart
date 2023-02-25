// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class VTotalUnReadCount extends VAppEvent {
  final int count;

  const VTotalUnReadCount(this.count);

  @override
  List<Object?> get props => [count];
}

abstract class VRoomEvents extends VAppEvent {
  final String roomId;

  const VRoomEvents({
    required this.roomId,
  });

  @override
  List<Object?> get props => [roomId];
}

class VOnGroupKicked extends VRoomEvents {
  const VOnGroupKicked({
    required super.roomId,
  });
}

class VInsertRoomEvent extends VRoomEvents {
  final VRoom room;

  const VInsertRoomEvent({
    required super.roomId,
    required this.room,
  });

  @override
  List<Object?> get props => [super.props, room];
}

class VBlockRoomEvent extends VRoomEvents {
  final OnBanUserChatModel banModel;

  const VBlockRoomEvent({
    required super.roomId,
    required this.banModel,
  });

  @override
  List<Object?> get props => [super.props, banModel];
}

class VRoomOnlineEvent extends VRoomEvents {
  const VRoomOnlineEvent({
    required super.roomId,
  });

  @override
  List<Object?> get props => [
        super.props,
      ];
}

class VRoomOfflineEvent extends VRoomEvents {
  const VRoomOfflineEvent({
    required super.roomId,
  });

  @override
  List<Object?> get props => [
        super.props,
      ];
}

class VUpdateRoomTypingEvent extends VRoomEvents {
  final VSocketRoomTypingModel typingModel;

  const VUpdateRoomTypingEvent({
    required super.roomId,
    required this.typingModel,
  });

  @override
  List<Object?> get props => [super.props, typingModel];
}

class VUpdateRoomNameEvent extends VRoomEvents {
  final String name;

  const VUpdateRoomNameEvent({
    required super.roomId,
    required this.name,
  });

  @override
  List<Object?> get props => [super.props, name];
}

class VUpdateTransToEvent extends VRoomEvents {
  final String? transTo;

  const VUpdateTransToEvent({
    required super.roomId,
    required this.transTo,
  });

  @override
  List<Object?> get props => [super.props, transTo];
}

class VUpdateRoomImageEvent extends VRoomEvents {
  final String image;

  const VUpdateRoomImageEvent({
    required super.roomId,
    required this.image,
  });

  @override
  List<Object?> get props => [super.props, image];
}

class VUpdateRoomUnReadCountByOneEvent extends VRoomEvents {
  const VUpdateRoomUnReadCountByOneEvent({
    required super.roomId,
  });
}

class VUpdateRoomUnReadCountToZeroEvent extends VRoomEvents {
  const VUpdateRoomUnReadCountToZeroEvent({
    required super.roomId,
  });
}

class VUpdateRoomMuteEvent extends VRoomEvents {
  final bool isMuted;

  const VUpdateRoomMuteEvent({
    required super.roomId,
    required this.isMuted,
  });

  @override
  List<Object?> get props => [super.props, isMuted];
}

class VDeleteRoomEvent extends VRoomEvents {
  const VDeleteRoomEvent({
    required super.roomId,
  });
}
