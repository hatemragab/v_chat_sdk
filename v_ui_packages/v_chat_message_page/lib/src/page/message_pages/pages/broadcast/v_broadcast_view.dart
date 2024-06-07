// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:v_chat_message_page/src/page/message_pages/pages/broadcast/broadcast_app_bar_controller.dart';
import 'package:v_chat_message_page/src/page/message_pages/pages/broadcast/v_broadcast_controller.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../../../v_chat_message_page.dart';
import '../../../../v_chat/v_search_app_bare.dart';
import '../../../../v_chat/v_socket_status_widget.dart';
import '../../../../widgets/app_bare/v_message_app_bare.dart';
import '../../controllers/v_message_item_controller.dart';
import '../../providers/message_provider.dart';
import '../../states/input_state_controller.dart';
import '../../widget_states/input_widget_state.dart';
import '../../widget_states/message_body_state_widget.dart';

class VBroadcastView extends StatefulWidget {
  const VBroadcastView({
    super.key,
    required this.vRoom,
    required this.vMessageConfig,
    required this.language,
  });
  final VRoom vRoom;
  final VMessageConfig vMessageConfig;
  final VMessageLocalization language;

  @override
  State<VBroadcastView> createState() => _VBroadcastViewState();
}

class _VBroadcastViewState extends State<VBroadcastView> {
  late final VBroadcastController controller;

  @override
  void initState() {
    super.initState();
    final provider = MessageProvider();
    controller = VBroadcastController(
      vRoom: widget.vRoom,
      vMessageConfig: widget.vMessageConfig,
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
        language: widget.language,
        vMessageConfig: widget.vMessageConfig,
      ),
      broadcastAppBarController: BroadcastAppBarController(
        messageProvider: provider,
        vRoom: widget.vRoom,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ValueListenableBuilder<BroadcastAppBarStateModel>(
          valueListenable: controller.broadcastAppBarController,
          builder: (_, value, __) {
            if (value.isSearching) {
              return VSearchAppBare(
                onClose: controller.onCloseSearch,
                onSearch: controller.onSearch,
                searchLabel: widget.language.search,
              );
            }
            return VMessageAppBare(
              isCallAllowed: false,
              language: widget.language,
              onSearch: controller.onOpenSearch,
              memberCount: value.members,
              room: widget.vRoom,
              inTypingText: (context) {
                return null;
              },
              // onViewMedia: () => controller.onViewMedia(context, value.roomId),
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
              VSocketStatusWidget(
                connectingLabel: widget.language.connecting,
                delay: Duration.zero,
              ),
            MessageBodyStateWidget(
              language: widget.language,
              controller: controller,
              roomType: widget.vRoom.roomType,
            ),
            const SizedBox(
              height: 5,
            ),
            InputWidgetState(
              controller: controller,
              language: widget.language,
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
