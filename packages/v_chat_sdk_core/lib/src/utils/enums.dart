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
  custom,
  info,
}

extension MessageTypeExt on MessageType {
  bool get isMiddle => this == MessageType.info;
  bool get isImage => this == MessageType.image;

  bool get isInfo => this == MessageType.info;

  bool get isVideo => this == MessageType.video;

  bool get isLocation => this == MessageType.location;

  bool get isVoice => this == MessageType.voice;

  bool get isFile => this == MessageType.file;

  bool get isText => this == MessageType.text;

  bool get isAllDeleted => this == MessageType.allDeleted;
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

enum CallStatus {
  inComing,
  cancel,
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

extension MessageSendingStatusEnumExt on MessageSendingStatusEnum {
  bool get isSending => this == MessageSendingStatusEnum.sending;

  bool get isServerConfirm => this == MessageSendingStatusEnum.serverConfirm;

  bool get isSendingOrError => isSending || isSendError;

  bool get isSendError => this == MessageSendingStatusEnum.error;
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
