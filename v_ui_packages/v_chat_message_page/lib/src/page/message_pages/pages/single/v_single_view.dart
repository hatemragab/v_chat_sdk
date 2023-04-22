// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:v_chat_message_page/src/page/message_pages/pages/single/single_app_bar_controller.dart';
import 'package:v_chat_message_page/src/page/message_pages/pages/single/v_single_controller.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../../../v_chat_message_page.dart';
import '../../../../widgets/app_bare/v_message_app_bare.dart';
import '../../controllers/v_message_item_controller.dart';
import '../../providers/message_provider.dart';
import '../../states/input_state_controller.dart';
import '../../widget_states/input_widget_state.dart';
import '../../widget_states/message_body_state_widget.dart';

class VSingleView extends StatefulWidget {
  const VSingleView({
    Key? key,
    required this.vRoom,
    required this.vMessageConfig,
  }) : super(key: key);
  final VRoom vRoom;
  final VMessageConfig vMessageConfig;

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
      vMessageConfig: widget.vMessageConfig,
      singleAppBarController: SingleAppBarController(
        vRoom: widget.vRoom,
        messageProvider: provider,
      ),
      context: context,
      messageProvider: provider,
      scrollController: AutoScrollController(
        axis: Axis.vertical,
        suggestedRowHeight: 200,
      ),
      inputStateController: InputStateController(widget.vRoom),
      itemController: VMessageItemController(
        messageProvider: provider,
        context: context,
        vMessageConfig: widget.vMessageConfig,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ValueListenableBuilder<SingleAppBarStateModel>(
          valueListenable: controller.singleAppBarController,
          builder: (_, value, __) {
            if (value.isSearching) {
              return VSearchAppBare(
                onClose: controller.onCloseSearch,
                onSearch: controller.onSearch,
              );
            }
            return VMessageAppBare(
              isCallAllowed: widget.vMessageConfig.isCallsAllowed,
              onSearch: controller.onOpenSearch,
              room: widget.vRoom,
              inTypingText: value.typingText,
              lastSeenAt: value.lastSeenAt,
              onUpdateBlock: controller.onUpdateBlock,
              onCreateCall: controller.onCreateCall,
              onViewMedia: () => controller.onViewMedia(context, value.roomId),
              onTitlePress: controller.onTitlePress,
            );
          },
        ),
      ),
      body: Container(
        decoration: context.vMessageTheme.scaffoldDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.vMessageConfig.showDisconnectedWidget)
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
