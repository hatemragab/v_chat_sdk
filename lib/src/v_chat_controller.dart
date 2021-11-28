import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
import 'utils/storage_keys.dart';
import 'utils/helpers/helpers.dart';
import 'utils/translator/v_chat_lookup_string.dart';
import 'utils/v_chat_widgets_builder.dart';
import 'package:get_it/get_it.dart';

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

  /// **throw** No internet connection
  Future updateUserPassword(
      {required String oldPassword, required String newPassword}) async {
    return await _vChatUsersApi.updateUserPassword(
        oldPassword: oldPassword, newPassword: newPassword);
  }

  /// when you call this function the user will be online and can receive notification
  /// first you have to login or register in v chat other wise will throw Exception
  void bindChatControllers(BuildContext context) {
    if (VChatAppService.instance.vChatUser == null) {
      throw VChatSdkException(
          "You must login or register to v chat first delete the app and login again !");
    }

    if (!getIt.isRegistered<SocketService>()) {
      getIt.registerSingleton(SocketService());
    }

    NotificationService.instance.init(context);
    unawaited(RoomCubit.instance.getRoomsFromLocal());
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
    final user = await _authProvider.register(dto);
    await _saveUser(user);
    VChatAppService.instance.vChatUser = user;
    await Future.delayed(Duration.zero);
    bindChatControllers(context);
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
    final data = await _vChatUsersApi.createSingleChat(peerEmail);

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
        final data =
            await _vChatUsersApi.createNewSingleRoom(res, peerEmail);

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
      {required BuildContext context, required VChatLoginDto dto}) async {
    if (VChatAppService.instance.isUseFirebase) {
      dto.fcmToken = (await FirebaseMessaging.instance.getToken()).toString();
    } else {
      dto.fcmToken = "you don't use firebase on flutter app";
    }
    final user = await _authProvider.login(dto);
    await _saveUser(user);
    VChatAppService.instance.vChatUser = user;
    await Future.delayed(Duration.zero);
    bindChatControllers(context);
    return user;
  }

  Future _saveUser(VChatUser user) async {
    const storage = FlutterSecureStorage();
    await storage.write(
        key: StorageKeys.KV_CHAT_MY_MODEL, value: jsonEncode(user.toMap()));
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
    await storage.delete(key: StorageKeys.KV_CHAT_MY_MODEL);
    await DBProvider.instance.reCreateTables();
    NotificationService.instance.cancelAll();
    VChatAppService.instance.vChatUser = null;
  }
}
