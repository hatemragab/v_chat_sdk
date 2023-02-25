// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:v_chat_message_page/src/page/message_pages/pages/single/v_single_controller.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../../../v_chat_message_page.dart';
import '../../controllers/v_message_item_controller.dart';
import '../../providers/message_provider.dart';
import '../../states/app_bar_state_controller.dart';
import '../../states/input_state_controller.dart';
import '../../widget_states/app_bar_state_widget.dart';
import '../../widget_states/input_widget_state.dart';
import '../../widget_states/message_body_state_widget.dart';

class VSingleView extends StatefulWidget {
  const VSingleView({
    Key? key,
    required this.vRoom,
    this.context,
  }) : super(key: key);
  final VRoom vRoom;
  final BuildContext? context;

  @override
  State<VSingleView> createState() => _VSingleViewState();
}

class _VSingleViewState extends State<VSingleView> {
  late final VSingleController controller;

  @override
  void initState() {
    super.initState();
    final provider = MessageProvider();
    controller = VSingleController(
      vRoom: widget.vRoom,
      context: widget.context ?? context,
      messageProvider: provider,
      scrollController: AutoScrollController(
        axis: Axis.vertical,
        suggestedRowHeight: 200,
      ),
      appBarStateController: AppBarStateController(widget.vRoom),
      inputStateController: InputStateController(widget.vRoom),
      itemController: VMessageItemController(
        provider,
        widget.context ?? context,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBarStateWidget(
          controller: controller,
        ),
      ),
      body: Container(
        decoration: context.vMessageTheme.scaffoldDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const VSocketStatusWidget(
              delay: Duration.zero,
            ),
            MessageBodyStateWidget(
              controller: controller,
              roomType: widget.vRoom.roomType,
            ),
            const SizedBox(
              height: 5,
            ),
            InputWidgetState(
              controller: controller,
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }
}
