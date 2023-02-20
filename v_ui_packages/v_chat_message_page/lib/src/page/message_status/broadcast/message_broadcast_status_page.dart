// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../../v_chat_message_page.dart';
import '../../../widgets/message_items/v_message_item.dart';
import '../group/message_group_status_controller.dart';
import 'message_broadcast_status_controller.dart';

class VMessageBroadcastStatusPage extends StatefulWidget {
  final VBaseMessage message;

  const VMessageBroadcastStatusPage({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  State<VMessageBroadcastStatusPage> createState() =>
      _VMessageBroadcastStatusPageState();
}

class _VMessageBroadcastStatusPageState
    extends State<VMessageBroadcastStatusPage> {
  late final MessageBroadcastStatusController controller;

  @override
  void initState() {
    controller = MessageBroadcastStatusController(
      widget.message,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.isDark ? Colors.black : Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: AppBar(
                backgroundColor: context.isDark ? Colors.transparent : null,
                title: VTrans.labelsOf(context).messageInfo.text,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: VMessageItem(
                  voiceController: controller.getVoiceController,
                  message: widget.message,
                  roomType: VRoomType.b,
                  onSwipe: null,
                  onReSend: (message) {},
                  onHighlightMessage: (message) {},
                ),
              ),
            ),
            Container(
              color:
                  context.isDark ? Colors.black.withOpacity(.1) : Colors.white,
              child: ListTile(
                title: Row(
                  children: [
                    MessageStatusIcon(
                      model: MessageStatusIconDataModel(
                        isDeliver: false,
                        isSeen: true,
                        emitStatus: widget.message.emitStatus,
                        isMeSender: widget.message.isMeSender,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    VTrans.labelsOf(context).read.text,
                  ],
                ),
              ),
            ),
            ValueListenableBuilder<MessageStatusState>(
                valueListenable: controller,
                builder: (__, value, _) {
                  return VAsyncWidgetsBuilder(
                    loadingState: controller.state,
                    onRefresh: controller.getData,
                    successWidget: () {
                      return ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(10),
                        itemBuilder: (context, index) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: VCircleAvatar(
                            radius: 20,
                            fullUrl: value.seen[index].identifierUser.baseUser
                                .userImages.smallImage,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  VTrans.labelsOf(context).read.text,
                                  format(value.seen[index].seen!)
                                      .text
                                      .color(Colors.grey),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  VTrans.labelsOf(context).delivered.text,
                                  format(value.seen[index].delivered)
                                      .text
                                      .color(Colors.grey),
                                ],
                              ),
                            ],
                          ),
                          title: value.seen[index].identifierUser.baseUser
                              .fullName.text,
                        ),
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: value.seen.length,
                      );
                    },
                  );
                }),
            Container(
              color:
                  context.isDark ? Colors.black.withOpacity(.1) : Colors.white,
              child: ListTile(
                title: Row(
                  children: [
                    MessageStatusIcon(
                      model: MessageStatusIconDataModel(
                        isDeliver: true,
                        isSeen: false,
                        emitStatus: widget.message.emitStatus,
                        isMeSender: widget.message.isMeSender,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    VTrans.labelsOf(context).delivered.text,
                  ],
                ),
              ),
            ),
            ValueListenableBuilder<MessageStatusState>(
                valueListenable: controller,
                builder: (__, value, _) {
                  return VAsyncWidgetsBuilder(
                    loadingState: controller.state,
                    successWidget: () {
                      return ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(10),
                        itemBuilder: (context, index) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          subtitle: format(value.deliver[index].delivered)
                              .text
                              .color(Colors.grey),
                          leading: VCircleAvatar(
                            radius: 20,
                            fullUrl: value.deliver[index].identifierUser
                                .baseUser.userImages.smallImage,
                          ),
                          title: value.deliver[index].identifierUser.baseUser
                              .fullName.text,
                        ),
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: value.deliver.length,
                      );
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.close();
  }
}
