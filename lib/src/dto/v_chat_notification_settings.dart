class VChatNotificationSettings {
  final String icon;
  final bool vibrate;
  final bool sound;

  const VChatNotificationSettings({
    this.icon = "@mipmap/ic_launcher",
    this.vibrate = true,
    this.sound = true,
  });
}
