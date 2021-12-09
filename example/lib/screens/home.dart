import 'package:example/generated/l10n.dart';
import 'package:example/screens/choose_group_members/choose_group_members_screen.dart';
import 'package:example/screens/setting_screen.dart';
import 'package:example/screens/user_item.dart';
import 'package:example/screens/users_search.dart';
import 'package:example/utils/custom_dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:textless/textless.dart';
import 'package:v_chat_sdk/v_chat_sdk.dart';
import '../utils/load_more_type.dart';
import '../controllers/home_controller.dart';
import '../models/user.dart';
import 'app_rooms_screen.dart';

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
  LoadMoreStatus loadingStatus = LoadMoreStatus.loaded;

  final scrollController = ScrollController();

  String searchText = "";

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
    //here user will be online this must be init one user authenticated
    _controller = HomeController(context);
    getUsers();

    if (GetStorage().hasData("myModel")) {
      // this mean my user has auth so i will bind chat controller to make him online else will throw exception
      VChatController.instance.bindChatControllers(
          context: context, email: GetStorage().read("myModel")['email']);
    }
  }

  @override
  Widget build(BuildContext context) {
    _children = [
      usersTab(),
      VChatRoomsView(
        onMessageAvatarPressed: (uniqueId) {
          print("xxxxxxxxxxxxxxxxxxxxxxxxxxx $uniqueId");
        },
      ),
      const SettingScreen()
    ];
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

  void _scrollListener() async {
    if (scrollController.offset >=
            scrollController.position.maxScrollExtent / 2 &&
        !scrollController.position.outOfRange &&
        loadingStatus != LoadMoreStatus.loading &&
        loadingStatus != LoadMoreStatus.completed) {
      loadingStatus = LoadMoreStatus.loading;
      loadMore();
    }
  }

  Future<void> loadMore() async {
    final loadedRooms = await loadMoreApi(_usersList.last.id);
    loadingStatus = LoadMoreStatus.loaded;
    if (loadedRooms.isEmpty) {
      loadingStatus = LoadMoreStatus.completed;
    }
    _usersList.addAll(loadedRooms);
    setState(() {});
  }

  Future<List<User>> loadMoreApi(String lastId) async {
    final roomsMaps = (await CustomDio()
            .send(reqMethod: "get", path: "user", query: {"lastId": lastId}))
        .data['data'] as List;
    return roomsMaps.map((e) => User.fromMap(e)).toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _childrenAppBars = [
      AppBar(
        title: "v chat users".text,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UsersSearch(),
                    ));
              },
              icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () async {
                final users = await _controller.getUsers();
                _usersList.clear();
                _usersList.addAll(users);
                setState(() {});
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
        title: S.of(context).myGreatRooms.text,
        centerTitle: true,
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

  void getUsers() async {
    final users = await _controller.getUsers();
    _usersList.clear();
    _usersList.addAll(users);
    updateTabs();
    setState(() {});
  }

  void updateTabs() {
    _children = [
      usersTab(),
      VChatRoomsView(
        onMessageAvatarPressed: (uniqueId) {
          print("xxxxxxxxxxxxxxxxxxxxxxxxxxx $uniqueId");
        },
      ),
      const SettingScreen()
    ];
  }

  Widget usersTab() {
    //return Center(child: Text("click on chat icon to see chats"));
    return Scrollbar(
      child: ListView.separated(
          controller: scrollController,
          padding: const EdgeInsets.all(10),
          itemBuilder: (context, index) => UserItem(
                user: _usersList[index],
                controller: _controller,
              ),
          separatorBuilder: (context, index) => const Divider(),
          itemCount: _usersList.length),
    );
  }
}
