import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:textless/textless.dart';
import 'package:v_chat_sdk/src/utils/helpers/helpers.dart';
import 'package:v_chat_sdk/src/utils/translator/lookup_string.dart';
import 'dto/v_chat_login_dto.dart';
import 'dto/v_chat_register_dto.dart';
import 'models/v_chat_room.dart';
import 'models/v_chat_user.dart';
import 'modules/message/bindings/message_binding.dart';
import 'modules/message/views/message_view.dart';
import 'modules/room/controllers/rooms_controller.dart';
import 'modules/room/providers/room_api_provider.dart';
import 'services/auth/auth_provider.dart';
import 'services/local_storage_serivce.dart';
import 'services/notification_service.dart';
import 'services/socket_controller.dart';
import 'services/socket_service.dart';
import 'services/vchat_app_service.dart';
import 'sqlite/db_provider.dart';
import 'utils/get_storage_keys.dart';
import 'utils/vchat_constants.dart';
import 'services/vchat_provider.dart';

class VChatController {
  VChatController._privateConstructor();

  static final VChatController _instance =
      VChatController._privateConstructor();

  static VChatController get instance => _instance;

  final _vChatControllerProvider = VChatProvider();

  final _authProvider = AuthProvider();

  /// **baseUrl** v chat  backend base url
  /// **appName** your app name to because we create a file in phone internal storage to save files
  /// the folder in Documents/`appName`
  /// **isUseFirebase** if firebase not supported in your country or you not connect the app with firebase yet
  /// **lightTheme** define and override v_chat default Light theme
  /// **darkTheme** define and override v_chat default Dark theme
  /// **navKey** nav Key to get the context any where and support localization

  Future init(
      {required String baseUrl,
      required String appName,
      required bool isUseFirebase,
      required ThemeData lightTheme,
      required ThemeData darkTheme,
      required bool enableLogger,
      required GlobalKey<NavigatorState> navKey}) async {
    vchatUseFirebase = isUseFirebase;
    serverIp = baseUrl;
    vchatAppName = appName;

    await Get.putAsync(() => VChatAppService().init());
    await Get.putAsync(() => LocalStorageService().init());

    VChatAppService.to.dark = darkTheme;
    VChatAppService.to.light = lightTheme;
    VChatAppService.to.navKey = navKey;

    if (kReleaseMode) {
      enableLog = false;
    } else {
      enableLog = enableLogger;
    }
  }

  /// to add new language to v chat
  void setLocaleMessages(
      {required String languageCode,
      required String countryCode,
      required LookupString lookupMessages}) {
    try {
      VChatAppService.to.setLocaleMessages(
          "${languageCode}_${countryCode.toUpperCase()}", lookupMessages);
    } catch (err) {
      Helpers.vlog("you should call function after init v chat");
      throw "you should call function after init v chat";
    }
  }

  /// **throw** User not in v chat data base
  /// **throw** No internet connection
  Future<VChatUser> login(VChatLoginDto dto) async {
    if (vchatUseFirebase) {
      dto.fcmToken = (await FirebaseMessaging.instance.getToken()).toString();
    } else {
      dto.fcmToken = "you don't use firebase on flutter app";
    }
    final user = await _authProvider.login(dto);
    await _saveUser(user);
    VChatAppService.to.setUser(user);
    bindChatControllers();
    return user;
  }

  /// **throw** User already in v chat data base
  /// **throw** No internet connection
  Future<VChatUser> register(VChatRegisterDto dto) async {
    if (vchatUseFirebase) {
      dto.fcmToken = (await FirebaseMessaging.instance.getToken()).toString();
    } else {
      dto.fcmToken = "you don't use firebase on flutter app ";
    }
    final user = await _authProvider.register(dto);
    await _saveUser(user);
    VChatAppService.to.setUser(user);
    bindChatControllers();
    return user;
  }

  Future _saveUser(VChatUser user) async {
    await GetStorage().write(GetStorageKeys.KV_CHAT_MY_MODEL, user.toMap());
    VChatAppService.to.setUser(user);
  }

