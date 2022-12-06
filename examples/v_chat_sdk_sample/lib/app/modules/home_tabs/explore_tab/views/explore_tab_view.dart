import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/explore_tab_controller.dart';

class ExploreTabView extends GetView<ExploreTabController> {
  const ExploreTabView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ExploreTabView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'ExploreTabView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
