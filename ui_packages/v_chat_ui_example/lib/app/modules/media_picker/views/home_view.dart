import 'package:flutter/material.dart';
import 'package:textless/textless.dart';

import '../controllers/home_controller.dart';

class MediaEditorExample extends StatefulWidget {
  const MediaEditorExample({Key? key}) : super(key: key);

  @override
  State<MediaEditorExample> createState() => _MediaEditorExampleState();
}

class _MediaEditorExampleState extends State<MediaEditorExample> {
  late final HomeController controller;

  @override
  void initState() {
    super.initState();
    controller = HomeController();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: controller.onGallery,
        child: "Open Gallery".text.alignCenter,
      ),
      appBar: AppBar(
        title: const Text('Home View'),
        centerTitle: true,
      ),
    );
  }
}
