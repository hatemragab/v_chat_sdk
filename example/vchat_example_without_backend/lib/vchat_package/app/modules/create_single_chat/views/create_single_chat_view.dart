import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textless/textless.dart';

import '../../../enums/load_more_type.dart';
import '../bindings/create_single_chat_binding.dart';
import '../controllers/create_single_chat_controller.dart';
import 'widgets/user_item.dart';

class CreateSingleChatView extends StatefulWidget {
  @override
  _CreateSingleChatViewState createState() => _CreateSingleChatViewState();
}

class _CreateSingleChatViewState extends State<CreateSingleChatView> {
  final controller = Get.find<CreateSingleChatController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('create single chat'),
        centerTitle: true,
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          controller: controller.scrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              controller.obx(
                (users) {
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => InkWell(
                        onTap: () => controller.onUserItemClicked(
                            context, users![index]),
                        child: UserItem(users![index])),
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: users!.length,
                  );
                },
                onLoading: "loading...".text,
              ),
              Obx(() {
                final value = controller.loadingStatus.value;
                if (value == LoadMoreStatus.loading) {
                  return Column(
                    children: [
                      CircularProgressIndicator.adaptive(),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  );
                } else if (value == LoadMoreStatus.completed) {
                  return "No More Data ".text;
                }
                return SizedBox.shrink();
              }),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    CreateSingleChatBinding.unBind();
    super.dispose();
  }
}
