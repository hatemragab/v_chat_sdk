import 'package:example/controllers/home_controller.dart';
import 'package:example/models/user.dart';
import 'package:example/utils/custom_dio.dart';
import 'package:flutter/material.dart';
import 'package:textless/textless.dart';
import '../utils/load_more_type.dart';
import 'user_item.dart';

class UsersSearch extends StatefulWidget {
  const UsersSearch({Key? key}) : super(key: key);

  @override
  _UsersSearchState createState() => _UsersSearchState();
}

class _UsersSearchState extends State<UsersSearch> {
  final users = <User>[];
  LoadMoreStatus loadingStatus = LoadMoreStatus.loaded;

  final scrollController = ScrollController();

  String searchText = "";
  late HomeController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(_scrollListener);
    _controller = HomeController(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Search".text,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              keyboardType: TextInputType.text,
              autofocus: true,
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  searchText = value;
                  search(value);
                } else {
                  searchText = "";
                  setState(() {
                    users.clear();
                  });
                }
              },
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Scrollbar(
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: users.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) => UserItem(
                    user: users[index],
                    controller: _controller,
                  ),
                ),
              ),
            )
          ],
        ),
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
    final loadedRooms = await loadMoreApi(users.last.id);
    loadingStatus = LoadMoreStatus.loaded;
    if (loadedRooms.isEmpty) {
      loadingStatus = LoadMoreStatus.completed;
    }
    users.addAll(loadedRooms);
    setState(() {});
  }

  Future<List<User>> loadMoreApi(String lastId) async {
    final roomsMaps = (await CustomDio().send(
            reqMethod: "GET",
            path: "user/search",
            query: {"query": searchText, "lastId": lastId}))
        .data['data'] as List;
    return roomsMaps.map((e) => User.fromMap(e)).toList();
  }

  Future search(String txt) async {
    final res = (await CustomDio().send(
            reqMethod: "get",
            path: "user/search",
            query: {"query": txt, "lastId": "first"}))
        .data['data'] as List;

    setState(() {
      users.clear();
      users.addAll(res.map((e) => User.fromMap(e)).toList());
    });
  }
}
