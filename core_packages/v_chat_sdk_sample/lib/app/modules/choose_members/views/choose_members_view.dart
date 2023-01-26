import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

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
            child: GetBuilder<ChooseMembersController>(
              assignId: true,
              builder: (controller) {
                return VAsyncWidgetsBuilder(
                  loadingState: controller.loadingState,
                  successWidget: () {
                    final users = controller.members;
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
                          child: users[index].baseUser.fullName.text.alignCenter,
                        ),
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount: users.length,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
