import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../modules/message/views/message_view.dart';
import '../modules/rooms/cubit/room_cubit.dart';
import '../utils/api_utils/dio/custom_dio.dart';
import '../utils/helpers/helpers.dart';
import 'v_chat_app_service.dart';

class NotificationService {
  NotificationService._privateConstructor();

  static final NotificationService instance =
      NotificationService._privateConstructor();
  late BuildContext context;
  final androidNotificationDetails = const AndroidNotificationDetails(
    "v_chat_channel",
    "v_chat_channel",
    icon: "@mipmap/ic_launcher",
    enableVibration: true,
    importance: Importance.max,
    playSound: true,
    priority: Priority.max,
  );
  final iosNotificationDetails =
      const IOSNotificationDetails(presentBadge: true, presentSound: true);

  void init(BuildContext context) async {
    this.context = context;
    if (VChatAppService.instance.isUseFirebase) {
      await initNotification();
    }
  }

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

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

    // await messaging.setForegroundNotificationPresentationOptions(
    //   alert: true,
    //   badge: true,
    //   sound: true,
    // );
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      try {
        if (message.notification != null) {
          final roomId = message.data['roomId'].toString();
          try {
            if (!RoomCubit.instance.isRoomOpen(roomId)) {
              await Future.delayed(const Duration(milliseconds: 100));
              RoomCubit.instance.currentRoomId = roomId;

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => MessageView(
                        roomId: roomId,
                      )));
            }
          } catch (err) {
            Helpers.vlog(err.toString());
            //
          }
        }
      } catch (err) {
        //
      }
    });

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
          android: AndroidInitializationSettings("@mipmap/ic_launcher"),
          iOS: IOSInitializationSettings(
            requestSoundPermission: true,
            defaultPresentSound: true,
          )),
      onSelectNotification: (payload) {
        if (payload != null) {
          final roomId = payload;
          if (!RoomCubit.instance.isRoomOpen(roomId)) {
            RoomCubit.instance.currentRoomId = roomId;

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MessageView(
                  roomId: roomId,
                ),
              ),
            );
          }
        }
      },
    );

    messaging.onTokenRefresh.listen((event) async {
      try {
        await CustomDio().send(
            reqMethod: "PATCH",
            path: "user",
            body: {"fcmToken": event.toString()});
      } catch (err) {
        //
      }
    });

    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        if (!RoomCubit.instance.isRoomOpen(message.data['roomId'].toString())) {
          showNotification(
              title: "${message.notification!.title}",
              msg: message.notification!.body.toString(),
              hashCode: message.hashCode,
              roomId: message.data['roomId'].toString());
        }
      }
    });

    messaging.getInitialMessage().then((message) async {
      if (message != null) {
        try {
          final roomId = message.data['roomId'].toString();

          await Future.delayed(const Duration(milliseconds: 2500));
          RoomCubit.instance.currentRoomId = roomId;

          Navigator.of(context).push(MaterialPageRoute(
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

  void showNotification(
      {required String title,
      required String msg,
      required int hashCode,
      required String roomId}) {
    // if (Platform.isIOS) {
    //   return;
    // }

    unawaited(
      flutterLocalNotificationsPlugin.show(
        hashCode,
        title,
        msg,
        NotificationDetails(
          android: androidNotificationDetails,
          iOS: iosNotificationDetails,
        ),
        payload: roomId,
      ),
    );
  }
}
