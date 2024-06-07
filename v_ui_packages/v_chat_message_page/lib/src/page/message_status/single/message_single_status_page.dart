// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart';
import 'package:v_chat_message_page/src/core/extension.dart';
import 'package:v_chat_message_page/src/widgets/message_items/v_message_item.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../../v_chat_message_page.dart';
import 'message_single_status_controller.dart';

class VMessageSingleStatusPage extends StatefulWidget {
  final VBaseMessage message;
  final VMessageLocalization vMessageLocalization;
  final String readLabel;
  final String deliveredLabel;

  const VMessageSingleStatusPage({
    super.key,
    required this.message,
    required this.readLabel,
    required this.deliveredLabel,
    required this.vMessageLocalization,
  });

  @override
  State<VMessageSingleStatusPage> createState() =>
      _VMessageSingleStatusPageState();
}

class _VMessageSingleStatusPageState extends State<VMessageSingleStatusPage>
    with StreamMix {
  late final MessageSingleStatusController controller;

  @override
  void initState() {
    controller = MessageSingleStatusController();
    streamsMix.addAll([
      VEventBusSingleton.vEventBus
          .on<VUpdateMessageDeliverEvent>()
          .where((e) => e.roomId == widget.message.roomId)
          .listen(_handleDeliver),
      VEventBusSingleton.vEventBus
          .on<VUpdateMessageSeenEvent>()
          .where((e) => e.roomId == widget.message.roomId)
          .listen(_handleSeen),
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.isDark ? Colors.black : Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                title: AppBar(
                  backgroundColor: context.isDark ? Colors.transparent : null,
                  title: Text(widget.readLabel),
                ),
                contentPadding: EdgeInsets.zero,
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
                  child: VMessageItem(
                    language: widget.vMessageLocalization,
                    roomType: VRoomType.s,
                    voiceController: controller.getVoiceController,
                    message: widget.message,
                    onSwipe: null,
                    onReSend: (message) {},
                    onHighlightMessage: (message) {},
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Card(
                child: Column(
                  children: [
                    ReadItem(
                      dateTime: widget.message.seenAtDate,
                      title: widget.readLabel,
                      model: MessageStatusIconDataModel(
                        isMeSender: widget.message.isMeSender,
                        emitStatus: widget.message.emitStatus,
                        isDeliver: false,
                        isSeen: true,
                      ),
                    ),
                    Divider(
                      color: context.isDark ? const Color(0xff261e1e) : null,
                      height: 1,
                    ),
                    ReadItem(
                      title: widget.deliveredLabel,
                      dateTime: widget.message.deliveredAtDate,
                      model: MessageStatusIconDataModel(
                        isMeSender: widget.message.isMeSender,
                        emitStatus: widget.message.emitStatus,
                        isDeliver: true,
                        isSeen: false,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.close();
    closeStreamMix();
  }

  void _handleDeliver(VUpdateMessageDeliverEvent event) {
    widget.message.deliveredAt = event.model.date;
    setState(() {});
  }

  void _handleSeen(VUpdateMessageSeenEvent event) {
    widget.message.seenAt = event.model.date;
    setState(() {});
  }
}

class ReadItem extends StatelessWidget {
  final DateTime? dateTime;
  final String title;
  final MessageStatusIconDataModel model;

  const ReadItem({
    super.key,
    this.dateTime,
    required this.title,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.isDark ? const Color(0xff261e1e) : null,
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              MessageStatusIcon(
                model: model,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(title),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          dateTime == null
              ? const SizedBox(
                  height: 10,
                )
              : Text(
                  format(
                    dateTime!,
                    locale: Localizations.localeOf(context).languageCode,
                  ),
                  style: const TextStyle(color: Colors.grey),
                )
        ],
      ),
    );
  }
}
