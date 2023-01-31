enum VChatHttpMethods { get, post, patch, delete, put }

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
  bool get isImage => this == MessageType.image;

  bool get isInfo => this == MessageType.info;

  bool get isVideo => this == MessageType.video;

  bool get isLocation => this == MessageType.location;

  bool get isVoice => this == MessageType.voice;

  bool get isFile => this == MessageType.file;

  bool get isText => this == MessageType.text;

  bool get isAllDeleted => this == MessageType.allDeleted;

  bool get isCenter => this == MessageType.info;
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

///s is single room (one to one chat)
///g is group chat
///b is broadcast chat
///o order room!
enum VRoomType { s, g, b, o }

extension StrType on VRoomType {
  bool get isGroup => this == VRoomType.g;

  bool get isSingle => this == VRoomType.s;
  bool get isSingleOrOrder => this == VRoomType.s || this == VRoomType.o;

  bool get isBroadcast => this == VRoomType.b;
  bool get isOrder => this == VRoomType.o;
}

enum VMessageEmitStatus {
  //send
  serverConfirm,
  error,
  sending,
}

extension VMessageSendingStatusEnumExt on VMessageEmitStatus {
  bool get isSending => this == VMessageEmitStatus.sending;

  bool get isServerConfirm => this == VMessageEmitStatus.serverConfirm;

  bool get isSendingOrError => isSending || isSendError;

  bool get isSendError => this == VMessageEmitStatus.error;
}

enum VMessageInfoType {
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

enum VGroupMemberRole { admin, member, superAdmin }

enum VMessagesFilter { media, links, file, voice, all }
