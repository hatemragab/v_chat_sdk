import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loadmore/loadmore.dart';
import 'package:textless/textless.dart';
import '../../../enums/room_type.dart';
import '../../../services/v_chat_app_service.dart';
import '../../../utils/custom_widgets/circle_image.dart';
import '../../../utils/custom_widgets/connection_checker.dart';
import '../../rooms/cubit/room_cubit.dart';
import '../cubit/message_cubit.dart';
import 'list_view_widgets/message_item_view.dart';
import 'widgets/message_appbar_view.dart';
import 'widgets/new_chat_input/v_chat_message_input.dart';

class MessageView extends StatelessWidget {
  final int roomId;

  const MessageView({Key? key, required this.roomId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MessageCubit()..getLocalMessages(roomId),
      lazy: false,
      child: const MessageViewScreen(),
    );
  }
}

class MessageViewScreen extends StatefulWidget {
  const MessageViewScreen({Key? key}) : super(key: key);

  @override
  _MessageViewScreenState createState() => _MessageViewScreenState();
}

class _MessageViewScreenState extends State<MessageViewScreen> {
  final roomController = RoomCubit.instance;
  final myId = VChatAppService.instance.vChatUser!.id;

  @override
  Widget build(BuildContext context) {
    final t = VChatAppService.instance.getTrans(context);
    final messageController = context.read<MessageCubit>();

    return Scaffold(
      appBar: MessageAppBarView(),
      body: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 1, top: 4),
        child: Column(
          children: [
            const ConnectionChecker(),
            const SizedBox(
              height: 6,
            ),
            Expanded(
              child: BlocBuilder<MessageCubit, MessageState>(
                builder: (context, state) {
                  final v = VChatAppService.instance.getTrans(context);
                  return Builder(
                    builder: (c) {
                      if (state is MessageLoaded) {
                        final messagesList = state.messages;
                        return Scrollbar(
                          showTrackOnHover: true,
                          child: LoadMore(
                            textBuilder: (status) {
                              switch (status) {
                                case LoadMoreStatus.idle:
                                  return "";
                                case LoadMoreStatus.loading:
                                  return '';

                                case LoadMoreStatus.fail:
                                  return v.loadMoreFiled();

                                case LoadMoreStatus.nomore:
                                  return "";
                              }
                            },
                            isFinish:
                                context.read<MessageCubit>().isLoadMoreFinished,
                            onLoadMore:
                                context.read<MessageCubit>().loadMoreMessages,
                            child: ListView.separated(
                              reverse: true,
                              controller:
                                  context.read<MessageCubit>().scrollController,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) => MessageItemView(
                                index: index,
                                message: messagesList[index],
                                myId: myId,
                              ),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 8,
                              ),
                              itemCount: messagesList.length,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  );
                },
              ),
            ),
            BlocBuilder<RoomCubit, RoomState>(
              bloc: RoomCubit.instance,
              builder: (context, state) {
                final _room = roomController.rooms.firstWhere(
                    (element) => element.id == messageController.roomId);
                if (state is RoomLoaded) {
                  if (_room.roomType == RoomType.single) {
                    if (_room.lastMessage.senderId != myId) {
                      return const SizedBox.shrink();
                    }
                    if (_room.lastMessageSeenBy.length == 2) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 3,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: CircleImage.network(
                                path: _room.thumbImage, radius: 10),
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  }
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(
              height: 2,
            ),
            SafeArea(
              child: BlocBuilder<RoomCubit, RoomState>(
                bloc: RoomCubit.instance,
                builder: (context, state) {
                  final _room = roomController.rooms.firstWhere(
                      (element) => element.id == messageController.roomId);

                  if (state is RoomLoaded) {
                    final bkId = _room.blockerId;
                    if (bkId != 0) {
                      if (bkId == myId) {
                        // i the blocker
                        return t.chatHasBeenClosedByMe().h6.color(Colors.red);
                      } else {
                        return t.chatHasBeenClosed().h6.color(Colors.red);
                      }
                    }
                  }

                  return VChatMessageInput(
                    controller: messageController.textController,
                    onReceiveRecord: (path, duration) {
                      messageController.emitTypingChange(0);
                      messageController.sendVoiceNote(context,path, duration);
                    },
                    onReceiveText: () {
                      messageController.sendTextMessage();
                    },
                    onCancelRecord: () {
                      messageController.emitTypingChange(0);
                    },
                    onStartRecording: () {
                      messageController.emitTypingChange(3);
                    },
                    onReceiveImage: (path) {
                      messageController.sendImage(context,path);
                    },
                    onReceiveVideo: (path) {
                      messageController.sendVideo(context,path);
                    },
                    onReceiveFile: (path) {
                      messageController.sendFile(context,path);
                    },
                  );
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
