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
  String get messageHasBeenDeletedLabel {
    return Intl.message(
      'Message has been deleted',
      name: 'messageHasBeenDeletedLabel',
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
