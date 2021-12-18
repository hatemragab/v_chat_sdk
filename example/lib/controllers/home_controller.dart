import 'package:example/generated/l10n.dart';
import 'package:example/utils/load_more_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:textless/textless.dart';
import 'package:v_chat_sdk/v_chat_sdk.dart';
import '../models/user.dart';
import '../utils/custom_alert.dart';
import '../utils/custom_dio.dart';

class HomeController extends ChangeNotifier {
  int currentIndex = 0;

  final usersList = <User>[];
  LoadMoreStatus loadingStatus = LoadMoreStatus.loaded;
  final scrollController = ScrollController();
  String searchText = "";

  void init(BuildContext context) {
    scrollController.addListener(_scrollListener);

    /// here user will be online this must be init one user authenticated
    if (GetStorage().hasData("myModel")) {
      /// this mean my user has auth so i will bind chat controller to make him online else will throw exception
      VChatController.instance.bindChatControllers(
        context: context,
        email: GetStorage().read("myModel")['email'],
      );
    }
  }

  Future getUsers(BuildContext context) async {
    try {
      final res = (await CustomDio()
              .send(reqMethod: "get", path: "user", query: {"lastId": "first"}))
          .data['data'] as List;
      final users = res.map((e) => User.fromMap(e)).toList();
      usersList.clear();
      usersList.addAll(users);
      notifyListeners();
    } catch (err) {
      CustomAlert.showError(context: context, err: err.toString());
      rethrow;
    }
  }

  void startChat(String email, BuildContext context) async {
    try {
      final res =
          await CustomAlert.chatAlert(context: context, peerEmail: email);
      if (res != null) {
        await VChatController.instance
            .createSingleChat(peerEmail: email, message: res,context: context);
        CustomAlert.done(
          msg: S.of(context).success,
        );
      }
    } on VChatSdkException catch (err) {
      CustomAlert.showError(context: context, err: err.toString());
      rethrow;
    }
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

  void onTabTapped(int index) {
    currentIndex = index;
    notifyListeners();
  }

  Future<void> loadMore() async {
    final loadedRooms = await loadMoreApi(usersList.last.id);
    loadingStatus = LoadMoreStatus.loaded;
    if (loadedRooms.isEmpty) {
      loadingStatus = LoadMoreStatus.completed;
    }
    usersList.addAll(loadedRooms);
    notifyListeners();
  }

  Future<List<User>> loadMoreApi(String lastId) async {
    final roomsMaps = (await CustomDio()
            .send(reqMethod: "get", path: "user", query: {"lastId": lastId}))
        .data['data'] as List;
    return roomsMaps.map((e) => User.fromMap(e)).toList();
  }
}
