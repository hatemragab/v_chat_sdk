// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

library v_room_page;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loadmore/loadmore.dart';
import 'package:v_chat_room_page/src/room/pages/room_page/room_provider.dart';
import 'package:v_chat_room_page/src/room/pages/room_page/states/room_state_controller.dart';
import 'package:v_chat_room_page/src/room/room.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../shared/stream_mixin.dart';
import 'room_item_controller.dart';

part './v_room_controller.dart';

/// A [StatefulWidget] that represents a page for displaying and managing video chat rooms.
/// /// The [VChatPage] requires a [VRoomController] instance to manage and display rooms.
/// The controller is passed in through the [controller] parameter.
/// /// The [onRoomItemPress] parameter is an optional callback that is called when a room item is pressed.
/// The callback provides a [VRoom] instance representing the room that was pressed.
/// /// The [showDisconnectedWidget] parameter determines whether to show a widget when the user is disconnected from the server.
/// If set to true (which is the default), a [VDisconnectedWidget] will be displayed. Otherwise, nothing will be displayed.
/// /// The [useIconForRoomItem] parameter is an optional parameter that, if set to true, will cause the room list items to display an icon instead of a thumbnail image.
/// /// The [appBar] and [floatingActionButton] parameters are optional, and allow customization of the app bar and action button displayed on the page
class VChatPage extends StatefulWidget {
  const VChatPage({
    Key? key,
    required this.controller,
    this.floatingActionButton,
    this.appBar,
    this.onRoomItemPress,
    this.showDisconnectedWidget = true,
    this.useIconForRoomItem = false,
  }) : super(key: key);
  final VRoomController controller;
  final Function(VRoom room)? onRoomItemPress;
  final bool showDisconnectedWidget;

  // final Function(VRoom room) onRoomItemPress;
  // final Function(VRoom room)? onRoomItemLongPress;
  final Widget? appBar;
  final Widget? floatingActionButton;
  final bool useIconForRoomItem;

  @override
  State<VChatPage> createState() => _VChatPageState();
}

class _VChatPageState extends State<VChatPage> {
  @override
  void initState() {
    super.initState();
    widget.controller._init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.floatingActionButton,
      appBar: widget.appBar == null
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: widget.appBar!,
            ),
      body: Container(
        decoration: context.vRoomTheme.scaffoldDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.showDisconnectedWidget == true)
              const VSocketStatusWidget(padding: EdgeInsets.all(5)),
            ValueListenableBuilder<VPaginationModel<VRoom>>(
              valueListenable: widget.controller._roomState,
              builder: (_, value, __) {
                return Expanded(
                  child: LoadMore(
                    onLoadMore: widget.controller._onLoadMore,
                    isFinish: widget.controller._getIsFinishLoadMore,
                    textBuilder: (status) {
                      return "";
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      physics: const BouncingScrollPhysics(),
                      cacheExtent: 300,
                      itemBuilder: (context, index) {
                        final room = value.values[index];
                        return StreamBuilder<VRoom>(
                          key: UniqueKey(),
                          stream: widget
                              .controller._roomState.roomStateStream.stream
                              .where((e) => e.id == room.id),
                          initialData: room,
                          builder: (context, snapshot) {
                            return VRoomItem(
                              isIconOnly: widget.useIconForRoomItem,
                              room: snapshot.data!,
                              onRoomItemLongPress: (room) => widget.controller
                                  ._onRoomItemLongPress(room, context),
                              onRoomItemPress: (room) {
                                if (widget.onRoomItemPress == null) {
                                  widget.controller
                                      ._onRoomItemPress(room, context);
                                } else {
                                  widget.onRoomItemPress!(room);
                                }
                              },
                            );
                          },
                        );
                      },
                      itemCount: value.values.length,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
