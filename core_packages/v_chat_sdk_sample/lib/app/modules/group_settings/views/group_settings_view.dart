// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../controllers/group_settings_controller.dart';

class GroupSettingsView extends GetView<GroupSettingsController> {
  const GroupSettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupSettingsController>(
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
                  ),
                  ListTile(
                    title: Text("Leave"),
                    onTap: logic.leave,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
