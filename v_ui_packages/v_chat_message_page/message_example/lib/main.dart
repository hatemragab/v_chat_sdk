// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await VChatController.init(
  //   vChatConfig: VChatConfig(
  //     passwordHashKey: "YOUR STRONG PASSWORD HASH KEY!",
  //     baseUrl: Uri.parse("http://10.0.2.2:3000"),
  //   ),
  // );

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      locale: const Locale("en"),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    ),
  );
}
