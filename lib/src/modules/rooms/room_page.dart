import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:textless/textless.dart';
import 'package:v_chat_sdk/src/models/v_chat_group_chat_info.dart';
import 'package:v_chat_sdk/src/services/v_chat_app_service.dart';
import '../../utils/custom_widgets/connection_checker.dart';
import 'cubit/room_cubit.dart';
import 'widgets/room_item.dart';

/// [isGroupChat] will be true only if the current chat is group
/// [isGroupChat] == false then [uniqueId] will be the unique id of user witch you send to v chat while register then you can redirect it to user profile
/// And [vChatGroupChatInfo] will be null
/// [isGroupChat] == true then the [uniqueId] is the group id you will need to send it to the group apis like update and add users
/// And [vChatGroupChatInfo] will be the group Data
/// you can navigate to this page and define your appbar
///
/// ```dart
///   Navigator.of(context).push(
///       MaterialPageRoute(
///         builder: (_) => Scaffold(
///          appBar: AppBar(),
///           body: const VChatRoomsView(),
///         ),
///       ),
///     );
///```
///
/// ** Make sure to call this widget only if user has `authenticated` to v chat other will throw exception **
class VChatRoomsView extends StatelessWidget {
  final void Function(
    bool isGroupChat,
    String uniqueId,
    VChatGroupChatInfo? vChatGroupChatInfo,
  )? onMessageAvatarPressed;

  const VChatRoomsView({Key? key, this.onMessageAvatarPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: RoomCubit.instance
        ..onMessageAvatarPressed = onMessageAvatarPressed
        ..context = context,
      child: const VChatRoomsScreen(),
    );
  }
}

class VChatRoomsScreen extends StatelessWidget {
  const VChatRoomsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RoomCubit.instance.setListViewListener();
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const ConnectionChecker(),
          const SizedBox(
            height: 12,
          ),
          BlocBuilder<RoomCubit, RoomState>(
            builder: (context, state) {
              if (state is RoomInitial) {
                return const SizedBox.shrink();
              } else if (state is RoomEmpty) {
                return Center(
                  child: VChatAppService.instance
                      .getTrans(context)
                      .noChatsYet()
                      .h6
                      .color(Colors.red),
                );
              } else if (state is RoomLoading) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else if (state is RoomLoaded) {
                final rooms = state.rooms;
                return Expanded(
                  child: Scrollbar(
                    child: ListView.separated(
                      controller: context.read<RoomCubit>().scrollController,
                      physics: const BouncingScrollPhysics(),
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 8,
                      ),
                      key: const PageStorageKey<String>('RoomsTabView'),
                      padding: const EdgeInsets.all(8.0),
                      itemBuilder: (context, index) {
                        return Material(
                          child: SizedBox(
                            height: 70,
                            child: RoomItem(rooms[index]),
                          ),
                        );
                      },
                      itemCount: rooms.length,
                    ),
                  ),
                );
              }
              throw UnimplementedError();
            },
          ),
        ],
      ),
    );
  }
}