  /// **throw** You cant start chat if you start chat your self
  /// **throw** Execution if peer Email Not in v chat Data base ! so first you must migrate all users
  /// **throw** No internet connection
  Future<dynamic> createSingleChat({
    required String peerEmail,
    required BuildContext ctx,
    String? titleTxt,
    String? createBtnTxt,
  }) async {
    String txt = "";
    final data = await _vChatControllerProvider.createSingleChat(peerEmail);

    if (data == false) {
      //no rooms founded
      return await showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            title: titleTxt != null
                ? titleTxt.text
                : VChatAppService.to.getTrans().sayHello().text,
            content: TextField(
              onChanged: (value) {
                txt = value;
              },
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    final data = await _vChatControllerProvider
                        .createNewSingleRoom(txt, peerEmail);
                    // room has been created successfully
                    await Future.delayed(const Duration(seconds: 1));
                    _navigateToRoomMessage(data, ctx);
                  },
                  child: createBtnTxt != null
                      ? createBtnTxt.text
                      : VChatAppService.to.getTrans().create().text)
            ],
          );
        },
      );
    } else {
      // there are room
      return await _navigateToRoomMessage(data, ctx);
    }
  }

  Future<dynamic> _navigateToRoomMessage(
      dynamic data, BuildContext context) async {
    final room = VChatRoom.fromMap(data);
    final c = Get.find<RoomController>();
    c.updateOneRoomInRamAndSort(room);
    c.currentRoomId = room.id;
    MessageBinding.bind();
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessageView(),
      ),
    );
  }

  /// **throw** No internet connection
  Future<String> stopAllNotification() async {
    if (vchatUseFirebase) {
      await FirebaseMessaging.instance.deleteToken();
      return VChatAppService.to
          .getTrans()
          .notificationsHasBeenStoppedSuccessfully();
    } else {
      throw "you have to enable firebase for this project first";
    }
  }

  /// **throw** No internet connection
  Future<String> startAllNotification() async {
    if (vchatUseFirebase) {
      final token = (await FirebaseMessaging.instance.getToken()).toString();
      return await _vChatControllerProvider.updateUserFcmToken(token);
    } else {
      throw "you have to enable fire base for this project first";
    }
  }

  /// **throw** No internet connection
  Future updateUserName({required String name}) async {
    return await _vChatControllerProvider.updateUserName(name: name);
  }

  /// **throw** File Not Found !
  /// **throw** No internet connection
  Future updateUserImage({required String imagePath}) async {
    return await _vChatControllerProvider.updateUserImage(path: imagePath);
  }

  /// **throw** No internet connection
  Future updateUserPassword(
      {required String oldPassword, required String newPassword}) async {
    return await _vChatControllerProvider.updateUserPassword(
        oldPassword: oldPassword, newPassword: newPassword);
  }

  /// **throw** No internet connection
  Future logOut() async {
    await GetStorage().remove(GetStorageKeys.KV_CHAT_MY_MODEL);
    await DBProvider.db.reCreateTables();
    await FirebaseMessaging.instance.deleteToken();
    await _vChatControllerProvider.logOut();
    await _unBindChatControllers();
  }

  // delete all controller instances
  Future _unBindChatControllers() async {
    Get.delete<LocalStorageService>();
    Get.delete<RoomsApiProvider>();
    Get.delete<RoomController>();
    Get.delete<NotificationService>();
    Get.delete<SocketController>();
    Get.delete<SocketService>();
    VChatAppService.to.vChatUser = null;

    await Get.putAsync(() => LocalStorageService().init());
  }

  /// when you call this function the user will be online and can receive notification
  /// first you have to login or register in v chat other wise will throw Exception
  void bindChatControllers() {
    if (VChatAppService.to.vChatUser == null) {
      throw "You must login or register to v chat first delete the app and login again !";
    }
    Get.put<RoomsApiProvider>(RoomsApiProvider());
    Get.put<RoomController>(RoomController());
    Get.put<NotificationService>(NotificationService());
    Get.put<SocketController>(SocketController());
    Get.put<SocketService>(SocketService());
  }
}
