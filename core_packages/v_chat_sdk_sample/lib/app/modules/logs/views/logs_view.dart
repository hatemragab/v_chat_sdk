// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../controllers/logs_controller.dart';

class LogsView extends GetView<LogsController> {
  const LogsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LogsView'),
        actions: [
          IconButton(
            onPressed: () => controller.logs.clear(),
            icon: Icon(Icons.restore_from_trash),
          )
        ],
        centerTitle: true,
      ),
      body: Obx(() {
        return ListView.separated(
          padding: EdgeInsets.all(10),
          itemBuilder: (context, index) => ListTile(
            title: Text(controller.logs[index].title),
            subtitle: controller.logs[index].desc.text.maxLine(4),
          ),
          separatorBuilder: (context, index) => Divider(),
          itemCount: controller.logs.length,
        );
      }),
    );
  }
}
