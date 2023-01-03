class CurrentRoom {
  bool isActive;
  String roomId;

  CurrentRoom({
    required this.isActive,
    required this.roomId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrentRoom &&
          runtimeType == other.runtimeType &&
          roomId == other.roomId;

  @override
  int get hashCode => roomId.hashCode;
}
