import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:v_chat_sdk/src/models/models.dart';

import 'dto/create_group_room_dto.dart';
import 'dto/v_chat_login_dto.dart';
import 'dto/v_chat_notification_settings.dart';
import 'dto/v_chat_register_dto.dart';
import 'enums/v_chat_notification_type.dart';
import 'models/v_chat_room.dart';
import 'models/v_chat_user.dart';
import 'modules/message/views/message_view.dart';
import 'modules/rooms/cubit/room_cubit.dart';
import 'services/auth_provider.dart';
import 'services/local_storage_service.dart';
import 'services/notification_service.dart';
import 'services/socket_service.dart';
import 'services/v_chat_app_service.dart';
import 'services/v_chat_provider.dart';
import 'services/v_chat_shared_preferences.dart';
import 'sqlite/db_provider.dart';
import 'utils/custom_widgets/custom_alert_dialog.dart';
import 'utils/helpers/helpers.dart';
import 'utils/storage_keys.dart';
import 'utils/v_chat_config.dart';
import 'utils/v_chat_widgets_builder.dart';

///this is the controller of vchat
///which create the chat or customize the design
class VChatController {
  VChatController._privateConstructor();

  static final VChatController instance = VChatController._privateConstructor();

  final _vChatUsersApi = VChatProvider();

  final _authProvider = AuthProvider();

  final _getIt = GetIt.instance;

  /// **baseUrl** v chat  backend base url
  /// **appName** your app name to because we create a file in phone internal storage to save files
  /// the folder in Documents/`appName`
  /// **isUseFirebase** if firebase not supported in your country or you not connect the app with firebase yet
  /// **lightTheme** define and override v_chat default Light theme
  /// **darkTheme** define and override v_chat default Dark theme
  /// **navKey** nav Key to get the context any where and support localization
  /// **maxMediaUploadSize** file videos images max size in byes   50 * 1000 * 1000 ~ 50mb
  Future init({
    required Uri baseUrl,
    required String appName,
    required VChatNotificationType vChatNotificationType,
    VChatNotificationSettings vChatNotificationSettings =
        const VChatNotificationSettings(),
    VChatWidgetBuilder widgetsBuilder = const VChatWidgetBuilder(),
    required bool enableLogger,
    required String passwordHashKey,
    int maxMediaUploadSize = 50 * 1000 * 1000,
    int maxGroupChatUsers = 512,
  }) async {
    ///init some service
    await VChatAppService.instance
        .init(vChatNotificationType: vChatNotificationType );
    await LocalStorageService.instance.init();
    final appService = VChatAppService.instance;

    ///set some constants
    appService.vChatNotificationType = vChatNotificationType;
    appService.vChatNotificationSettings = vChatNotificationSettings;
    appService.appName = appName;
    appService.maxGroupChatUsers = maxGroupChatUsers;
    VChatConfig.serverIp = baseUrl.toString();
    VChatConfig.maxMessageFileSize = maxMediaUploadSize;
    late bool enableLog;
    if (kReleaseMode) {
      enableLog = false;
    } else {
      enableLog = enableLogger;
    }
    appService.enableLog = enableLog;
    appService.passwordHashKey = passwordHashKey;
    appService.vcBuilder = widgetsBuilder;
    unawaited(_checkVersion());
  }

  /// to add new language to v chat
  void setLocaleMessages({
    required List<VChatAddLanguageModel> vChatAddLanguageModel,
  }) {
    for (final item in vChatAddLanguageModel) {
      try {
        if (item.countryCode == null) {
          VChatAppService.instance
              .setLocaleMessages(item.languageCode, item.lookupMessages);
        } else {
          VChatAppService.instance.setLocaleMessages(
            "${item.languageCode}_${item.countryCode!.toUpperCase()}",
            item.lookupMessages,
          );
        }
      } catch (err) {
        Helpers.vlog("you should call function after init v chat");
        throw "you should call function after init v chat";
      }
    }
  }

  /// **throw** No internet connection
  Future<String> stopAllNotification(BuildContext context) async {
    if (VChatAppService.instance.vChatNotificationType ==
        VChatNotificationType.firebase) {
      await FirebaseMessaging.instance.deleteToken();
      return VChatAppService.instance
          .getTrans(context)
          .notificationsHasBeenStoppedSuccessfully();
    } else {
      throw "you have to enable firebase for this project first";
    }
  }

  /// **throw** No internet connection
  Future<String> enableAllNotification() async {
    if (VChatAppService.instance.vChatNotificationType ==
        VChatNotificationType.firebase) {
      final token = (await FirebaseMessaging.instance.getToken()).toString();
      return _vChatUsersApi.updateUserFcmToken(token);
    } else {
      throw "you have to enable fire base for this project first";
    }
  }

