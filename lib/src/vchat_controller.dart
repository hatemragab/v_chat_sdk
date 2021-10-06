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

  late final _vChatControllerProvider = VChatProvider();

  final _authProvider = AuthProvider();

  Future init({
    required String baseUrl,
    required String appName,
    required bool isUseFirebase,
    required ThemeData lightTheme,
    required ThemeData darkTheme,
    required bool enableLogger,
    required GlobalKey<NavigatorState> navKey
  }) async {
    vchatUseFirebase = isUseFirebase;
    serverIp = baseUrl;
    vchatAppName = appName;



    await Get.putAsync(() => VChatAppService().init(), permanent: true);
    await Get.putAsync(() => LocalStorageService().init(), permanent: true);

    VChatAppService.to.dark = darkTheme;
    VChatAppService.to.light = lightTheme;
    VChatAppService.to.navKey = navKey;

    if (kReleaseMode) {
      enableLog = false;
    } else {
      enableLog = enableLogger;
    }
  }

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

  Future<VChatUser> login(VChatLoginDto dto) async {
    if (vchatUseFirebase) {
      dto.fcmToken = (await FirebaseMessaging.instance.getToken()).toString();
    } else {
      dto.fcmToken = "you don't use firebase on flutter app";
    }
    final user = await _authProvider.login(dto);
    await _saveUser(user);
    bindChatControllers();
    return user;
  }

  Future<VChatUser> register(VChatRegisterDto dto) async {
    if (vchatUseFirebase) {
      dto.fcmToken = (await FirebaseMessaging.instance.getToken()).toString();
    } else {
      dto.fcmToken = "you don't use firebase on flutter app ";
    }
    final user = await _authProvider.register(dto);
    await _saveUser(user);
    bindChatControllers();
    return user;
  }

  Future _saveUser(VChatUser user) async {
    Get.find<VChatAppService>().setUser(user);
    await GetStorage().write(GetStorageKeys.KV_CHAT_MY_MODEL, user.toMap());
  }

  Future createSingleChat({
    required String peerEmail,
    required BuildContext ctx,
    String? titleTxt,
    String? createBtnTxt,
  }) async {
    String txt = "";
    final data = await _vChatControllerProvider.createSingleChat(peerEmail);

    if (data == false) {
      //no rooms founded
      showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            title: titleTxt != null ? titleTxt.text : "Say Hello !".text,
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
                  child:
                      createBtnTxt != null ? createBtnTxt.text : "Create".text)
            ],
          );
        },
      );
    } else {
      // there are room
      _navigateToRoomMessage(data, ctx);
    }
  }

  void _navigateToRoomMessage(dynamic data, BuildContext context) async {
    final room = VchatRoom.fromMap(data);
    Get.find<RoomController>().currentRoom = room;
    MessageBinding.bind();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessageView(),
      ),
    );
  }

  Future<String> stopAllNotification() async {
    if (vchatUseFirebase) {
      await FirebaseMessaging.instance.deleteToken();
      return "Notifications has been stopped successfully";
    } else {
      throw "you have to enable firebase for this project first";
    }
  }

  Future<String> startAllNotification() async {
    if (vchatUseFirebase) {
      final token = (await FirebaseMessaging.instance.getToken()).toString();
      return await _vChatControllerProvider.updateUserFcmToken(token);
    } else {
      throw "you have to enable fire base for this project first";
    }
  }

  Future updateUserImageOrName() async {}

  Future updateUserPassword() async {}

  Future logOut() async {
    await GetStorage().erase();
    await DBProvider.db.reCreateTables();
    await FirebaseMessaging.instance.deleteToken();
  }

  void bindChatControllers() {
    if (VChatAppService.to.vChatUser == null) {
      throw "You must login or register to v chat first ";
    }
    Get.put<RoomsApiProvider>(RoomsApiProvider());
    Get.put<RoomController>(RoomController());
    Get.put<NotificationService>(NotificationService());
    Get.put<SocketController>(SocketController(), permanent: true);
    Get.put<SocketService>(SocketService(), permanent: true);
  }


}
