import 'package:example/models/user.dart';
import 'package:example/screens/create_group/create_group_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textless/textless.dart';

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
        title: "selected ${controller.users.length}".text,
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
              "Set Group Image".h6.alignCenter,
              InkWell(
                  onTap: controller.pickGroupImage,
                  child: Icon(
                    Icons.image,
                    size: 100,
                  )),
              SizedBox(
                height: 10,
              ),
              TextField(
                decoration: InputDecoration(hintText: "Group Name"),
                controller: controller.textEditingController,
              ),
              SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: () {
                  controller.createGroup();
                },
                child: "Create Group !".text,
              )
            ],
          ),
        ),
      ),
    );
  }
}
