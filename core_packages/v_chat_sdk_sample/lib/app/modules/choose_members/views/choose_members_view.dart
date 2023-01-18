import 'package:cloud_firestore/cloud_firestore.dart';
 import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_sdk_sample/app/core/utils/app_auth.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../core/models/user.model.dart';
import '../controllers/choose_members_controller.dart';

class ChooseMembersView extends GetView<ChooseMembersController> {
  const ChooseMembersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: controller.onDone,
        child: const Icon(Icons.done),
      ),
      appBar: AppBar(
        title: const Text('ChooseMembersView'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 40,
            child: Obx(() {
              final users = controller.selected;
              return ListView.builder(
                padding: const EdgeInsets.all(5),
                itemBuilder: (context, index) => InkWell(
                  onTap: () => controller.add(users[index]),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: users[index].userName.text.alignCenter,
                  ),
                ),
                scrollDirection: Axis.horizontal,
                itemCount: users.length,
              );
            }),
          ),
          // Expanded(
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: FirestorePagination(
          //       isLive: true,
          //       limit: 30,
          //       query: FirebaseFirestore.instance
          //           .collection('users')
          //           .orderBy("createdAt", descending: true),
          //       itemBuilder: (context, documentSnapshot, index) {
          //         final user = UserModel.fromMap(
          //           documentSnapshot.data() as Map<String, dynamic>,
          //         );
          //         if (user.id == AppAuth.getMyModel.id) {
          //           return const SizedBox();
          //         }
          //         return ListTile(
          //           onTap: () {
          //             controller.add(user);
          //           },
          //           leading: ClipRRect(
          //             borderRadius: BorderRadius.circular(50),
          //             child: VPlatformCacheImageWidget(
          //               source: user.imgAsPlatformSource,
          //               size: const Size(60, 60),
          //               fit: BoxFit.cover,
          //             ),
          //           ),
          //           title: Text(user.userName),
          //           subtitle: Text(user.createdAt.toIso8601String()),
          //         );
          //       },
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
