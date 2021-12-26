part of 'room_cubit.dart';

@immutable
abstract class RoomState {}

class RoomInitial extends RoomState {}

class RoomLoaded extends RoomState {
  final List<VChatRoom> rooms;

  RoomLoaded(this.rooms);
}

class RoomLoading extends RoomState {}

class RoomEmpty extends RoomState {}
