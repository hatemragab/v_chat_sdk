import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_sdk_sample/app/core/models/user.model.dart';
import 'package:v_chat_sdk_sample/app/routes/app_pages.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../../core/utils/app_auth.dart';
import '../controllers/users_tab_controller.dart';

class UsersTabView extends GetView<UsersTabController> {
  const UsersTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: controller.onCreateGroupOrBroadcast,
      //   child: const Icon(Icons.add),
      // ),
      appBar: AppBar(
        title: const Text('All Users'),
        centerTitle: true,
      ),
      body: FirestorePagination(
        isLive: true,
        viewType: ViewType.list,
        limit: 30,
        query: FirebaseFirestore.instance
            .collection('users')
            .orderBy("createdAt", descending: true),
        itemBuilder: (context, documentSnapshot, index) {
          final user = UserModel.fromMap(
              documentSnapshot.data() as Map<String, dynamic>);
          if (user.id == AppAuth.getMyModel.id) {
            return const SizedBox();
          }
          return ListTile(
            onTap: () => Get.toNamed(
              Routes.PEER_PROFILE,
              arguments: user.id,
            ),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: VPlatformCacheImageWidget(
                source: user.imgAsPlatformSource,
                size: const Size(60, 60),
                fit: BoxFit.cover,
              ),
            ),
            title: Text(user.userName),
            subtitle: Text(user.createdAt.toIso8601String()),
          );
        },
      ),
      // body: StreamBuilder<List<UserModel>>(
      //   stream: controller.repository.getStreamAll(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState != ConnectionState.active) {
      //       return const Center(
      //         child: CircularProgressIndicator.adaptive(),
      //       );
      //     }
      //     if (snapshot.data == null || snapshot.data!.isEmpty) {
      //       return const Text("No users yet");
      //     }
      //     final users = snapshot.data!;
      //     return ListView.builder(
      //       padding: const EdgeInsets.only(top: 5),
      //       itemBuilder: (context, index) {
      //         return ListTile(
      //           leading: ClipRRect(
      //             borderRadius: BorderRadius.circular(50),
      //             child: PlatformCacheImageWidget(
      //               source: users[index].imgAsPlatformSource,
      //               size: const Size(60, 60),
      //               fit: BoxFit.cover,
      //             ),
      //           ),
      //           title: Text(users[index].userName),
      //           subtitle: Text(users[index].createdAt.toIso8601String()),
      //         );
      //       },
      //       itemCount: users.length,
      //     );
      //   },
      // ),
    );
  }
}
