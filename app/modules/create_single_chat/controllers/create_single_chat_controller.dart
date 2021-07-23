import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../vchat_controller.dart';
import '../../../enums/load_more_type.dart';
import '../../../models/vchat_user.dart';
import '../providers/create_single_chat_provider.dart';

class CreateSingleChatController extends GetxController
    with StateMixin<List<VChatUser>> {
  final _provider = Get.find<CreateSingleChatProvider>();
  final scrollController = ScrollController();
  final loadingStatus = LoadMoreStatus.loaded.obs;
  final alertTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
    getUsers();
  }

  Future getUsers() async {
    final users = await _provider.getUsers(0);
    if (users.isEmpty) {
      change([], status: RxStatus.empty());
    }
    change(users, status: RxStatus.success());
  }

  Future loadMoreUsers(int lastId) async {
    final users = await _provider.getUsers(lastId);
    loadingStatus.value = LoadMoreStatus.loaded;
    if (users.isEmpty) {
      loadingStatus.value = LoadMoreStatus.completed;
    }
    state!.addAll(users);
    refresh();
  }

  void onUserItemClicked(BuildContext context, VChatUser peer) async {
    try {
      //catch any Error will happen from api side you cant chat your self
      await VChatController.instance
          .createSingleChat(ctx: context, peerEmail: peer.email);
    } catch (err) {
      rethrow;
    }
  }

  @override
  void onClose() {
    super.onClose();
    alertTextController.dispose();
  }

  void _scrollListener() async {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange &&
        loadingStatus.value != LoadMoreStatus.loading &&
        loadingStatus.value != LoadMoreStatus.completed) {
      loadingStatus.value = LoadMoreStatus.loading;
      loadMoreUsers(state!.last.id);
    }
  }
}
