// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart';
import 'package:v_chat_message_page/src/core/extension.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../../v_chat_message_page.dart';
import '../../../v_chat/v_async_widgets_builder.dart';
import '../../../v_chat/v_circle_avatar.dart';
import '../../../widgets/message_items/v_message_item.dart';
import '../group/message_group_status_controller.dart';
import 'message_broadcast_status_controller.dart';

class VMessageBroadcastStatusPage extends StatefulWidget {
  final VBaseMessage message;
  final String messageInfoLabel;
  final String readLabel;
  final String deliveredLabel;
  final VMessageLocalization vMessageLocalization;

  const VMessageBroadcastStatusPage({
    Key? key,
    required this.message,
    required this.messageInfoLabel,
    required this.readLabel,
    required this.deliveredLabel,
    required this.vMessageLocalization,
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
                title: Text(widget.messageInfoLabel),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
                child: VMessageItem(
                  language: widget.vMessageLocalization,
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
                    Text(widget.readLabel)
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
                                    Text(widget.readLabel),
                                    Text(
                                      format(
                                        value.seen[index].seen!,
                                        locale: Localizations.localeOf(context)
                                            .languageCode,
                                      ),
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(widget.deliveredLabel),
                                    Text(
                                      format(
                                        value.seen[index].delivered,
                                        locale: Localizations.localeOf(context)
                                            .languageCode,
                                      ),
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    )
                                  ],
                                ),
                              ],
                            ),

                            // title: value.seen[index].identifierUser.baseUser
                            //     .fullName.text,
                            title: Text(
                              value
                                  .seen[index].identifierUser.baseUser.fullName,
                            )),
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
                    Text(widget.deliveredLabel)
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
                          subtitle: Text(
                            format(
                              value.deliver[index].delivered,
                              locale:
                                  Localizations.localeOf(context).languageCode,
                            ),
                            style: const TextStyle(color: Colors.grey),
                          ),
                          leading: VCircleAvatar(
                            radius: 20,
                            fullUrl: value.deliver[index].identifierUser
                                .baseUser.userImages.smallImage,
                          ),
                          title: Text(value
                              .deliver[index].identifierUser.baseUser.fullName),
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
