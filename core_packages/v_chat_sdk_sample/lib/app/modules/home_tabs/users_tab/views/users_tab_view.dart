// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textless/textless.dart';

import '../../../../v_chat/v_async_widgets_builder.dart';
import '../../../../v_chat/v_circle_avatar.dart';
import '../controllers/users_tab_controller.dart';

class UsersTabView extends GetView<UsersTabController> {
  const UsersTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: controller.onCreateGroupOrBroadcast,
      //   child: const Icon(Icons.add),
      // ),
      appBar: AppBar(
        title: const Text('All Users'),
        centerTitle: true,
      ),
      body: GetBuilder<UsersTabController>(
        assignId: true,
        builder: (logic) {
          return VAsyncWidgetsBuilder(
            loadingState: logic.loadingState,
            emptyWidget: () => SizedBox(),
            errorWidget: () => SizedBox(),
            loadingWidget: () => SizedBox(),
            onRefresh: logic.getData,
            successWidget: () {
              return ListView.builder(
                padding: const EdgeInsets.all(5),
                itemBuilder: (context, index) {
                  final item = logic.data[index];
                  return ListTile(
                    onTap: () => logic.onItemPress(item),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    leading: VCircleAvatar(
                      fullUrl: item.baseUser.userImages.chatImage,
                    ),
                    title: item.baseUser.fullName.text,
                  );
                },
                itemCount: logic.data.length,
              );
            },
          );
        },
      ),
    );
  }
}
