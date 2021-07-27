import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:textless/textless.dart';
import 'vchat_constants.dart';
import 'app/dto/vchat_login_dto.dart';
import 'app/dto/vchat_register_dto.dart';
import 'app/models/vchat_room.dart';
import 'app/models/vchat_user.dart';
import 'app/modules/message/bindings/message_binding.dart';
import 'app/modules/message/views/message_view.dart';
import 'app/modules/room/controllers/rooms_controller.dart';
import 'app/modules/room/providers/room_api_provider.dart';
import 'app/services/auth/auth_provider.dart';
import 'app/services/local_storage_serivce.dart';
import 'app/services/notification_service.dart';
import 'app/services/socket_controller.dart';
import 'app/services/socket_service.dart';
import 'app/services/vchat_app_service.dart';
import 'app/sqlite/db_provider.dart';
import 'app/utils/get_storage_keys.dart';
import 'vchat_provider.dart';

class VChatController {
  VChatController._privateConstructor();

  static final VChatController _instance =
  VChatController._privateConstructor();

  static VChatController get instance => _instance;

  final _provider = VChatProvider();

  final AuthProvider _authProvider = AuthProvider();

  Future init() async {
    await Get.putAsync(() => VChatAppService().init(), permanent: true);
    await Get.putAsync(() => LocalStorageService().init(), permanent: true);
  }

  Future<VChatUser> login(VChatLoginDto dto) async {
    if (USE_FIREBASE) {
      dto.fcmToken = (await FirebaseMessaging.instance.getToken()).toString();
    } else {
      dto.fcmToken = "you dont use firebase on flutter app ";
    }
    final user = await _authProvider.login(dto);
    await _saveUser(user);

    return user;
  }

  Future<VChatUser> register(VchatRegisterDto dto) async {
    if (USE_FIREBASE) {
      dto.fcmToken = (await FirebaseMessaging.instance.getToken()).toString();
    } else {
      dto.fcmToken = "you dont use firebase on flutter app ";
    }
    final user = await _authProvider.register(dto);
    await _saveUser(user);
    return user;
  }

  Future _saveUser(VChatUser user) async {
    Get.find<VChatAppService>().setUser(user);
    await GetStorage().write(GetStorageKeys.KV_CHAT_MY_MODEL, user.toMap());
  }

  Future createSingleChat(
      {required String peerEmail, required BuildContext ctx}) async {
    String txt = "";
    final data = await _provider.createSingleChat(peerEmail);
    if (data == false) {
      //no rooms founded
      showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            title: "Say Hello !".text,
            content: TextField(
              onChanged: (value) {
                txt = value;
              },
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    final data =
                    await _provider.createNewSingleRoom(txt, peerEmail);
                    // room has been created successfully
                    await Future.delayed(Duration(seconds: 1));
                    _navigateToRoomMessage(data, ctx);
                  },
                  child: "Create".text)
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

  Future stopAllNotifiactions() async {}

  Future startAllNotifiactions() async {}

  Future updateUserImageOrName() async {}

  Future updateUserPassword() async {}

  Future logOut() async {
    await GetStorage().erase();
    await FirebaseMessaging.instance.deleteToken();
    await DBProvider.db.reCreateTables();
  }

  void bindChatControllers() {
    Get.put<RoomsApiProvider>(RoomsApiProvider());
    Get.put<RoomController>(RoomController());
    Get.put<NotificationService>(NotificationService());
    Get.put<SocketController>(SocketController(), permanent: true);
    Get.put<SocketService>(SocketService(), permanent: true);
  }
}
