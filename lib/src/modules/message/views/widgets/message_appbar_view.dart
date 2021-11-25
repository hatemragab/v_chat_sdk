import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:textless/textless.dart';

import '../../../../enums/room_type.dart';
import '../../../../enums/room_typing_type.dart';
import '../../../../services/v_chat_app_service.dart';
import '../../../../utils/custom_widgets/circle_image.dart';
import '../../../rooms/cubit/room_cubit.dart';

class MessageAppBarView extends StatelessWidget implements PreferredSizeWidget {
  final roomController = RoomCubit.instance;

  MessageAppBarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: Theme.of(context).appBarTheme.elevation,
      centerTitle: Theme.of(context).appBarTheme.centerTitle,

      title: BlocBuilder<RoomCubit, RoomState>(
        bloc: RoomCubit.instance,
        builder: (context, state) {
          final _room = roomController.rooms.firstWhere(
              (element) => element.id == roomController.currentRoomId!);
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
                          return t.typing().s2;
                        }
                        if (typingSt.status == RoomTypingType.recording) {
                          return t.recording().s2.color(Colors.black);
                        }
                        return "${typingSt.status.inString} ...".s2;
                      }
                      if (isOnline == 1) {
                        return t.online().text.size(14);
                      } else {
                        return const SizedBox.shrink();
                      }
                    } else {
                      if (typingSt.status != RoomTypingType.stop) {
                        return "${typingSt.name} is ${typingSt.status.inString} ..."
                            .s2
                            .size(14);
                      } else {
                        return const SizedBox();
                      }
                    }
                  },
                ),
              ],
            );
          }
          return _room.title.text;
        },
      ),
      actions: [
        Center(
          child: BlocBuilder<RoomCubit, RoomState>(
            bloc: RoomCubit.instance,
            builder: (context, state) {
              final _room = roomController.rooms.firstWhere(
                  (element) => element.id == roomController.currentRoomId!);
              return Padding(
                padding: const EdgeInsets.only(right: 5),
                child: InkWell(
                  onTap: () {
                    //todo call back when icon clicked
                  },
                  child: CircleImage.network(
                      path: _room.thumbImage,
                      radius: 25,
                      isOnline: _room.isOnline == 1),
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
