import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_room_page/v_chat_room_page.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData.light().copyWith(extensions: [
        VRoomTheme.light().copyWith(
          scaffoldDDecoration: const BoxDecoration(
              // image: DecorationImage(
              //   image: AssetImage("assets/images/bulb.jpg"),
              //   fit: BoxFit.cover,
              // ),
              ),
          // vChatItemBuilder: VChatItemBuilder.light().copyWith(
          //   / add custom title text style
          //   getChatTitle: (title) => Text(
          //     title,
          //     style: const TextStyle(fontWeight: FontWeight.w600),
          //   ),
          // ),
        ),
      ]),
      darkTheme: ThemeData.dark(),
    ),
  );
}
