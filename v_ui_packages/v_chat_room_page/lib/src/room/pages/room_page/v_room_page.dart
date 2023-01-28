library v_room_page;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:v_chat_room_page/src/room/pages/room_page/room_provider.dart';
import 'package:v_chat_room_page/src/room/pages/room_page/states/room_state_controller.dart';
import 'package:v_chat_room_page/src/room/pages/room_page/states/room_stream_state.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';
import 'package:v_chat_utils/v_chat_utils.dart';
import '../../widgets/room_item/room_item_controller.dart';
import 'package:loadmore/loadmore.dart';
import '../../../../v_chat_room_page.dart';

part './v_room_controller.dart';

class VChatPage extends StatefulWidget {
  const VChatPage({
    Key? key,
    required this.controller,
    this.floatingActionButton,
    this.appBar,
    this.onRoomItemPress,
    required this.context,
    this.useIconForRoomItem = false,
  }) : super(key: key);
  final VRoomController controller;
  final Function(VRoom room)? onRoomItemPress;
  final BuildContext context;

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
    widget.controller._init(widget.context);
    super.initState();
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
            const VSocketStatusWidget(padding: EdgeInsets.all(5)),
            ValueListenableBuilder<VPaginationModel<VRoom>>(
              valueListenable: widget.controller._roomState,
              builder: (_, value, __) {
                return Expanded(
                  child: LoadMore(
                    onLoadMore: widget.controller._onLoadMore,
                    isFinish: widget.controller._getIsFinishLoadMore(),
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
