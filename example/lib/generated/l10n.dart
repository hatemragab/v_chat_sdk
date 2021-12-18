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

  /// `test`
  String get test {
    return Intl.message(
      'test',
      name: 'test',
      desc: '',
      args: [],
    );
  }

  /// `offline`
  String get offline {
    return Intl.message(
      'offline',
      name: 'offline',
      desc: '',
      args: [],
    );
  }

  /// `My great rooms`
  String get myGreatRooms {
    return Intl.message(
      'My great rooms',
      name: 'myGreatRooms',
      desc: '',
      args: [],
    );
  }

  /// `This data from my server not vchat`
  String get thisDataFromMyServerNotVchat {
    return Intl.message(
      'This data from my server not vchat',
      name: 'thisDataFromMyServerNotVchat',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Chats`
  String get chats {
    return Intl.message(
      'Chats',
      name: 'chats',
      desc: '',
      args: [],
    );
  }

  /// `login`
  String get login {
    return Intl.message(
      'login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `choose image`
  String get chooseImage {
    return Intl.message(
      'choose image',
      name: 'chooseImage',
      desc: '',
      args: [],
    );
  }

  /// `Change language`
  String get changeLanguage {
    return Intl.message(
      'Change language',
      name: 'changeLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Change Theme`
  String get changeTheme {
    return Intl.message(
      'Change Theme',
      name: 'changeTheme',
      desc: '',
      args: [],
    );
  }

  /// `Update profile`
  String get updateProfile {
    return Intl.message(
      'Update profile',
      name: 'updateProfile',
      desc: '',
      args: [],
    );
  }

  /// `On`
  String get on {
    return Intl.message(
      'On',
      name: 'on',
      desc: '',
      args: [],
    );
  }

  /// `All Chat notifications`
  String get allChatNotifications {
    return Intl.message(
      'All Chat notifications',
      name: 'allChatNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Off`
  String get off {
    return Intl.message(
      'Off',
      name: 'off',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get message {
    return Intl.message(
      'Message',
      name: 'message',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get ok {
    return Intl.message(
      'Ok',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get logOut {
    return Intl.message(
      'Log out',
      name: 'logOut',
      desc: '',
      args: [],
    );
  }

  /// `light`
  String get light {
    return Intl.message(
      'light',
      name: 'light',
      desc: '',
      args: [],
    );
  }

  /// `dark`
  String get dark {
    return Intl.message(
      'dark',
      name: 'dark',
      desc: '',
      args: [],
    );
  }

  /// `ar`
  String get ar {
    return Intl.message(
      'ar',
      name: 'ar',
      desc: '',
      args: [],
    );
  }

  /// `en`
  String get en {
    return Intl.message(
      'en',
      name: 'en',
      desc: '',
      args: [],
    );
  }

  /// `Remove your self from the list your name is`
  String get removeYourSelfFromTheListYourNameIs {
    return Intl.message(
      'Remove your self from the list your name is',
      name: 'removeYourSelfFromTheListYourNameIs',
      desc: '',
      args: [],
    );
  }

  /// `select at lest one user`
  String get selectAtLestOneUser {
    return Intl.message(
      'select at lest one user',
      name: 'selectAtLestOneUser',
      desc: '',
      args: [],
    );
  }

  /// `choose members`
  String get chooseMembers {
    return Intl.message(
      'choose members',
      name: 'chooseMembers',
      desc: '',
      args: [],
    );
  }

  /// `Choose group image`
  String get chooseGroupImage {
    return Intl.message(
      'Choose group image',
      name: 'chooseGroupImage',
      desc: '',
      args: [],
    );
  }

  /// `image size must be less than 20 Mb`
  String get imageSizeMustBeLessThan20Mb {
    return Intl.message(
      'image size must be less than 20 Mb',
      name: 'imageSizeMustBeLessThan20Mb',
      desc: '',
      args: [],
    );
  }

  /// `image has been selected`
  String get imageHasBeenSelected {
    return Intl.message(
      'image has been selected',
      name: 'imageHasBeenSelected',
      desc: '',
      args: [],
    );
  }

  /// `Group Name`
  String get groupName {
    return Intl.message(
      'Group Name',
      name: 'groupName',
      desc: '',
      args: [],
    );
  }

  /// `Create Group !`
  String get createGroup {
    return Intl.message(
      'Create Group !',
      name: 'createGroup',
      desc: '',
      args: [],
    );
  }

  /// `Users has been added successfully`
  String get usersHasBeenAddedSuccessfully {
    return Intl.message(
      'Users has been added successfully',
      name: 'usersHasBeenAddedSuccessfully',
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

  /// `Title`
  String get title {
    return Intl.message(
      'Title',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `cancel`
  String get cancel {
    return Intl.message(
      'cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'copiedToYourClipboard data' key

  /// `Contact me on whatsapp`
  String get contactMeOnWhatsapp {
    return Intl.message(
      'Contact me on whatsapp',
      name: 'contactMeOnWhatsapp',
      desc: '',
      args: [],
    );
  }

  /// `Are you have question ?`
  String get areYouHaveQuestion {
    return Intl.message(
      'Are you have question ?',
      name: 'areYouHaveQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Code private and Group Chat with v chat its very easy !`
  String get codePrivateAndGroupChatWithVChatItsVery {
    return Intl.message(
      'Code private and Group Chat with v chat its very easy !',
      name: 'codePrivateAndGroupChatWithVChatItsVery',
      desc: '',
      args: [],
    );
  }

  /// `v chat users`
  String get vChatUsers {
    return Intl.message(
      'v chat users',
      name: 'vChatUsers',
      desc: '',
      args: [],
    );
  }

  /// `image has been set successfully`
  String get imageHasBeenSetSuccessfully {
    return Intl.message(
      'image has been set successfully',
      name: 'imageHasBeenSetSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Our Full Documentation`
  String get ourFullDocumentation {
    return Intl.message(
      'Our Full Documentation',
      name: 'ourFullDocumentation',
      desc: '',
      args: [],
    );
  }

  /// `Buy the backend code`
  String get buyTheBackendCode {
    return Intl.message(
      'Buy the backend code',
      name: 'buyTheBackendCode',
      desc: '',
      args: [],
    );
  }

  /// `ios testflight and public flutter ui`
  String get iosTestflightAndPublicFlutterUi {
    return Intl.message(
      'ios testflight and public flutter ui',
      name: 'iosTestflightAndPublicFlutterUi',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us And Report issues or new features`
  String get contactUsAndReportIssuesOrNewFeatures {
    return Intl.message(
      'Contact Us And Report issues or new features',
      name: 'contactUsAndReportIssuesOrNewFeatures',
      desc: '',
      args: [],
    );
  }

  /// `splash screen`
  String get splashScreen {
    return Intl.message(
      'splash screen',
      name: 'splashScreen',
      desc: '',
      args: [],
    );
  }

  /// `update image`
  String get updateImage {
    return Intl.message(
      'update image',
      name: 'updateImage',
      desc: '',
      args: [],
    );
  }

  /// `new name`
  String get newName {
    return Intl.message(
      'new name',
      name: 'newName',
      desc: '',
      args: [],
    );
  }

  /// `update name`
  String get updateName {
    return Intl.message(
      'update name',
      name: 'updateName',
      desc: '',
      args: [],
    );
  }

  /// `Enter the name`
  String get enterTheName {
    return Intl.message(
      'Enter the name',
      name: 'enterTheName',
      desc: '',
      args: [],
    );
  }

  /// `your name has been updated !`
  String get yourNameHasBeenUpdated {
    return Intl.message(
      'your name has been updated !',
      name: 'yourNameHasBeenUpdated',
      desc: '',
      args: [],
    );
  }

  /// `your image has been updated !`
  String get yourImageHasBeenUpdated {
    return Intl.message(
      'your image has been updated !',
      name: 'yourImageHasBeenUpdated',
      desc: '',
      args: [],
    );
  }

  /// `User name`
  String get userName {
    return Intl.message(
      'User name',
      name: 'userName',
      desc: '',
      args: [],
    );
  }

  /// `Loading ...`
  String get loading {
    return Intl.message(
      'Loading ...',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `success`
  String get success {
    return Intl.message(
      'success',
      name: 'success',
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
      Locale.fromSubtags(languageCode: 'ar', countryCode: 'EG'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'pt', countryCode: 'BR'),
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
