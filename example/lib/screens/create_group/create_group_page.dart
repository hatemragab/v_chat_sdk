import 'dart:io';

import 'package:example/generated/l10n.dart';
import 'package:example/models/user.dart';
import 'package:example/screens/create_group/create_group_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textless/textless.dart';

/// please Note this is example you can have your own design
class CreateGroupPage extends StatelessWidget {
  final List<User> users;

  const CreateGroupPage({Key? key, required this.users}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          CreateGroupController(context: context, users: users),
      builder: (context, child) => CreateGroupScreen(),
    );
  }
}

class CreateGroupScreen extends StatelessWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CreateGroupController>();
    return Scaffold(
      appBar: AppBar(
        title: "${S.of(context).selected} ${controller.users.length}".text,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              S.of(context).setGroupImage.h6.alignCenter,
              InkWell(
                onTap: controller.pickGroupImage,
                child: controller.imagePath != null
                    ? Image.file(
                        File(controller.imagePath!),
                        height: 100,
                        width: 100,
                      )
                    : Icon(
                        Icons.image,
                        size: 100,
                      ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                decoration: InputDecoration(hintText: S.of(context).groupName),
                controller: controller.textEditingController,
              ),
              SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: () {
                  controller.createGroup();
                },
                child: S.of(context).createGroup.text,
              )
            ],
          ),
        ),
      ),
    );
  }
}
