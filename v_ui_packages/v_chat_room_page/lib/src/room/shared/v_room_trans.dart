///labels available to translate
class VMessageInfoTrans {
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

  const VMessageInfoTrans({
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

  factory VMessageInfoTrans.fromEnglish() {
    return const VMessageInfoTrans(
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

///room language
class VRoomLanguage {
  final String yesterdayLabel;
  final String messageHasBeenDeletedLabel;
  final String connecting;

  ///
  final String mute;
  final String typing;
  final String recording;
  final String cancel;
  final String deleteYouCopy;
  final String ok;
  final String unMute;
  final String delete;
  final String report;
  final String leaveGroup;

  final String areYouSureToPermitYourCopyThisActionCantUndo;
  final String areYouSureToLeaveThisGroupThisActionCantUndo;
  final String leaveGroupAndDeleteYourMessageCopy;
  final VMessageInfoTrans vMessageInfoTrans;

  ///

  const VRoomLanguage({
    required this.yesterdayLabel,
    required this.messageHasBeenDeletedLabel,
    required this.mute,
    required this.cancel,
    required this.typing,
    required this.ok,
    required this.recording,
    required this.connecting,
    required this.deleteYouCopy,
    required this.unMute,
    required this.delete,
    required this.report,
    required this.leaveGroup,
    required this.areYouSureToPermitYourCopyThisActionCantUndo,
    required this.areYouSureToLeaveThisGroupThisActionCantUndo,
    required this.leaveGroupAndDeleteYourMessageCopy,
    required this.vMessageInfoTrans,
  });

  factory VRoomLanguage.fromEnglish() {
    return VRoomLanguage(
      yesterdayLabel: 'Yesterday',
      messageHasBeenDeletedLabel: 'Message has been deleted',
      mute: 'Mute',
      cancel: 'Cancel',
      ok: 'Ok',
      connecting: 'Connecting...',
      deleteYouCopy: 'Delete',
      unMute: 'Un mute',
      delete: 'Delete',
      report: 'Report',
      typing: 'Typing...',
      recording: 'Recording',
      leaveGroup: 'Leave Group',
      areYouSureToPermitYourCopyThisActionCantUndo:
          'Are you sure to permit your copy? This action can\'t undo',
      areYouSureToLeaveThisGroupThisActionCantUndo:
          'Are you sure to leave this group? This action can\'t undo',
      leaveGroupAndDeleteYourMessageCopy:
          'Leave group and delete your message copy',
      vMessageInfoTrans: VMessageInfoTrans.fromEnglish(),
    );
  }
}
