import 'package:event_bus_plus/res/app_event.dart';

import '../../v_chat_sdk_core.dart';
import '../models/v_room/single_room/single_ban_model.dart';

abstract class VRoomEvents extends AppEvent {
  final String roomId;

  const VRoomEvents({
    required this.roomId,
  });

  @override
  List<Object?> get props => [roomId];
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

class VBlockSingleRoomEvent extends VRoomEvents {
  final VSingleBanModel banModel;

  const VBlockSingleRoomEvent({
    required super.roomId,
    required this.banModel,
  });

  @override
  List<Object?> get props => [super.props, banModel];
}

// class VSocketUpdateOnlineList extends VRoomEvents {
//   final VOnlineOfflineModel model;
//
//   const VSocketUpdateOnlineList({
//     required super.roomId,
//     required this.model,
//   });
//
//   @override
//   List<Object?> get props => [super.props, model];
// }

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
