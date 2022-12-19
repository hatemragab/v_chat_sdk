enum VChatPushService { firebase, onesignal }

enum VChatHttpMethods { get, post, patch, delete }

enum MessageType {
  text,
  image,
  file,
  video,
  voice,
  location,
  allDeleted,
  call,
  info,
  bot
}

enum NotificationType {
  groupChat,
  singleChat,
  broadcastChat,
  deleteMessage,
}

enum GroupMsgInfo {
  gLeave,
  gJoin,
  gUpgrade,
  gDowngrade,
  gKick,
  gDataUpdate,
  bAdd,
  bKick,
  bDeleted,
}

enum SocketStateType { connected, connecting }

enum RoomType {
  s,
  g,
  b,
}

extension StrType on RoomType {
  bool get isGroup => this == RoomType.g;

  bool get isSingle => this == RoomType.s;

  bool get isBroadcast => this == RoomType.b;
}

enum MessageSendingStatusEnum {
  //send
  serverConfirm,
  error,
  sending,
}

enum MessageInfoType {
  updateTitle,
  updateImage,
  addGroupMember,
  upAdmin,
  downMember,
  leave,
  kick,
  createGroup,
  addToBroadcast,
}

enum GroupMemberRole { admin, member, superAdmin }
