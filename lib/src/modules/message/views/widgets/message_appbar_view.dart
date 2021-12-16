import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:textless/textless.dart';
import '../../../../enums/room_type.dart';
import '../../../../enums/room_typing_type.dart';
import '../../../../services/v_chat_app_service.dart';
import '../../../../utils/custom_widgets/circle_image.dart';
import '../../../rooms/cubit/room_cubit.dart';

class MessageAppBarView extends StatelessWidget implements PreferredSizeWidget {
  const MessageAppBarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final roomController = RoomCubit.instance;
    return AppBar(
      centerTitle: true,
      elevation: 1,
      title: BlocBuilder<RoomCubit, RoomState>(
        bloc: RoomCubit.instance,
        builder: (context, state) {
          try {
            final _room = roomController.rooms.firstWhere(
              (element) => element.id == roomController.currentRoomId!,
            );
            if (state is RoomLoaded) {
              final isOnline = _room.isOnline;
              final typingSt = _room.typingStatus;
              final isSingle = _room.roomType == RoomType.single;
              final t = VChatAppService.instance.getTrans(context);
              return Column(
                children: [
                  _room.title.text,
                  Builder(
                    builder: (_) {
                      if (isSingle) {
                        if (typingSt.status != RoomTypingType.stop) {
                          if (typingSt.status == RoomTypingType.typing) {
                            return t.typing().b2.color(Colors.green);
                          }
                          if (typingSt.status == RoomTypingType.recording) {
                            return t.recording().b2.color(Colors.green);
                          }
                          return "${typingSt.status.inString} ..."
                              .b2
                              .color(Colors.green);
                        }
                        if (isOnline == 1) {
                          return t.online().b2;
                        } else {
                          return const SizedBox.shrink();
                        }
                      } else {
                        if (typingSt.status != RoomTypingType.stop) {
                          return "${typingSt.name} ${t.isTranslate()} ${typingSt.status.inString} ..."
                              .b2
                              .color(Colors.green);
                        } else {
                          return "${_room.roomMembersCount.toString()} - ${VChatAppService.instance.maxGroupChatUsers}"
                              .b2
                              .height(1.6);
                        }
                      }
                    },
                  ),
                ],
              );
            }
            return _room.title.text;
          } catch (er) {
            Navigator.pop(context);
            rethrow;
          }
        },
      ),
      actions: [
        Center(
          child: BlocBuilder<RoomCubit, RoomState>(
            bloc: RoomCubit.instance,
            builder: (context, state) {
              final _room = roomController.rooms.firstWhere(
                (element) => element.id == roomController.currentRoomId!,
              );
              return Padding(
                padding: const EdgeInsets.only(right: 5),
                child: InkWell(
                  onTap: () async {
                    if (roomController.onMessageAvatarPressed != null) {
                      final _room = roomController.rooms.firstWhere(
                        (element) =>
                            element.id == roomController.currentRoomId!,
                      );
                      if (_room.roomType == RoomType.single) {
                        roomController.onMessageAvatarPressed!(
                          false,
                          _room.ifSinglePeerEmail!,
                          null,
                        );
                      } else {
                        roomController.onMessageAvatarPressed!(
                          true,
                          _room.id,
                          _room.groupSetting,
                        );
                      }
                    }
                  },
                  child: CircleImage.network(
                    path: _room.thumbImage,
                    radius: 25,
                    withSetting: _room.roomType == RoomType.groupChat,
                    isOnline: _room.isOnline == 1,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
