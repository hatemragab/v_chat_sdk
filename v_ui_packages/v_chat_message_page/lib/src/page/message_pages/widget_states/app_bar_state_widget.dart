// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:v_chat_message_page/src/page/message_pages/controllers/v_base_message_controller.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

import '../../../models/app_bare_state_model.dart';
import '../../../widgets/app_bare/v_message_app_bare.dart';
import '../pages/single/v_single_controller.dart';

class AppBarStateWidget extends StatelessWidget {
  final VBaseMessageController controller;

  const AppBarStateWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<MessageAppBarStateModel>(
      valueListenable: controller.appBarStateController,
      builder: (context, value, child) {
        if (value.isSearching) {
          return VSearchAppBare(
            onClose: controller.onCloseSearch,
            onSearch: controller.onSearch,
          );
        }
        return VMessageAppBare(
          state: value,
          isCallsAllow: VChatController.I.vChatConfig.isCallsAllowed,
          onSearch: controller.onOpenSearch,
          onUpdateBlock: (isBlocked) {
            if (controller is VSingleController) {
              final x = controller as VSingleController;
              x.onUpdateBlock(isBlocked);
            }
          },
          onCreateCall: (isVideo) {
            if (controller is VSingleController) {
              final x = controller as VSingleController;
              x.onCreateCall(isVideo);
            }
          },
          onViewMedia: () => controller.onViewMedia(context, value.roomId),
          onTitlePress: controller.onTitlePress,
        );
      },
    );
  }
}
