enum VChatPushService { firebase, onesignal }

enum VChatHttpMethods { get, post, patch, delete }

enum VChatLoadingState { loading, success, error, ideal, empty }

enum SupportedFilesType { image, file, video }

enum StorageKeys {
  accessToken,
  isFirstRun,
  appMetaData,
  appLanguage,
  clintVersion,
  vMyProfile,
  appTheme,
  lastAppliedUpdate,
  lastSuccessFetchRoomsTime,
  isLogin,
  isDev
}

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
  newFollow
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

enum RoomTypingEnum { stop, typing, recording }

enum MessageSendingStatusEnum {
  serverConfirm,
  error,
  sending,
}

enum LoadMoreStatus { loading, loaded, error, completed }

enum MessageInfoType {
  updateTitle,
  updateImage,
  addGroupMember,
  upAdmin,
  downMember,
  leave,
  kick,
  createGroup,
  createProject,
  addToBroadcast,
  addToProject
}

enum GroupMemberRole { admin, member, superAdmin }

enum PaginationType { page, id }
