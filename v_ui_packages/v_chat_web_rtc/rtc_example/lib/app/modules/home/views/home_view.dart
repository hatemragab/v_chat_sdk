// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_web_rtc/v_chat_web_rtc.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                vDefaultCallNavigator.toCaller(
                  context,
                  VCallerDto(
                    isVideoEnable: false,
                    roomId: "roomId",
                    peerName: "peer Name",
                    peerImage: VUserImage.fromFakeSingleUrl().chatImage,
                  ),
                );
              },
              child: const Text("Caller page"),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                vDefaultCallNavigator.toCallee(
                  context,
                  VNewCallModel(
                    roomId: "roomId",
                    withVideo: true,
                    payload: {},
                    identifierUser: VIdentifierUser(
                      identifier: "identifier",
                      baseUser: VBaseUser(
                        fullName: "full Name",
                        userImages: VUserImage.fromFakeSingleUrl(),
                        vChatId: "vChatId",
                      ),
                    ),
                    meetId: "meetId",
                  ),
                );
              },
              child: const Text("Callee page"),
            ),
          ],
        ),
      ),
    );
  }
}
