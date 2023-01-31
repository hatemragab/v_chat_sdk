class VToChatSettingsModel{
  final String title;
  final String image;
  final String roomId;

  const VToChatSettingsModel({
    required this.title,
    required this.image,
    required this.roomId,
  });

  @override
  String toString() {
    return 'VToChatSettingsModel{title: $title, image: $image, roomId: $roomId}';
  }
}