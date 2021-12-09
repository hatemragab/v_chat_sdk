import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dto/create_group_room_dto.dart';
import 'dto/v_chat_login_dto.dart';
import 'dto/v_chat_register_dto.dart';
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
import 'sqlite/db_provider.dart';
import 'utils/api_utils/dio/v_chat_sdk_exception.dart';
import 'utils/api_utils/server_config.dart';
import 'utils/custom_widgets/create_single_chat_dialog.dart';
import 'utils/custom_widgets/custom_alert_dialog.dart';
import 'utils/storage_keys.dart';
import 'utils/helpers/helpers.dart';
import 'utils/translator/v_chat_lookup_string.dart';
import 'utils/v_chat_widgets_builder.dart';
import 'package:get_it/get_it.dart';
import 'package:crypto/crypto.dart';

///this is the controller of vchat
///which create the chat or customize the design
class VChatController {
  VChatController._privateConstructor();

  static final VChatController instance = VChatController._privateConstructor();

  final _vChatUsersApi = VChatProvider();

  final _authProvider = AuthProvider();

  final getIt = GetIt.instance;

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
    required bool isUseFirebase,
    VChatWidgetBuilder widgetsBuilder = const VChatWidgetBuilder(),
    required bool enableLogger,
    required String passwordHashKey,
    int maxMediaUploadSize = 50 * 1000 * 1000,
  }) async {
    ///init some service
    await VChatAppService.instance.init(isUseFirebase);
    await LocalStorageService.instance.init();
    final appService = VChatAppService.instance;

    ///set some constants
    appService.isUseFirebase = isUseFirebase;
    appService.appName = appName;
    ServerConfig.serverIp = baseUrl.toString();
    ServerConfig.maxMessageFileSize = maxMediaUploadSize;
    late bool enableLog;
    if (kReleaseMode) {
      enableLog = false;
    } else {
      enableLog = enableLogger;
    }
    appService.enableLog = enableLog;
    appService.passwordHashKey = passwordHashKey;
    appService.vcBuilder = widgetsBuilder;
  }

  /// to add new language to v chat
  void setLocaleMessages(
      {required String languageCode,
      String? countryCode,
      required VChatLookupString lookupMessages}) {
    try {
      if (countryCode == null) {
        VChatAppService.instance
            .setLocaleMessages(languageCode, lookupMessages);
      } else {
        VChatAppService.instance.setLocaleMessages(
            "${languageCode}_${countryCode.toUpperCase()}", lookupMessages);
      }
    } catch (err) {
      Helpers.vlog("you should call function after init v chat");
      throw "you should call function after init v chat";
    }
  }

  /// **throw** No internet connection
  Future<String> stopAllNotification(BuildContext context) async {
    if (VChatAppService.instance.isUseFirebase) {
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
    if (VChatAppService.instance.isUseFirebase) {
      final token = (await FirebaseMessaging.instance.getToken()).toString();
      return await _vChatUsersApi.updateUserFcmToken(token);
    } else {
      throw "you have to enable fire base for this project first";
    }
  }

  /// **throw** No internet connection
  Future updateUserName({required String name}) async {
    return await _vChatUsersApi.updateUserName(name: name);
  }

  /// **throw** File Not Found !
  /// **throw** No internet connection
  Future updateUserImage({required String imagePath}) async {
    return await _vChatUsersApi.updateUserImage(path: imagePath);
  }

  /// when you call this function the user will be online and can receive notification
  /// first you have to login or register in v chat other wise will throw Exception
  void bindChatControllers(
      {required BuildContext context, String? email}) async {
    if (VChatAppService.instance.vChatUser == null && email == null) {
      throw VChatSdkException(
        "You must login or register to v chat first if you migrate old users then send email parameter is required",
      );
    }

    if (VChatAppService.instance.vChatUser == null && email != null) {
      try {
        await login(context: context, email: email);
      } catch (err) {
        throw "Your Not found in vchat database please make sure you mirage the old users passwordhashKey must be the same on flutter and backend .env $err";
      }
      return;
    }
    if (!getIt.isRegistered<SocketService>()) {
      getIt.registerSingleton(SocketService());
    }

    NotificationService.instance.init(context);
    RoomCubit.instance;
  }

  /// **throw** User already in v chat data base
  /// **throw** No internet connection
  Future<VChatUser> register(
      {required BuildContext context, required VChatRegisterDto dto}) async {
    if (VChatAppService.instance.isUseFirebase) {
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
    dto.password = getHashedPassword(dto.email);
    final user = await _authProvider.register(dto);
    await _saveUser(user);
    VChatAppService.instance.vChatUser = user;
    await Future.delayed(Duration.zero);
    bindChatControllers(context: context);
    return user;
  }

  /// **throw** You cant start chat if you start chat your self
  /// **throw** Exception if peer Email Not in v chat Data base ! so first you must migrate all users
  /// **throw** No internet connection
  Future<dynamic> createSingleChat({
    required String peerEmail,
    required BuildContext context,
    String? titleTxt,
    String? createBtnTxt,
  }) async {
    final data = await _vChatUsersApi.checkIfThereRoom(peerEmail);

    if (data == false) {
      /// No rooms founded
      /// create new Room
      final res = await showDialog<String>(
        context: context,
        builder: (context) {
          return CreateSingleChatDialog(
            createBtnTxt: createBtnTxt,
            titleTxt: titleTxt,
          );
        },
      );
      if (res != null && res.isNotEmpty) {
        final data = await _vChatUsersApi.createNewSingleRoom(res, peerEmail);

        /// room has been created successfully
        await Future.delayed(const Duration(seconds: 1));
        _navigateToRoomMessage(
          data,
          context,
        );
      }
    } else {
      /// there are room open the chat page
      return await _navigateToRoomMessage(
        data,
        context,
      );
    }
  }

  Future<dynamic> _navigateToRoomMessage(
      dynamic data, BuildContext context) async {
    final room = VChatRoom.fromMap(data);

    RoomCubit.instance.currentRoomId = room.id;
    RoomCubit.instance.updateOneRoomInRamAndSort(room);

    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessageView(
          roomId: room.id,
        ),
      ),
    );
  }

  /// **throw** User not in v chat data base
  /// **throw** No internet connection
  Future<VChatUser> login(
      {required BuildContext context, required String email}) async {
    final dto = VChatLoginDto(email: email);
    if (VChatAppService.instance.isUseFirebase) {
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

    dto.password = getHashedPassword(dto.email);
    final user = await _authProvider.login(dto);
    await _saveUser(user);
    VChatAppService.instance.vChatUser = user;
    await Future.delayed(Duration.zero);
    bindChatControllers(context: context);
    return user;
  }

  String getHashedPassword(email) {
    return sha512
        .convert(
            utf8.encode(VChatAppService.instance.passwordHashKey + "_" + email))
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
        key: StorageKeys.kvChatMyModel, value: jsonEncode(user.toMap()));

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
    getIt.get<SocketService>().destroy();
    await getIt.unregister<SocketService>();
    const storage = FlutterSecureStorage();
    await storage.delete(key: StorageKeys.kvChatMyModel);
    VChatAppService.instance.vChatUser = null;
    await DBProvider.instance.reCreateTables();
    NotificationService.instance.cancelAll();
  }

  /// throw exception if path one user only or path one user he is the app login
  /// **throw** No internet connection
  Future<void> createGroupChat(
      {required BuildContext context,
      required CreateGroupRoomDto createGroupRoomDto}) async {
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
}
