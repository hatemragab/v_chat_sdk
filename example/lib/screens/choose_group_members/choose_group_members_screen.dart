import 'package:example/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textless/textless.dart';

import '../user_item.dart';
import 'choose_group_members_controller.dart';

class ChooseGroupMembersPage extends StatelessWidget {
  const ChooseGroupMembersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          ChooseGroupMembersController(context: context),
      builder: (context, child) => ChooseGroupMembersScreen(),
    );
  }
}

class ChooseGroupMembersScreen extends StatelessWidget {
  const ChooseGroupMembersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ChooseGroupMembersController>(context);
    final usersList = controller.users;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: controller.next,
        child: Icon(Icons.arrow_right),
      ),
      appBar: AppBar(
        title: "choose members".text,
        centerTitle: true,
        elevation: 0,
      ),
      body: Scrollbar(
        child: ListView.separated(
          controller: controller.scrollController,
          padding: const EdgeInsets.all(10),
          itemBuilder: (context, index) => ListTile(
              title: usersList[index].name.text,
              onTap: () => controller.setSelectedUser(usersList[index]),
              leading: Image.network(baseImgUrl + usersList[index].imageThumb),
              selected: usersList[index].isSelected),
          separatorBuilder: (context, index) => const Divider(),
          itemCount: usersList.length,
        ),
      ),
    );
  }
}
