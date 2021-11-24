import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vibration/vibration.dart';

import '../modules/message/views/message_view.dart';
import '../modules/rooms/cubit/room_cubit.dart';
import '../utils/api_utils/dio/custom_dio.dart';
import '../utils/helpers/helpers.dart';
import 'v_chat_app_service.dart';

class NotificationService {
  NotificationService._privateConstructor();

  static final NotificationService _instance =
      NotificationService._privateConstructor();

  static NotificationService get to => _instance;

  void init() async {
    if (VChatAppService.to.isUseFirebase) {
      await initNotification();
    }
  }

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // final _roomController = Get.find<RoomController>();

  void cancelAll() {
    flutterLocalNotificationsPlugin.cancelAll();
  }

  final channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
    showBadge: true,
  );

  static Future<String?> getFcmToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  Future initNotification() async {
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

    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessageOpenedApp.listen(( message) async {
      if (message.notification != null) {
        final roomId = int.parse(message.data['roomId'].toString());
        try {
          if (!RoomCubit.instance.isRoomOpen(roomId)) {
            await Future.delayed(const Duration(milliseconds: 100));
            RoomCubit.instance.currentRoomId = roomId;

            Navigator.of(VChatAppService.to.navKey!.currentContext!)
                .push(MaterialPageRoute(
                    builder: (_) => MessageView(
                          roomId: roomId,
                        )));
          }
        } catch (err) {
          Helpers.vlog(err.toString());
          //
        }
      }
    });
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    messaging.onTokenRefresh.listen((event) async {
      await CustomDio().send(
          reqMethod: "PATCH",
          path: "user",
          body: {"fcmToken": event.toString()});
    });

    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        if (!RoomCubit.instance
            .isRoomOpen(int.parse(message.data['roomId'].toString()))) {
          showNotification(
              title: "${message.notification!.title}",
              msg: message.notification!.body.toString(),
              roomId: int.parse(message.data['roomId'].toString()));
        }
      }
    });

    messaging.getInitialMessage().then(( message) async {
      if (message != null) {
        try {
          final roomId = int.parse(message.data['roomId'].toString());

          await Future.delayed(const Duration(milliseconds: 2500));
          RoomCubit.instance.currentRoomId = roomId;

          Navigator.of(VChatAppService.to.navKey!.currentContext!)
              .push(MaterialPageRoute(
                  builder: (_) => MessageView(
                        roomId: roomId,
                      )));
        } catch (err) {
          Helpers.vlog(err.toString());
          //
        }
      }
    });
    flutterLocalNotificationsPlugin.cancelAll();
  }

  static void showNotification(
      {required String title, required String msg, required int roomId}) {
    BotToast.showSimpleNotification(
      title: title.toString(),
      onTap: () {
        if (!RoomCubit.instance.isRoomOpen(roomId)) {
          RoomCubit.instance.currentRoomId = roomId;

          Navigator.of(VChatAppService.to.navKey!.currentContext!)
              .push(MaterialPageRoute(
                  builder: (_) => MessageView(
                        roomId: roomId,
                      )));
        }
        BotToast.cleanAll();
      },
      duration: const Duration(seconds: 5),
      subTitle: msg.toString(),
    );
    try {
      Vibration.vibrate(

      );
    } catch (err) {
      //
    }
  }
}
