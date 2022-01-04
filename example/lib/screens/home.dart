import 'package:example/controllers/home_controller.dart';
import 'package:example/generated/l10n.dart';
import 'package:example/screens/choose_group_members/choose_group_members_screen.dart';
import 'package:example/screens/setting_screen.dart';
import 'package:example/screens/user_item.dart';
import 'package:example/screens/users_search.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:textless/textless.dart';
import 'package:v_chat_sdk/v_chat_sdk.dart';

import 'group_chat_info/group_chat_info.dart';

/// this is just example you can define your own design
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();

    /// make sure you init v chat in the home to start receive notifications
    context.read<HomeController>().getUsers(context);
    context.read<HomeController>().init(context);
  }

  @override
  Widget build(BuildContext context) {
    final _controller = context.watch<HomeController>();

    /// this is just example you can define your own design
    /// navigation tabs
    final tabs = [
      usersTab(),
      VChatRoomsView(
        onMessageAvatarPressed: (isGroupChat, uniqueId, vChatGroupChatInfo) {
          if (isGroupChat) {
            print("isGroupChat id is $uniqueId");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => GroupChatInfo(
                  groupId: uniqueId,
                  groupChatInfo: vChatGroupChatInfo!,
                ),
              ),
            );
          } else {
            print("user Email  is $uniqueId");
          }
        },
      ),
      const SettingScreen()
    ];

    /// this is just example you can define your own design
    /// navigation appbar
    final childrenAppBars = [
      AppBar(
        title: S.of(context).vChatUsers.text,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UsersSearch(),
                  ),
                );
              },
              icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () async {
                await _controller.getUsers(context);
              },
              icon: const Icon(Icons.refresh)),
          IconButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChooseGroupMembersPage(),
                  ),
                );
              },
              icon: const Icon(Icons.group))
        ],
      ),
      AppBar(
        title: S.of(context).chats.text,
        centerTitle: true,
      ),
      AppBar(
        title: S.of(context).settings.text,
      )
    ];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChooseGroupMembersPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: PreferredSize(
        child: childrenAppBars[_controller.navigationTabsIndex],
        preferredSize: const Size.fromHeight(kToolbarHeight),
      ),
      body: tabs[_controller.navigationTabsIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _controller.onTabTapped,
        currentIndex: _controller.navigationTabsIndex,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: S.of(context).home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.mail),
            label: S.of(context).chats,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: S.of(context).settings,
          ),
        ],
      ),
    );
  }

  Widget usersTab() {
    final _controller = context.watch<HomeController>();
    return Scrollbar(
      child: ListView.separated(
        controller: _controller.scrollController,
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) => UserItem(
          user: _controller.usersList[index],
        ),
        separatorBuilder: (context, index) => const Divider(),
        itemCount: _controller.usersList.length,
      ),
    );
  }
}
