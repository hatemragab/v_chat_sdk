import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/models/user.model.dart';
import '../controllers/users_tab_controller.dart';

class UsersTabView extends GetView<UsersTabController> {
  const UsersTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: controller.repository.getStreamAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.active) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Text("No users yet");
          }
          final users = snapshot.data!;
          return ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(
                  Icons.person,
                  size: 40,
                ),
                title: Text(users[index].userName),
                subtitle: Text(users[index].createdAt.toIso8601String()),
              );
            },
            itemCount: users.length,
          );
        },
      ),
    );
  }
}
