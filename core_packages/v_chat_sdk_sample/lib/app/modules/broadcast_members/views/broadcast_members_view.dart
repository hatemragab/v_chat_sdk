// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../controllers/broadcast_members_controller.dart';

class BroadcastMembersView extends GetView<BroadcastMembersController> {
  const BroadcastMembersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BroadcastMembersController>(
      assignId: true,
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('broadcastMembersView'),
            centerTitle: true,
          ),
          body: VAsyncWidgetsBuilder(
            loadingState: logic.loadingState,
            onRefresh: logic.getMembers,
            successWidget: () {
              return ListView.separated(
                padding: EdgeInsets.only(top: 10),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: VCircleAvatar(
                      fullUrl: logic.members[index].userData.baseUser.userImages
                          .chatImage,
                    ),
                    title: logic.members[index].userData.baseUser.fullName.text,
                  );
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: logic.members.length,
              );
            },
          ),
        );
      },
    );
  }
}