  /// **throw** No internet connection
  Future updateUserName({required String name}) async {
    return _vChatUsersApi.updateUserName(name: name);
  }

  /// **throw** File Not Found !
  /// **throw** No internet connection
  Future updateUserImage({required String imagePath}) async {
    return _vChatUsersApi.updateUserImage(path: imagePath);
  }

  /// make sure you init v chat in the Home page of you app to start receive notifications
  /// when you call this function the user will be online and can receive notification
  /// first you have to login or register in v chat other wise will throw Exception
  Future<void> bindChatControllers({
    required BuildContext context,
    String? email,
  }) async {
    if (VChatAppService.instance.vChatUser == null && email == null) {
      return;
      // throw VChatSdkException(
      //   "You must login or register to v chat first if you migrate old users then send email parameter is required",
      // );
    }

    if (VChatAppService.instance.vChatUser == null && email != null) {
      try {
        await login(context: context, email: email);
      } catch (err) {
        throw "Your Not found in vchat database please make sure you mirage the old users passwordHash Key must be the same on flutter and backend .env $err";
      }
      return;
    }
    if (!_getIt.isRegistered<SocketService>()) {
      _getIt.registerSingleton(SocketService());
    }
    final preferences = SharedPrefsInstance.instance;
    final appLang = preferences.getString(StorageKeys.kvChatAppLanguage);
    if (appLang != null) {
      VChatAppService.instance.currentLocal = appLang;
      unawaited(_vChatUsersApi.updateUserLanguage(appLang));
    }
    NotificationService.instance.init(context);
    RoomCubit.instance.getInstance();
  }

  /// **throw** User already in v chat data base
  /// **throw** No internet connection
  Future<VChatUser> register({
    required BuildContext context,
    required VChatRegisterDto dto,
  }) async {
    if (VChatAppService.instance.vChatNotificationType ==
        VChatNotificationType.firebase) {
      dto.fcmToken = (await FirebaseMessaging.instance.getToken()).toString();
    } else {
      dto.fcmToken = "you don't use firebase on flutter app ";
    }
    if (Platform.isAndroid) {
      dto.platform = "Android";
    }
    if (Platform.isIOS) {
      dto.platform = "ios";
    }
    dto.password = _getHashedPassword(dto.email);
    final user = await _authProvider.register(dto);
    await _saveUser(user);
    VChatAppService.instance.vChatUser = user;
    await Future.delayed(Duration.zero);
    bindChatControllers(context: context);
    return user;
  }

