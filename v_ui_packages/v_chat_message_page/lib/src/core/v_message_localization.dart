import 'package:v_chat_input_ui/v_chat_input_ui.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

///labels available to translate
class VMessagesInfoTrans {
  /// The title to update to.
  final String updateTitleTo;

  /// The image to update to.
  final String updateImage;

  ///joined the group.
  final String joinedBy;

  /// The user who was promoted to admin.
  final String promotedToAdminBy;

  /// The user who was dismissed to member.
  final String dismissedToMemberBy;

  /// The user who left the group.
  final String leftTheGroup;

  /// The current user.
  final String you;

  /// The user who kicked the current user.
  final String kickedBy;

  /// The user who created the group.
  final String groupCreatedBy;

  /// The message when the current user is added to a new broadcast.
  final String addedYouToNewBroadcast;

  const VMessagesInfoTrans({
    required this.updateTitleTo,
    required this.updateImage,
    required this.joinedBy,
    required this.promotedToAdminBy,
    required this.dismissedToMemberBy,
    required this.leftTheGroup,
    required this.you,
    required this.kickedBy,
    required this.groupCreatedBy,
    required this.addedYouToNewBroadcast,
  });
  factory VMessagesInfoTrans.fromEnglish() {
    return const VMessagesInfoTrans(
      updateTitleTo: 'Update title to',
      updateImage: 'Update image',
      joinedBy: 'joined by',
      promotedToAdminBy: 'promoted to admin by',
      dismissedToMemberBy: 'dismissed to member by',
      leftTheGroup: 'left the group',
      you: 'You',
      kickedBy: 'kicked by',
      groupCreatedBy: 'Group created by',
      addedYouToNewBroadcast: 'added you to new broadcast',
    );
  }
}

/// This class is used to localize the messages in the chat room.
class VMessageLocalization {
  final String typing;
  final String recording;
  final String delete;
  final String download;
  final String copy;
  final String info;
  final String share;
  final String forward;
  final String reply;
  final String deleteFromAll;
  final String deleteFromMe;
  final String downloading;
  final String fileHasBeenSavedTo;
  final String search;
  final String unBlock;
  final String block;
  final String online;
  final String members;
  final String youDontHaveAccess;
  final String replyToYourSelf;
  final String repliedToYourSelf;
  final String messageHasBeenDeleted;
  final String audioCall;
  final String ring;
  final String canceled;
  final String timeout;
  final String rejected;
  final String finished;
  final String inCall;
  final String sessionEnd;
  final String yesterday;
  final String today;
  final String cancel;
  final VInputLanguage vInputLanguage;
  final String makeCall;
  final String areYouWantToMakeVideoCall;
  final String areYouWantToMakeVoiceCall;
  final String ok;
  final String connecting;
  final VMessagesInfoTrans vMessagesInfoTrans;

  String transCallStatus(VMessageCallStatus status) {
    switch (status) {
      case VMessageCallStatus.ring:
        return ring;
      case VMessageCallStatus.canceled:
        return canceled;
      case VMessageCallStatus.timeout:
        return timeout;
      case VMessageCallStatus.rejected:
        return rejected;
      case VMessageCallStatus.finished:
      case VMessageCallStatus.sessionEnd:
        return sessionEnd;
      case VMessageCallStatus.inCall:
        return inCall;
    }
  }

  const VMessageLocalization({
    required this.typing,
    required this.recording,
    required this.delete,
    required this.download,
    required this.copy,
    required this.info,
    required this.share,
    required this.forward,
    required this.reply,
    required this.deleteFromAll,
    required this.deleteFromMe,
    required this.downloading,
    required this.fileHasBeenSavedTo,
    required this.search,
    required this.unBlock,
    required this.block,
    required this.online,
    required this.members,
    required this.youDontHaveAccess,
    required this.replyToYourSelf,
    required this.repliedToYourSelf,
    required this.messageHasBeenDeleted,
    required this.audioCall,
    required this.ring,
    required this.canceled,
    required this.timeout,
    required this.rejected,
    required this.finished,
    required this.inCall,
    required this.sessionEnd,
    required this.yesterday,
    required this.today,
    required this.cancel,
    required this.vInputLanguage,
    required this.makeCall,
    required this.areYouWantToMakeVideoCall,
    required this.areYouWantToMakeVoiceCall,
    required this.ok,
    required this.connecting,
    required this.vMessagesInfoTrans,
  });

  factory VMessageLocalization.fromEnglish() {
    return VMessageLocalization(
      typing: 'Typing...',
      recording: 'Recording...',
      delete: 'Delete',
      download: 'Download',
      copy: 'Copy',
      info: 'Info',
      share: 'Share',
      forward: 'Forward',
      reply: 'Reply',
      deleteFromAll: 'Delete from all',
      deleteFromMe: 'Delete from me',
      downloading: 'Downloading...',
      fileHasBeenSavedTo: 'File has been saved to',
      search: 'Search',
      unBlock: 'Unblock',
      block: 'Block',
      online: 'Online',
      members: 'Members',
      youDontHaveAccess: 'You don\'t have access',
      replyToYourSelf: 'You cannot reply to yourself',
      repliedToYourSelf: 'You replied to yourself',
      messageHasBeenDeleted: 'This message has been deleted',
      audioCall: 'Audio call',
      ring: 'Ring',
      canceled: 'Canceled',
      timeout: 'Timeout',
      rejected: 'Rejected',
      finished: 'Finished',
      inCall: 'In call',
      sessionEnd: 'Session ended',
      yesterday: 'Yesterday',
      today: 'Today',
      cancel: 'Cancel',
      vInputLanguage: const VInputLanguage(),
      makeCall: 'Make a call',
      areYouWantToMakeVideoCall: 'Do you want to make a video call?',
      areYouWantToMakeVoiceCall: 'Do you want to make a voice call?',
      ok: 'OK',
      connecting: 'Connecting...',
      vMessagesInfoTrans: VMessagesInfoTrans.fromEnglish(),
    );
  }

//
}
