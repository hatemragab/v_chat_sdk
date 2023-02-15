// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'i10n.dart';
import 'lang/en.dart';

abstract class VChatLocalizationLabels {
  const VChatLocalizationLabels();
  String get ok;
  String get cancel;
  String get yes;
  String get errorWhileDownloadFile;
  String get unsupportedPlatform;
  String get successfullyDownloadedIn;
  String get pleaseWait;
  String get search;
  String get updateTitleTo;
  String get updateImage;
  String get joinedBy;
  String get promotedToAdminBy;
  String get dismissedToMemberBy;
  String get leftTheGroup;
  String get kickedBy;
  String get groupCreatedBy;
  String get addedYouToNewBroadcast;
  String get connecting;
  String get delete;
  String get download;
  String get copy;
  String get info;
  String get share;
  String get forward;
  String get reply;
  String get deleteFromAll;
  String get deleteFromMe;
  String get downloading;
  String get fileHasBeenSavedTo;
  String get online;
  String get youDontHaveAccess;
  String get replyToYourSelf;
  String get forwarded;
  String get repliedToYourSelf;
  String get messageHasBeenDeleted;
  String get chooseRooms;
  String get mute;
  String get unMute;
  String get report;
  String get unBlock;
  String get block;
  String get leave;
  String get chatMuted;
  String get chatUnMuted;
  String get deleteYouCopy;
  String get areYouSureToPermitYourCopyThisActionCantUndo;
  String get blockThisUser;
  String get areYouSureToBlockThisUserCantSendMessageToYou;
  String get userBlocked;
  String get userUnBlocked;
  String get areYouSureToLeave;
  String get leaveGroupAndDeleteYourMessageCopy;
  String get groupLeft;
  String get typing;
  String get recording;
  String get shareFiles;
  String get media;
  String get shareLocation;
  String get shareMediaAndLocation;
  String get typeYourMessage;
  String get endtoendEncryption;
  String get exitFromTheCall;
  String get areYouSureToEndTheCall;
  String get messageInfo;
  String get read;
  String get delivered;
  String get chatMedia;
  String get busy;
  String get members;
  String get ring;
  String get roomAlreadyInCall;
  String get timeout;
  String get callEnd;
  String get rejected;
  String get videoCall;
  String get audioCall;
  String get canceled;
  String get inCall;
  String get makeCall;
  String get areYouWantToMakeVideoCall;
  String get areYouWantToMakeVoiceCall;
}

const localizations = <String, VChatLocalizationLabels>{
  'en': EnLocalizations(),
  'ar': ArLocalizations(),
};

class DefaultLocalizations extends EnLocalizations {
  const DefaultLocalizations();
}
