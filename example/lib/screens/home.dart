import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/generated/l10n.dart';
import 'package:example/screens/setting_screen.dart';
import 'package:example/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:textless/textless.dart';
import 'package:v_chat_sdk/v_chat_sdk.dart';
import '../controllers/home_controller.dart';
import 'package:get_storage/get_storage.dart';
import '../models/user.dart';
import 'app_rooms_screen.dart';
import 'user_profile_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

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
    _controller = HomeController(context);
    getUsers();

    if (GetStorage().hasData("myModel")) {
      // this mean my user has auth so i will bind chat controller to make him online else will throw exception
      VChatController.instance.bindChatControllers();
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _childrenAppBars = [
      AppBar(
        title: S.of(context).thisDataFromMyServerNotVchat.text,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () async {

                final users = await _controller.getUsers();
                _usersList.clear();
                _usersList.addAll(users);
                setState(() {});
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      AppBar(
        title: S.of(context).myGreatRooms.text,
      ),
      AppBar(
        title: S.of(context).settings.text,
      )
    ];
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    _children = [homeTab(), const VChatRoomsView(), const SettingScreen()];
    // MyApp.of(context)!.randomLocale();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AppRoomsScreen(),
              ));
        },
        child: const Icon(Icons.mail),
      ),
      appBar: PreferredSize(
        child: _childrenAppBars[_currentIndex],
        preferredSize: const Size.fromHeight(kToolbarHeight),
      ),
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
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

  void getUsers() async {
    final users = await _controller.getUsers();
    _usersList.clear();
    _usersList.addAll(users);
    updateTabs();
    setState(() {});
  }

  void updateTabs() {
    _children = [homeTab(), const VChatRoomsView(), const SettingScreen()];
  }

  Widget homeTab() {
    //return Center(child: Text("click on chat icon to see chats"));
    return ListView.separated(
        padding: const EdgeInsets.all(10),
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
              trailing: InkWell(
                  onTap: () {
                    _controller.startChat(_usersList[index].email);
                  },
                  child: const Icon(Icons.message)),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: CachedNetworkImage(
                  imageUrl: baseImgUrl + _usersList[index].imageThumb,
                  height: 100,
                  width: 60,
                  fit: BoxFit.cover,
                ),
              ),
            ),
        separatorBuilder: (context, index) => const Divider(),
        itemCount: _usersList.length);
  }
}
