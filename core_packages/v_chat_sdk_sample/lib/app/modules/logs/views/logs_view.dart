import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/logs_controller.dart';

class LogsView extends GetView<LogsController> {
  const LogsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LogsView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'LogsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
