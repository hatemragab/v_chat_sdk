import 'package:event_bus_plus/res/app_event.dart';

import '../../v_chat_sdk_core.dart';
import '../models/socket/room_typing_model.dart';
import '../models/v_room/single_room/single_ban_model.dart';

abstract class VRoomEvents extends AppEvent {
  String roomId;

  VRoomEvents({required this.roomId});

  @override
  List<Object?> get props => [roomId];
}

class InsertRoomEvent extends VRoomEvents {
  final VBaseRoom room;

  InsertRoomEvent({
    required super.roomId,
    required this.room,
  });
  @override
  List<Object?> get props => [super.props, room];
}

class BlockSingleRoomEvent extends VRoomEvents {
  final SingleBanModel banModel;

  BlockSingleRoomEvent({
    required super.roomId,
    required this.banModel,
  });
  @override
  List<Object?> get props => [super.props, banModel];
}

class UpdateRoomOnlineEvent extends VRoomEvents {
  final OnlineOfflineModel model;

  UpdateRoomOnlineEvent({
    required super.roomId,
    required this.model,
  });
  @override
  List<Object?> get props => [super.props, model];
}

class UpdateRoomTypingEvent extends VRoomEvents {
  final RoomTypingModel typingModel;

  UpdateRoomTypingEvent({
    required super.roomId,
    required this.typingModel,
  });
  @override
  List<Object?> get props => [super.props, typingModel];
}

class UpdateRoomNameEvent extends VRoomEvents {
  final String name;

  UpdateRoomNameEvent({
    required super.roomId,
    required this.name,
  });
  @override
  List<Object?> get props => [super.props, name];
}

class UpdateRoomImageEvent extends VRoomEvents {
  final String image;

  UpdateRoomImageEvent({
    required super.roomId,
    required this.image,
  });
  @override
  List<Object?> get props => [super.props, image];
}

class UpdateRoomUnReadCountByOneEvent extends VRoomEvents {
  UpdateRoomUnReadCountByOneEvent({
    required super.roomId,
  });
}

class UpdateRoomUnReadCountToZeroEvent extends VRoomEvents {
  UpdateRoomUnReadCountToZeroEvent({
    required super.roomId,
  });
}

class UpdateRoomMuteEvent extends VRoomEvents {
  final bool isMuted;

  UpdateRoomMuteEvent({
    required super.roomId,
    required this.isMuted,
  });
  @override
  List<Object?> get props => [super.props, isMuted];
}

class DeleteRoomEvent extends VRoomEvents {
  DeleteRoomEvent({
    required super.roomId,
  });
}
