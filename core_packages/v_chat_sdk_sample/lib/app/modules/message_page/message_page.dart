import 'package:flutter/material.dart';
import 'package:v_chat_message_page/v_chat_message_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../generated/l10n.dart';

class MyProjectMessagePageWrapper extends StatelessWidget {
  final VRoom room;

  const MyProjectMessagePageWrapper({
    Key? key,
    required this.room,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VMessagePage(
      vRoom: room,
      localization: VMessageLocalization(
        youDontHaveAccess: S.of(context).youDontHaveAccess,
        replyToYourSelf: S.of(context).replyToYourSelf,
        repliedToYourSelf: S.of(context).repliedToYourSelf,
        yesterday: S.of(context).yesterday,
        today: S.of(context).today,
        areYouWantToMakeVideoCall: S.of(context).areYouWantToMakeVideoCall,
        areYouWantToMakeVoiceCall: S.of(context).areYouWantToMakeVideoCall,
        audioCall: S.of(context).audioCall,
        block: S.of(context).block,
        cancel: S.of(context).cancel,
        canceled: S.of(context).canceled,
        connecting: S.of(context).connecting,
        copy: S.of(context).copy,
        delete: S.of(context).delete,
        deleteFromAll: S.of(context).deleteFromAll,
        deleteFromMe: S.of(context).deleteFromMe,
        download: S.of(context).download,
        downloading: S.of(context).downloading,
        fileHasBeenSavedTo: S.of(context).fileHasBeenSavedTo,
        finished: S.of(context).finished,
        forward: S.of(context).forward,
        inCall: S.of(context).inCall,
        info: S.of(context).info,
        makeCall: S.of(context).makeCall,
        members: S.of(context).members,
        messageHasBeenDeleted: S.of(context).messageHasBeenDeleted,
        ok: S.of(context).ok,
        online: S.of(context).online,
        reply: S.of(context).reply,
        ring: S.of(context).ring,
        search: S.of(context).search,
        sessionEnd: S.of(context).sessionEnd,
        share: S.of(context).share,
        timeout: S.of(context).timeout,
        typing: S.of(context).typing,
        unBlock: S.of(context).unBlock,
        vInputLanguage: VInputLanguage(
          cancel: S.of(context).cancel,
          files: S.of(context).files,
          shareMediaAndLocation: S.of(context).shareMediaAndLocation,
          textFieldHint: S.of(context).textFieldHint,
          thereIsFileHasSizeBiggerThanAllowedSize:
              S.of(context).thereIsFileHasSizeBiggerThanAllowedSize,
          thereIsVideoSizeBiggerThanAllowedSize:
              S.of(context).thereIsVideoSizeBiggerThanAllowedSize,
          location: S.of(context).location,
          media: S.of(context).media,
        ),
        recording: S.of(context).recording,
        rejected: S.of(context).rejected,
        vMessagesInfoTrans: VMessagesInfoTrans(
          updateTitleTo: S.of(context).updateTitleTo,
          updateImage: S.of(context).updateImage,
          promotedToAdminBy: S.of(context).promotedToAdminBy,
          leftTheGroup: S.of(context).leftTheGroup,
          kickedBy: S.of(context).kickedBy,
          joinedBy: S.of(context).joinedBy,
          groupCreatedBy: S.of(context).groupCreatedBy,
          dismissedToMemberBy: S.of(context).dismissedToMemberBy,
          addedYouToNewBroadcast: S.of(context).addedYouToNewBroadcast,
          you: S.of(context).you,
        ),
      ),
      vMessageConfig: VMessageConfig(
        googleMapsApiKey: "AzoisfXXXXXXXXXXXX",
        isCallsAllowed: true,
      ),
    );
  }
}
