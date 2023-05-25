// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_room_page/v_chat_room_page.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await VChatController.init(
  //   vChatConfig: VChatConfig(
  //     passwordHashKey: "YOUR STRONG PASSWORD HASH KEY!",
  //     baseUrl: Uri.parse("http://10.0.2.2:3000"),
  //   ),
  // );

  await VChatController.I.authApi.login(
    identifier: "user1@gmail.com",
    deviceLanguage: const Locale("en"),
  );
  runApp(
    OverlaySupport.global(
        child: GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        VChatLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ar')],
      locale: const Locale('en'),
      theme: ThemeData.light().copyWith(extensions: [
        VRoomTheme.light().copyWith(
          scaffoldDecoration: const BoxDecoration(
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
    )),
  );
}
