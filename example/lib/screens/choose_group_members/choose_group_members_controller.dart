import 'package:example/models/user.dart';
import 'package:example/screens/create_group/create_group_page.dart';
import 'package:example/utils/custom_alert.dart';
import 'package:example/utils/custom_dio.dart';
import 'package:example/utils/load_more_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

class ChooseGroupMembersController extends ChangeNotifier {
  late BuildContext context;
  final users = <User>[];
  LoadMoreStatus loadingStatus = LoadMoreStatus.loaded;

  final scrollController = ScrollController();
  final myModel = GetStorage().read("myModel");

  ChooseGroupMembersController({
    required this.context,
  }) {
    getUsers();
    scrollController.addListener(_scrollListener);
  }

  void updateScreen() {
    notifyListeners();
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
    updateScreen();
  }

  Future<List<User>> loadMoreApi(String lastId) async {
    final roomsMaps = (await CustomDio()
            .send(reqMethod: "get", path: "user", query: {"lastId": lastId}))
        .data['data'] as List;
    return roomsMaps.map((e) => User.fromMap(e)).toList();
  }

  Future<void> getUsers() async {
    try {
      final res = (await CustomDio()
              .send(reqMethod: "get", path: "user", query: {"lastId": "first"}))
          .data['data'] as List;
      users.addAll(res.map((e) => User.fromMap(e)).toList());
      updateScreen();
    } catch (err) {
      CustomAlert.showError(context: context, err: err.toString());
      rethrow;
    }
  }

  void setSelectedUser(User user) {
    final index = users.indexWhere((element) => element.id == user.id);
    if (index != -1) {
      final newUser =
          users[index].copyWith(isSelected: !users[index].isSelected);
      print(newUser.toString());
      users.removeAt(index);
      users.insert(index, newUser);
      updateScreen();
    }
  }

  void next() {
    try {
      isThereUserSelected();
      final seletedUsers = <User>[];
      for (final u in users) {
        if (u.isSelected) {
          seletedUsers.add(u);
        }
      }
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CreateGroupPage(
          users: seletedUsers,
        ),
      ));
    } catch (err) {
      CustomAlert.showError(context: context, err: err.toString());
    }
  }

  void isThereUserSelected() {
    bool isThereSelection = false;
    for (final u in users) {
      if (u.isSelected) {
        if (u.id == myModel['_id']) {
          throw "un select your self from the list";
        }
        isThereSelection = true;
      }
    }
    if (isThereSelection == false) {
      throw "select at lest one user ";
    }
  }
}
