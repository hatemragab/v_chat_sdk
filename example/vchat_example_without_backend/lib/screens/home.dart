import 'package:flutter/material.dart';
import 'package:textless/textless.dart';
import 'package:vchat_test_3/vchat_package/app/modules/room/views/room_tab_appbar_view.dart';
import 'package:vchat_test_3/vchat_package/app/modules/room/views/rooms_tab_view.dart';
import 'package:vchat_test_3/vchat_package/vchat_controller.dart';
import '../controllers/home_controller.dart';
import '../models/user.dart';
import 'user_profile.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late HomeController _controller;
  int _currentIndex = 0;
  late List<Widget> _children;
  late List<Widget> _childrenAppBars;
  final _usersList = <User>[];

  @override
  void initState() {
    super.initState();

    //here user will be online this must be init one user authenticated
    VChatController.instance.bindChatControllers();
    _controller = HomeController(context);
    getUsers();
    _childrenAppBars = [
      AppBar(
        title: "Home".text,
        centerTitle: true,
      ),
      RoomTabAppBarView()
    ];
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    _children = [homeTab(), RoomsTabView()];
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: "Chats as page".text,
                      centerTitle: true,
                    ),
                    body: RoomsTabView()),
              ));
        },
        child: Icon(Icons.mail),
      ),
      appBar: PreferredSize(
        child: _childrenAppBars[_currentIndex],
        preferredSize: const Size.fromHeight(kToolbarHeight),
      ),
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            label: 'Chats',
          ),
        ],
      ),
    );
  }

  void getUsers() async {
    final users = await _controller.getUsers();
    setState(() {
      _usersList.addAll(users);
    });
  }

  Widget homeTab() {
    return Center(child: Text("click on chat icon to see chats"));
    return ListView.separated(
        itemBuilder: (context, index) => ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfile(_usersList[index]),
                  ),
                );
              },
              title: _usersList[index].name.text,
            ),
        separatorBuilder: (context, index) => Divider(),
        itemCount: _usersList.length);
  }
}
