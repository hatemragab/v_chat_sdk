// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_chat_room_page/v_chat_room_page.dart';
import 'package:v_platform/v_platform.dart';

import '../../../../../generated/l10n.dart';
import '../controllers/chats_tab_controller.dart';
import '../web_chat_scaffold.dart';

class ChatsTabView extends GetView<ChatsTabController> {
  ChatsTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (VPlatforms.isWeb) {
      return Scaffold(
        body: Row(
          children: [
            SizedBox(
              width: 300,
              child: VChatPage(
                language: VRoomLanguage.fromEnglish(),
                appBar: AppBar(
                  title: Text("start chat"),
                ),
                controller: controller.vRoomController,
                useIconForRoomItem: false,
                onRoomItemPress: (room) {
                  controller.vRoomController.setRoomSelected(room.id);
                  vWebChatNavigation.key.currentState!
                      .pushReplacementNamed(ChatRoute.route, arguments: room);
                },
              ),
            ),
            Container(
              width: 5,
              color: Colors.black12,
            ),
            Flexible(
              child: Navigator(
                key: vWebChatNavigation.key,
                onGenerateRoute: vWebChatNavigation.onGenerateRoute,
                initialRoute: IdleRoute.route,
              ),
            )
          ],
        ),
      );
    }
    return VChatPage(
      useIconForRoomItem: false,
      appBar: AppBar(
        title: const Text('Chats Tab View'),
        centerTitle: true,
      ),
      language: VRoomLanguage(
        cancel: S.of(context).cancel,
        ok: S.of(context).ok,
        areYouSureToLeaveThisGroupThisActionCantUndo:
            S.of(context).areYouSureToLeaveThisGroupThisActionCantUndo,
        areYouSureToPermitYourCopyThisActionCantUndo:
            S.of(context).areYouSureToPermitYourCopyThisActionCantUndo,
        connecting: S.of(context).connecting,
        delete: S.of(context).delete,
        deleteYouCopy: S.of(context).deleteYouCopy,
        leaveGroup: S.of(context).leaveGroup,
        leaveGroupAndDeleteYourMessageCopy:
            S.of(context).leaveGroupAndDeleteYourMessageCopy,
        messageHasBeenDeletedLabel: S.of(context).messageHasBeenDeletedLabel,
        mute: S.of(context).mute,
        recording: S.of(context).recording,
        report: S.of(context).report,
        typing: S.of(context).typing,
        unMute: S.of(context).unMute,
        vMessageInfoTrans: VMessageInfoTrans(
          addedYouToNewBroadcast: S.of(context).addedYouToNewBroadcast,
          dismissedToMemberBy: S.of(context).dismissedToMemberBy,
          groupCreatedBy: S.of(context).groupCreatedBy,
          joinedBy: S.of(context).joinedBy,
          kickedBy: S.of(context).kickedBy,
          leftTheGroup: S.of(context).leftTheGroup,
          promotedToAdminBy: S.of(context).promotedToAdminBy,
          updateImage: S.of(context).updateImage,
          updateTitleTo: S.of(context).updateTitleTo,
          you: S.of(context).you,
        ),
        yesterdayLabel: S.of(context).yesterdayLabel,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.onCreateGroupOrBroadcast,
        child: const Icon(Icons.add),
      ),
      controller: controller.vRoomController,
    );
  }
}
