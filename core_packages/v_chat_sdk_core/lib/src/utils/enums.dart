// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

enum VChatHttpMethods { get, post, patch, delete, put }

enum VMessageType {
  text,
  image,
  file,
  video,
  voice,
  location,
  call,
  custom,
  info,
}

extension MessageTypeExt on VMessageType {
  bool get isImage => this == VMessageType.image;

  bool get isMedia => isImage || isVideo;

  bool get isCall => this == VMessageType.call;

  bool get isInfo => this == VMessageType.info;

  bool get isVideo => this == VMessageType.video;

  bool get isLocation => this == VMessageType.location;

  bool get isVoice => this == VMessageType.voice;

  bool get isFile => this == VMessageType.file;

  bool get isText => this == VMessageType.text;

  bool get isCenter => this == VMessageType.info;
}

enum VNotificationType {
  groupChat,
  singleChat,
  broadcastChat,
  deleteMessage,
}

enum VGroupMsgInfo {
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

// extension VMessageCallStatusTr on VMessageCallStatus {
//   String tr(BuildContext context) {
//     switch (this) {
//       case VMessageCallStatus.ring:
//         return language.ring;
//       case VMessageCallStatus.canceled:
//         return language.canceled;
//       case VMessageCallStatus.timeout:
//         return language.timeout;
//       case VMessageCallStatus.rejected:
//         return language.rejected;
//       case VMessageCallStatus.finished:
//       case VMessageCallStatus.sessionEnd:
//         return language.callEnd;
//       case VMessageCallStatus.inCall:
//         return language.inCall;
//     }
//   }
// }

enum VMessageCallStatus {
  ring,
  canceled,
  timeout,
  rejected,
  finished,
  inCall,
  sessionEnd
}

enum VSocketStateType { connected, connecting }

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

enum VLoadMoreStatus { loading, loaded, error, completed }

enum VChatLoadingState { loading, success, error, ideal, empty }

enum VChatPushService { firebase, onesignal }

enum VNotificationActionRes { click, push }

enum VRoomTypingEnum { stop, typing, recording }

enum VStorageKeys {
  vAccessToken,
  vIsFirstRun,
  vAppMetaData,
  vAppLanguage,
  vClintVersion,
  vMyProfile,
  vAppTheme,
  vLastAppliedUpdate,
  vLastSuccessFetchRoomsTime,
  vIsLogin,
  vBaseUrl,
}

enum VAttachEnumRes { media, files, location }
