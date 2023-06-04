// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../v_chat/v_circle_avatar.dart';
import '../controllers/broadcast_settings_controller.dart';

class BroadcastSettingsView extends GetView<BroadcastSettingsController> {
  const BroadcastSettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BroadcastSettingsController>(
      assignId: true,
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(
            title: Text(logic.data.title),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  VCircleAvatar(
                    fullUrl: logic.data.image,
                    radius: 70,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    title: Text("Show members"),
                    onTap: logic.toShowMembers,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