  /// [context] if you pass the context the the chat will open after send message
  /// **throw** You cant start chat if you start chat your self
  /// **throw** Exception if peer Email Not in v chat Data base ! so first you must migrate all users
  /// **throw** No internet connection
  Future<String> createSingleChat({
    required String peerEmail,
    required String message,
    BuildContext? context,
  }) async {
    final roomData =
        await _vChatUsersApi.createNewSingleRoom(message, peerEmail);
    if (context != null) {
      final room = VChatRoom.fromMap(roomData);
      await LocalStorageService.instance.setRoomOrUpdate(room);
      RoomCubit.instance.updateOneRoomInRamAndSort(room);
      RoomCubit.instance.currentRoomId = room.id;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MessageView(
            roomId: room.id,
          ),
        ),
      );
    }

    return "Message has been send";
  }

  /// **throw** User not in v chat data base
  /// **throw** No internet connection
  Future<VChatUser> login({
    required BuildContext context,
    required String email,
  }) async {
    final dto = VChatLoginDto(email: email);
    if (VChatAppService.instance.vChatNotificationType ==
        VChatNotificationType.firebase) {
      dto.fcmToken = (await FirebaseMessaging.instance.getToken()).toString();
    } else {
      dto.fcmToken = "you don't use firebase on flutter app";
    }
    if (Platform.isAndroid) {
      dto.platform = "Android";
    }
    if (Platform.isIOS) {
      dto.platform = "Ios";
    }

    dto.password = _getHashedPassword(dto.email);
    final user = await _authProvider.login(dto);
    await _saveUser(user);
    VChatAppService.instance.vChatUser = user;
    await Future.delayed(Duration.zero);
    bindChatControllers(context: context);
    return user;
  }

  String _getHashedPassword(String email) {
    return sha512
        .convert(
          utf8.encode("${VChatAppService.instance.passwordHashKey}_$email"),
        )
        .toString();
  }

  ///Force language to the package
  ///i made this api for who use getx translate projects
  ///you must call this api any time you open the app
  void forceLanguage({required String languageCode, String? countryCode}) {
    return VChatAppService.instance
        .changeLanguage(languageCode: languageCode, countryCode: countryCode);
  }

  Future _saveUser(VChatUser user) async {
    const storage = FlutterSecureStorage();

    await storage.write(
      key: StorageKeys.kvChatMyModel,
      value: jsonEncode(user.toMap()),
    );

    VChatAppService.instance.vChatUser = user;
  }

  /// **throw** No internet connection
  Future logOut() async {
    try {
      await FirebaseMessaging.instance.deleteToken();
      await _vChatUsersApi.logOut();
    } catch (err) {
      //
    }
    _getIt.get<SocketService>().destroy();
    await _getIt.unregister<SocketService>();
    const storage = FlutterSecureStorage();
    await storage.delete(key: StorageKeys.kvChatMyModel);
    VChatAppService.instance.vChatUser = null;
    await DBProvider.instance.reCreateTables();
    NotificationService.instance.cancelAll();
  }

  /// throw exception if path one user only or path one user he is the app login
  /// **throw** No internet connection
  Future<void> createGroupChat({
    required BuildContext context,
    required CreateGroupRoomDto createGroupRoomDto,
  }) async {
    final data = await _vChatUsersApi.createNewGroupRoom(
      dto: createGroupRoomDto,
    );

    RoomCubit.instance.updateOneRoomInRamAndSort(VChatRoom.fromMap(data));
    CustomAlert.done(
      context: context,
      msg: VChatAppService.instance
          .getTrans(context)
          .groupChatHasBeenCreatedSuccessful(),
    );

    /// room has been created successfully
    //await Future.delayed(const Duration(seconds: 2));
    // _navigateToRoomMessage(
    //   data,
    //   context,
    // );
  }

  /// throw exception if group not exist or current user not in group
  /// **throw** No internet connection
  Future<List<VChatGroupUser>> getGroupMembers({
    required String groupId,
    required int paginationIndex,
  }) async {
    final members = await _vChatUsersApi.getRoomMembers(
      groupId: groupId,
      paginationIndex: paginationIndex,
    );
    return members;
  }

  /// throw exception if group not exist or current user not in group and current user not admin
  /// **throw** No internet connection
  Future<void> updateGroupChatTitle({
    required String groupId,
    required String title,
  }) async {
    await _vChatUsersApi.updateGroupTitle(groupId: groupId, title: title);
  }

  /// throw exception if group not exist or current user not in group and current user not admin
  /// **throw** No internet connection
  Future<String> updateGroupChatImage({
    required String groupId,
    required String path,
  }) async {
    return _vChatUsersApi.updateGroupImage(groupId: groupId, path: path);
  }

  /// will delete user from group only if this user in the group
  /// and current current user is admin
  /// admin can delete admin but cant delete the group creator
  /// group creator can delete any user but cant be deleted
  /// throw exception if current user not admin or if kick the group creator of kick your self be aware !
  /// **throw** No internet connection
  Future kickUserFromGroup({
    required String groupId,
    required String kickedId,
  }) async {
    return _vChatUsersApi.kickUserFromGroup(
      groupId: groupId,
      kickedId: kickedId,
    );
  }

  /// throw exception if current user not admin or if downgrade the group creator members cant downgrade admins
  /// **throw** No internet connection
  Future downgradeGroupAdmin({
    required String groupId,
    required String userId,
  }) async {
    return _vChatUsersApi.downGradeUserFromGroup(
      groupId: groupId,
      userId: userId,
    );
  }

  /// throw exception if current user not admin
  /// **throw** No internet connection
  Future upgradeGroupUser({
    required String groupId,
    required String userId,
  }) async {
    return _vChatUsersApi.upgradeUserFromGroup(
      groupId: groupId,
      userId: userId,
    );
  }

  /// throw exception if current user not admin
  /// **throw** No internet connection
  Future addMembersToGroupChat({
    required String groupId,
    required List<String> usersEmails,
  }) async {
    return _vChatUsersApi.addMembersToGroupChat(
      groupId: groupId,
      usersEmails: usersEmails,
    );
  }

  /// **throw** No internet connection
  Future changeLanguage(String lng) async {
    VChatAppService.instance.currentLocal = lng;
    await SharedPrefsInstance.instance
        .setString(StorageKeys.kvChatAppLanguage, lng);
    await _vChatUsersApi.updateUserLanguage(lng);
  }

  Future<void> _checkVersion() async {
    await SharedPrefsInstance.init();
    final preferences = SharedPrefsInstance.instance;
    final v = preferences.getBool(StorageKeys.kvChatFirstTimeOpen);

    if (v != null && v) {
      /// Not first time to open the app

    } else {
      /// first time to open the app
      await preferences.setBool(StorageKeys.kvChatFirstTimeOpen, true);
      await SharedPrefsInstance.setDefaultVersionValues();
    }
  }
}
