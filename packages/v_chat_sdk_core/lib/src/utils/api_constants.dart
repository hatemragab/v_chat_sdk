import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

abstract class AppConstants {
  static String mapsApiKey = "mapsApiKeymapsApiKey";

  const AppConstants._();

  static String clintVersion = "2.0.0";
  static const appName = "VChatSdkV2";
  static const dbName = "VChatSdkV2.db";
  static const dbVersion = 1;
  static const socketInterval = 10; //10sec
  static String get baseServerIp {
    final uri = VChatController.I.config.baseUrl;
    if (uri.hasPort) {
      return "${uri.scheme}://${uri.host}:${uri.port}";
    }
    return "${uri.scheme}://${uri.host}";
  }

  static int get maxMediaSize {
    return VChatController.I.config.maxMediaUploadSize;
  }

  static String get baseUrl {
    return "$baseServerIp/api/v2";
  }

  static String get getMediaBaseUrl {
    final s3BucketUrl = VChatController.I.config.s3BucketUrl;
    if (s3BucketUrl != null) {
      return s3BucketUrl;
    }
    return "$baseUrl/public/";
  }

  static VIdentifierUser get myProfile {
    final map = VAppPref.getMap(StorageKeys.vMyProfile);
    if (map == null) {
      throw VChatDartException(
        exception:
            "You try to get myProfile from cache but it value is NULL! please make sure you are login!",
      );
    }
    return VIdentifierUser.fromMap(
      map,
    );
  }

  static VIdentifierUser get fakeMyProfile {
    return VIdentifierUser(
        identifier: "FAKE identifier", baseUser: VBaseUser.fromFakeData());
  }

  static String get myId {
    return myProfile.baseUser.vChatId;
  }

  static String get myIdentifier {
    return myProfile.identifier;
  }

  static String get sdkLanguage =>
      VAppPref.getStringOrNull(StorageKeys.appLanguage) ?? "en";

  static String getMessageBody(VBaseMessage m) {
    return m.content;
    //
    //   if (m.isInfo) {
    //     final MsgInfoAtt infoAtt = (m as InfoMessage).infoAtt;
    //     switch (infoAtt.action) {
    //       case MessageInfoType.updateTitle:
    //         return "${infoAtt.adminName} ${S.of(context).updateTitleTo} ${infoAtt.targetName}";
    //       case MessageInfoType.updateImage:
    //         return "${infoAtt.adminName} ${S.of(context).updateImage}";
    //       case MessageInfoType.addGroupMember:
    //         return "${infoAtt.targetName} ${S.of(context).joinedBy} ${infoAtt.adminName}";
    //       case MessageInfoType.upAdmin:
    //         return "${infoAtt.targetName} ${S.of(context).promotedToAdminBy} ${infoAtt.adminName}";
    //       case MessageInfoType.downMember:
    //         return "${infoAtt.targetName} ${S.of(context).dismissedToMemberBy} ${infoAtt.adminName}";
    //       case MessageInfoType.leave:
    //         return "${infoAtt.targetName} ${S.of(context).leftTheGroup}";
    //       case MessageInfoType.kick:
    //         if (infoAtt.isMe) {
    //           return "You ${S.of(context).kickedBy} ${infoAtt.adminName}";
    //         }
    //         return "${infoAtt.targetName} ${S.of(context).kickedBy} ${infoAtt.adminName}";
    //       case MessageInfoType.createGroup:
    //         return "${S.of(context).groupCreatedBy} ${infoAtt.adminName}";
    //
    //       case MessageInfoType.addToBroadcast:
    //         return "${infoAtt.adminName} ${S.of(context).addedYouToNewBroadcast} ${infoAtt.targetName}";
    //
    //     }
    //   }
    //   if (m.isImage) {
    //     return S.current.thisContentIsPhoto;
    //   }
    //   if (m.isVoice) {
    //     return S.current.thisContentIsVoice;
    //   }
    //   if (m.isVideo) {
    //     return S.current.thisContentVideo;
    //   }
    //   if (m.isFile) {
    //     return S.current.thisContentFile;
    //   }
    //   if (m.isLocation) {
    //     return S.current.location;
    //   }
    //   if (m.isTrans) {
    //     return m.contentTr!;
    //   }
    //   return m.content;
  }

  static const String heart = "\u{2764}";
  static const String faceWithTears = "\u{1F602}";
  static const String disappointedFace = "\u{1F625}";
  static const String angryFace = "\u{1F621}";
  static const String astonishedFace = "\u{1F632}";
  static const String thumbsUp = "\u{1F44D}";

  static const thisContentIsFile = "This content is file";
  static const thisContentIsVoice = "This content is voice";
  static const thisContentIsImage = "This content is image";
  static const thisContentIsVideo = "This content is video";
  static const thisContentIsLocation = "This content is location";
}
