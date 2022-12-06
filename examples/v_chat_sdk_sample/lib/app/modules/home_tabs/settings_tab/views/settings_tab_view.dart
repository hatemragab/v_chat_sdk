import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/settings_tab_controller.dart';

class SettingsTabView extends GetView<SettingsTabController> {
  const SettingsTabView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SettingsTabView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'SettingsTabView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
