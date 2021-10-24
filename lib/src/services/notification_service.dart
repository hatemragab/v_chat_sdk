import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:v_chat_sdk/src/services/v_chat_app_service.dart';
import '../modules/room/controllers/rooms_controller.dart';
import '../utils/api_utils/dio/custom_dio.dart';

class NotificationService extends GetxService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final _roomController = Get.find<RoomController>();

  @override
  void onInit() {
    if (VChatAppService.to.isUseFirebase) {
      init();
    }
    super.onInit();
  }

  void cancelAll() {
    flutterLocalNotificationsPlugin.cancelAll();
  }

  final channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      showBadge: true);

  static Future<String?> getFcmToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  void init() async {
    final messaging = FirebaseMessaging.instance;
    messaging.setAutoInitEnabled(true);
    await messaging.getToken();
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    FirebaseMessaging.instance.onTokenRefresh.listen((event) async {
      await CustomDio().send(
          reqMethod: "PATCH",
          path: "user",
          body: {"fcmToken": event.toString()});
    });

    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        if (!_roomController
            .isRoomOpen(int.parse(message.data['roomId'].toString()))) {
          showNotification(
            title: "${message.notification!.title}",
            msg: message.notification!.body.toString(),
          );
        }
      }
    });

    flutterLocalNotificationsPlugin.cancelAll();
    //show();
  }

  static void showNotification({required String title, required String msg}) {
    BotToast.showSimpleNotification(
      title: title.toString(),
      duration: const Duration(seconds: 5),
      subTitle: msg.toString(),
    );
  }

  void show() async {
    await Future.delayed(const Duration(seconds: 10));
    showNotification(
        msg: VChatAppService.to.getTrans().test(),
        title: VChatAppService.to.getTrans().toDay());
  }
}
