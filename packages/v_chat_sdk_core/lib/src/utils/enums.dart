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

enum VRoomType { s, g, b, o }

extension StrType on VRoomType {
  bool get isGroup => this == VRoomType.g;

  bool get isSingle => this == VRoomType.s;
  bool get isSingleOrOrder => this == VRoomType.s || this == VRoomType.o;

  bool get isBroadcast => this == VRoomType.b;
  bool get isCustom => this == VRoomType.o;
}

enum MessageEmitStatus {
  //send
  serverConfirm,
  error,
  sending,
}

extension MessageSendingStatusEnumExt on MessageEmitStatus {
  bool get isSending => this == MessageEmitStatus.sending;

  bool get isServerConfirm => this == MessageEmitStatus.serverConfirm;

  bool get isSendingOrError => isSending || isSendError;

  bool get isSendError => this == MessageEmitStatus.error;
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

enum MessagesFilter { media, links, file, voice, all }
