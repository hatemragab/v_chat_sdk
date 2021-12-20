import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:v_chat_sdk/src/models/v_chat_message.dart';
import 'package:v_chat_sdk/src/services/local_storage_service.dart';

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
    importance: Importance.max,
    priority: Priority.max,
  );
  final iosNotificationDetails = const IOSNotificationDetails(
    presentBadge: true,
    presentSound: true,
  );

  Future init(BuildContext context) async {
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
  );

  static Future<String?> getFcmToken() async {
    return FirebaseMessaging.instance.getToken();
  }

  Future initNotification() async {
    final messaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    messaging.setAutoInitEnabled(true);
    final token = await messaging.getToken();
    try {
      await CustomDio().send(
        reqMethod: "PATCH",
        path: "user",
        body: {"fcmToken": token.toString()},
      );
    } catch (err) {
      //
    }
    await messaging.requestPermission(
      criticalAlert: true,
    );
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) async {
        if (message.notification != null) {
          if (message.data['roomId'] != null) {
            final roomId = message.data['roomId'].toString();
            if (!RoomCubit.instance.isRoomOpen(roomId)) {
              await RoomCubit.instance.getRoomsFromLocal();

              if (RoomCubit.instance.isRoomExit(roomId)) {
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
          }
        }
      },
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"),
        iOS: IOSInitializationSettings(),
      ),
      onSelectNotification: (payload) async {
        if (payload != null) {
          final roomId = payload;
          if (RoomCubit.instance.isRoomExit(roomId)) {
            if (RoomCubit.instance.currentRoomId != null) {
              /// there is open room now
              if (Navigator.canPop(context)) {
                if (RoomCubit.instance.isOpenMessageImageOrVideo) {
                  Navigator.pop(context);
                }
                Navigator.pop(context);
              }
              await Future.delayed(const Duration(milliseconds: 600));
            }
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
          body: {"fcmToken": event},
        );
      } catch (err) {
        //
      }
    });

    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        if (message.data['roomId'] != null) {
          /// message notifications
          if (!RoomCubit.instance
              .isRoomOpen(message.data['roomId'].toString())) {
            showNotification(
              title: "${message.notification!.title}",
              msg: message.notification!.body.toString(),
              hashCode: message.hashCode,
              roomId: message.data['roomId'].toString(),
            );
          }
          unawaited(
            LocalStorageService.instance.insertMessage(
              message.data['roomId'].toString(),
              VChatMessage.fromMap(
                jsonDecode(message.data['message'].toString()),
              ),
            ),
          );
        } else {
          /// FCM Push notifications
          showNotification(
            title: "${message.notification!.title}",
            msg: message.notification!.body.toString(),
            hashCode: message.hashCode,
            roomId: null,
          );
        }
      }
    });

    messaging.getInitialMessage().then((message) async {
      if (message != null) {
        try {
          final roomId = message.data['roomId'];
          if (roomId != null) {
            RoomCubit.instance.currentRoomId = roomId.toString();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MessageView(
                  roomId: roomId.toString(),
                ),
              ),
            );
          }
        } catch (err) {
          Helpers.vlog(err.toString());
          //
        }
      }
    });

    flutterLocalNotificationsPlugin.cancelAll();
  }

  void showNotification({
    required String title,
    required String msg,
    required int hashCode,
    required String? roomId,
  }) {
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

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.data['roomId'] != null) {
    await LocalStorageService.instance.init();
    await LocalStorageService.instance.insertMessage(
      message.data['roomId'].toString(),
      VChatMessage.fromMap(jsonDecode(message.data['message'].toString())),
    );
  }
  return Future<void>.value();
}
