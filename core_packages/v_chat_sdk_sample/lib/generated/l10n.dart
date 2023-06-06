// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Hi`
  String get hi {
    return Intl.message(
      'Hi',
      name: 'hi',
      desc: '',
      args: [],
    );
  }

  /// `yesterday`
  String get yesterdayLabel {
    return Intl.message(
      'yesterday',
      name: 'yesterdayLabel',
      desc: '',
      args: [],
    );
  }

  /// `Message has been deleted`
  String get messageHasBeenDeleted {
    return Intl.message(
      'Message has been deleted',
      name: 'messageHasBeenDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Mute`
  String get mute {
    return Intl.message(
      'Mute',
      name: 'mute',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `typing...`
  String get typing {
    return Intl.message(
      'typing...',
      name: 'typing',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Recording...`
  String get recording {
    return Intl.message(
      'Recording...',
      name: 'recording',
      desc: '',
      args: [],
    );
  }

  /// `Connecting...`
  String get connecting {
    return Intl.message(
      'Connecting...',
      name: 'connecting',
      desc: '',
      args: [],
    );
  }

  /// `Delete your copy`
  String get deleteYouCopy {
    return Intl.message(
      'Delete your copy',
      name: 'deleteYouCopy',
      desc: '',
      args: [],
    );
  }

  /// `Unmute`
  String get unMute {
    return Intl.message(
      'Unmute',
      name: 'unMute',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Report`
  String get report {
    return Intl.message(
      'Report',
      name: 'report',
      desc: '',
      args: [],
    );
  }

  /// `Leave group`
  String get leaveGroup {
    return Intl.message(
      'Leave group',
      name: 'leaveGroup',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to permit your copy? This action can't undo`
  String get areYouSureToPermitYourCopyThisActionCantUndo {
    return Intl.message(
      'Are you sure to permit your copy? This action can\'t undo',
      name: 'areYouSureToPermitYourCopyThisActionCantUndo',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to leave this group? This action can't undo`
  String get areYouSureToLeaveThisGroupThisActionCantUndo {
    return Intl.message(
      'Are you sure to leave this group? This action can\'t undo',
      name: 'areYouSureToLeaveThisGroupThisActionCantUndo',
      desc: '',
      args: [],
    );
  }

  /// `Leave group and delete your message copy`
  String get leaveGroupAndDeleteYourMessageCopy {
    return Intl.message(
      'Leave group and delete your message copy',
      name: 'leaveGroupAndDeleteYourMessageCopy',
      desc: '',
      args: [],
    );
  }

  /// `Message info`
  String get vMessageInfoTrans {
    return Intl.message(
      'Message info',
      name: 'vMessageInfoTrans',
      desc: '',
      args: [],
    );
  }

  /// `Update title to`
  String get updateTitleTo {
    return Intl.message(
      'Update title to',
      name: 'updateTitleTo',
      desc: '',
      args: [],
    );
  }

  /// `Update image`
  String get updateImage {
    return Intl.message(
      'Update image',
      name: 'updateImage',
      desc: '',
      args: [],
    );
  }

  /// `joined by`
  String get joinedBy {
    return Intl.message(
      'joined by',
      name: 'joinedBy',
      desc: '',
      args: [],
    );
  }

  /// `promoted to admin by`
  String get promotedToAdminBy {
    return Intl.message(
      'promoted to admin by',
      name: 'promotedToAdminBy',
      desc: '',
      args: [],
    );
  }

  /// `dismissed to member by`
  String get dismissedToMemberBy {
    return Intl.message(
      'dismissed to member by',
      name: 'dismissedToMemberBy',
      desc: '',
      args: [],
    );
  }

  /// `left the group`
  String get leftTheGroup {
    return Intl.message(
      'left the group',
      name: 'leftTheGroup',
      desc: '',
      args: [],
    );
  }

  /// `You`
  String get you {
    return Intl.message(
      'You',
      name: 'you',
      desc: '',
      args: [],
    );
  }

  /// `kicked by`
  String get kickedBy {
    return Intl.message(
      'kicked by',
      name: 'kickedBy',
      desc: '',
      args: [],
    );
  }

  /// `Group created by`
  String get groupCreatedBy {
    return Intl.message(
      'Group created by',
      name: 'groupCreatedBy',
      desc: '',
      args: [],
    );
  }

  /// `added you to new broadcast`
  String get addedYouToNewBroadcast {
    return Intl.message(
      'added you to new broadcast',
      name: 'addedYouToNewBroadcast',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the ':-----' key

  /// `Download`
  String get download {
    return Intl.message(
      'Download',
      name: 'download',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get copy {
    return Intl.message(
      'Copy',
      name: 'copy',
      desc: '',
      args: [],
    );
  }

  /// `Info`
  String get info {
    return Intl.message(
      'Info',
      name: 'info',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Forward`
  String get forward {
    return Intl.message(
      'Forward',
      name: 'forward',
      desc: '',
      args: [],
    );
  }

  /// `Reply`
  String get reply {
    return Intl.message(
      'Reply',
      name: 'reply',
      desc: '',
      args: [],
    );
  }

  /// `Delete from all`
  String get deleteFromAll {
    return Intl.message(
      'Delete from all',
      name: 'deleteFromAll',
      desc: '',
      args: [],
    );
  }

  /// `Delete from me`
  String get deleteFromMe {
    return Intl.message(
      'Delete from me',
      name: 'deleteFromMe',
      desc: '',
      args: [],
    );
  }

  /// `Downloading...`
  String get downloading {
    return Intl.message(
      'Downloading...',
      name: 'downloading',
      desc: '',
      args: [],
    );
  }

  /// `File has been saved to`
  String get fileHasBeenSavedTo {
    return Intl.message(
      'File has been saved to',
      name: 'fileHasBeenSavedTo',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Unblock`
  String get unBlock {
    return Intl.message(
      'Unblock',
      name: 'unBlock',
      desc: '',
      args: [],
    );
  }

  /// `Block`
  String get block {
    return Intl.message(
      'Block',
      name: 'block',
      desc: '',
      args: [],
    );
  }

  /// `Online`
  String get online {
    return Intl.message(
      'Online',
      name: 'online',
      desc: '',
      args: [],
    );
  }

  /// `Members`
  String get members {
    return Intl.message(
      'Members',
      name: 'members',
      desc: '',
      args: [],
    );
  }

  /// `You don't have access`
  String get youDontHaveAccess {
    return Intl.message(
      'You don\'t have access',
      name: 'youDontHaveAccess',
      desc: '',
      args: [],
    );
  }

  /// `Reply to your self`
  String get replyToYourSelf {
    return Intl.message(
      'Reply to your self',
      name: 'replyToYourSelf',
      desc: '',
      args: [],
    );
  }

  /// `Replied to your self`
  String get repliedToYourSelf {
    return Intl.message(
      'Replied to your self',
      name: 'repliedToYourSelf',
      desc: '',
      args: [],
    );
  }

  /// `Audio call`
  String get audioCall {
    return Intl.message(
      'Audio call',
      name: 'audioCall',
      desc: '',
      args: [],
    );
  }

  /// `Ring`
  String get ring {
    return Intl.message(
      'Ring',
      name: 'ring',
      desc: '',
      args: [],
    );
  }

  /// `Canceled`
  String get canceled {
    return Intl.message(
      'Canceled',
      name: 'canceled',
      desc: '',
      args: [],
    );
  }

  /// `Timeout`
  String get timeout {
    return Intl.message(
      'Timeout',
      name: 'timeout',
      desc: '',
      args: [],
    );
  }

  /// `Rejected`
  String get rejected {
    return Intl.message(
      'Rejected',
      name: 'rejected',
      desc: '',
      args: [],
    );
  }

  /// `Finished`
  String get finished {
    return Intl.message(
      'Finished',
      name: 'finished',
      desc: '',
      args: [],
    );
  }

  /// `In call`
  String get inCall {
    return Intl.message(
      'In call',
      name: 'inCall',
      desc: '',
      args: [],
    );
  }

  /// `Session end`
  String get sessionEnd {
    return Intl.message(
      'Session end',
      name: 'sessionEnd',
      desc: '',
      args: [],
    );
  }

  /// `Yesterday`
  String get yesterday {
    return Intl.message(
      'Yesterday',
      name: 'yesterday',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message(
      'Today',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `Type a message`
  String get textFieldHint {
    return Intl.message(
      'Type a message',
      name: 'textFieldHint',
      desc: '',
      args: [],
    );
  }

  /// `Media`
  String get media {
    return Intl.message(
      'Media',
      name: 'media',
      desc: '',
      args: [],
    );
  }

  /// `Files`
  String get files {
    return Intl.message(
      'Files',
      name: 'files',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message(
      'Location',
      name: 'location',
      desc: '',
      args: [],
    );
  }

  /// `Share media and location`
  String get shareMediaAndLocation {
    return Intl.message(
      'Share media and location',
      name: 'shareMediaAndLocation',
      desc: '',
      args: [],
    );
  }

  /// `There is video size bigger than allowed size`
  String get thereIsVideoSizeBiggerThanAllowedSize {
    return Intl.message(
      'There is video size bigger than allowed size',
      name: 'thereIsVideoSizeBiggerThanAllowedSize',
      desc: '',
      args: [],
    );
  }

  /// `There is file has size bigger than allowed size`
  String get thereIsFileHasSizeBiggerThanAllowedSize {
    return Intl.message(
      'There is file has size bigger than allowed size',
      name: 'thereIsFileHasSizeBiggerThanAllowedSize',
      desc: '',
      args: [],
    );
  }

  /// `Make call`
  String get makeCall {
    return Intl.message(
      'Make call',
      name: 'makeCall',
      desc: '',
      args: [],
    );
  }

  /// `Are you want to make video call?`
  String get areYouWantToMakeVideoCall {
    return Intl.message(
      'Are you want to make video call?',
      name: 'areYouWantToMakeVideoCall',
      desc: '',
      args: [],
    );
  }

  /// `Are you want to make voice call?`
  String get areYouWantToMakeVoiceCall {
    return Intl.message(
      'Are you want to make voice call?',
      name: 'areYouWantToMakeVoiceCall',
      desc: '',
      args: [],
    );
  }

  /// `Messages info`
  String get vMessagesInfoTrans {
    return Intl.message(
      'Messages info',
      name: 'vMessagesInfoTrans',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
