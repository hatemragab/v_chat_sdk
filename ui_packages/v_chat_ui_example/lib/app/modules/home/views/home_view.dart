import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textless/textless.dart';
import 'package:v_chat_ui_example/app/routes/app_pages.dart';

import '../../media_picker/views/home_view.dart';
import '../../voice_player/pages/chat_page.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Ui'),
        centerTitle: true,
      ),
      body: CustomScrollView(
        primary: false,
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid.count(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: <Widget>[
                InkWell(
                  onTap: () => Get.toNamed(Routes.ROOM_UI),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.center,
                    color: Colors.green[200],
                    child: "Rooms ui".h5,
                  ),
                ),
                InkWell(
                  onTap: () => Get.toNamed(Routes.MESSAGE_UI),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.green[300],
                    alignment: Alignment.center,
                    child: "Message ui".h5,
                  ),
                ),
                InkWell(
                  onTap: () => Get.to(() => ChatPage()),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.green[400],
                    alignment: Alignment.center,
                    child: "Voice message".h5,
                  ),
                ),
                InkWell(
                  onTap: () => Get.to(() => MediaEditorExample()),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.green[500],
                    alignment: Alignment.center,
                    child: "Media picker".h5,
                  ),
                ),
                InkWell(
                  onTap: () => Get.toNamed(Routes.MESSAGE_INPUT),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.green[600],
                    alignment: Alignment.center,
                    child: 'Message input'.h5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
