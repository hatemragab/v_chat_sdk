import 'package:flutter/material.dart';
import 'package:loadmore/loadmore.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../../v_chat_room_page.dart';

class VChatPage extends StatefulWidget {
  const VChatPage({
    Key? key,
    required this.controller,
    //this.onRoomItemLongPress,
    this.floatingActionButton,
    this.appBar,
  }) : super(key: key);
  final VRoomController controller;

  // final Function(VRoom room) onRoomItemPress;
  // final Function(VRoom room)? onRoomItemLongPress;
  final Widget? appBar;
  final Widget? floatingActionButton;

  @override
  State<VChatPage> createState() => _VChatPageState();
}

class _VChatPageState extends State<VChatPage> {
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
              valueListenable: widget.controller.roomState,
              builder: (_, value, __) {
                return Expanded(
                  child: LoadMore(
                    onLoadMore: widget.controller.onLoadMore,
                    isFinish: widget.controller.getIsFinishLoadMore(),
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
                              .controller.roomState.roomStateStream.stream
                              .where((e) => e.id == room.id),
                          initialData: room,
                          builder: (context, snapshot) {
                            return VRoomItem(
                              room: snapshot.data!,
                              onRoomItemLongPress: (room) => widget.controller
                                  .onRoomItemLongPress(room, context),
                              onRoomItemPress: (room) => widget.controller
                                  .onRoomItemPress(room, context),
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
