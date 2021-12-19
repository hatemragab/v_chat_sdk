import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/generated/l10n.dart';
import 'package:example/models/user.dart';
import 'package:example/screens/choose_group_members/choose_group_members_screen.dart';
import 'package:example/utils/custom_alert.dart';
import 'package:example/utils/load_more_type.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:textless/textless.dart';
import 'package:v_chat_sdk/v_chat_sdk.dart';
import 'package:image_picker/image_picker.dart';

/// please Note this is example you can have your own design
class GroupChatInfo extends StatefulWidget {
  final String groupId;
  final VChatGroupChatInfo groupChatInfo;

  const GroupChatInfo(
      {Key? key, required this.groupId, required this.groupChatInfo})
      : super(key: key);

  @override
  _GroupChatInfoState createState() => _GroupChatInfoState(groupChatInfo);
}

class _GroupChatInfoState extends State<GroupChatInfo> {
  final members = <VChatGroupUser>[];
  late bool isMeAdmin;

  /// user paginationIndex and increase it by +1 to get next page
  int paginationIndex = 1;
  final scrollController = ScrollController();
  final myModel = GetStorage().read("myModel");
  LoadMoreStatus loadingStatus = LoadMoreStatus.loaded;
  VChatGroupChatInfo groupChatInfo;

  _GroupChatInfoState(this.groupChatInfo);

  @override
  void initState() {
    scrollController.addListener(_scrollListener);

    /// is current user open the app is admin so you can show or hide update group data
    /// even is it available for not group admin will throw exception
    isMeAdmin = widget.groupChatInfo.isMyAdmin;
    getGroupMembers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: groupChatInfo.isMyAdmin
          ? FloatingActionButton(
              onPressed: () async {
                final users = await Navigator.push<List<User>>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChooseGroupMembersPage(
                      isFromGroupInfo: true,
                    ),
                  ),
                );
                if (users == null) {
                  return;
                }
                try {
                  CustomAlert.customLoadingDialog(context: context);

                  /// add Members To GroupChat will add this users to the group
                  /// will throw exception if current user not admin
                  /// if you chose users already in group noting will happen
                  await VChatController.instance.addMembersToGroupChat(
                      groupId: widget.groupId,
                      usersEmails: users.map((e) => e.email).toList());
                  await getGroupMembers();
                  Navigator.pop(context);
                  CustomAlert.showSuccess(
                    context: context,
                    err: S.of(context).usersHasBeenAddedSuccessfully,
                  );
                } catch (err) {
                  Navigator.pop(context);
                  CustomAlert.showError(context: context, err: err.toString());
                }
              },
              elevation: 0,
              child: Icon(Icons.add),
            )
          : SizedBox(),
      appBar: AppBar(
        title: Column(
          children: [
            groupChatInfo.title.text,
            SizedBox(
              height: 4,
            ),
            "${groupChatInfo.totalGroupMembers} ${S.of(context).members}"
                .toString()
                .cap
                .light
                .color(Colors.white)
          ],
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  if (isMeAdmin) {
                    updateGroupImage();
                  }
                },
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: CachedNetworkImage(
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                        imageUrl: groupChatInfo.imageThumb,
                      ),
                    ),
                    Visibility(
                      visible: isMeAdmin,
                      child: Positioned(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey, shape: BoxShape.circle),
                          child: Icon(
                            Icons.camera,
                            color: Colors.white,
                          ),
                        ),
                        bottom: 1,
                        right: 2,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  updateGroupTitle();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    groupChatInfo.title.text.black.size(22),
                    SizedBox(
                      width: 5,
                    ),
                    Visibility(
                      visible: isMeAdmin,
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit,
                            size: 19,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: CachedNetworkImage(
                              imageUrl: members[index].image,
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              members[index].mame.text,
                              members[index]
                                  .vChatUserGroupRole
                                  .inString
                                  .text
                                  .color(Colors.grey)
                            ],
                          )
                        ],
                      ),
                      Row(
                        children: [
                          widget.groupChatInfo.isMyAdmin
                              ? getAdminTrailing(members[index])
                              : SizedBox()
                        ],
                      )
                    ],
                  );
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: members.length,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
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

  Future getGroupMembers() async {
    this.members.clear();

    /// this api will get group users if current use already member in this group
    final members = await VChatController.instance
        .getGroupMembers(groupId: widget.groupId, paginationIndex: 1);

    setState(() {
      this.members.addAll(members);
    });
  }

  void updateGroupTitle() async {
    var txt = "";
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: S.of(context).title.text,
          content: TextField(
            onChanged: (value) {
              txt = value;
            },
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  try {
                    /// use this public api to update group data
                    await VChatController.instance.updateGroupChatTitle(
                        groupId: widget.groupId, title: txt);
                    groupChatInfo = groupChatInfo.copyWith(title: txt);
                    setState(() {});
                    Navigator.pop(context);
                  } catch (err) {
                    Navigator.pop(context);
                    CustomAlert.showError(
                        context: context, err: err.toString());
                  }
                },
                child: S.of(context).update.text),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: S.of(context).cancel.text),
          ],
        );
      },
    );
  }

  void updateGroupImage() async {
    try {
      final picker = ImagePicker();
      final img = await picker.pickImage(source: ImageSource.gallery);
      if (img != null) {
        CustomAlert.customLoadingDialog(context: context);
        if (File(img.path).lengthSync() > 1024 * 1024 * 20) {
          throw S.of(context).imageSizeMustBeLessThan20Mb;
        }

        /// use this public api to update group image
        final newImage = await VChatController.instance
            .updateGroupChatImage(path: img.path, groupId: widget.groupId);
        groupChatInfo = groupChatInfo.copyWith(imageThumb: newImage);
        setState(() {});

        Navigator.pop(context);
      }
    } catch (err) {
      Navigator.pop(context);
      CustomAlert.showSuccess(context: context, err: err.toString());
    }
  }

  Widget getAdminTrailing(VChatGroupUser user) {
    return Row(
      children: [
        user.vChatUserGroupRole == VChatUserGroupRole.admin
            ? InkWell(
                onTap: () async {
                  try {
                    /// downgrade Group Admin User only if you admin
                    await VChatController.instance.downgradeGroupAdmin(
                      groupId: widget.groupId,
                      userId: user.id,
                    );
                    members.clear();
                    getGroupMembers();
                  } catch (err) {
                    CustomAlert.showError(
                        context: context, err: err.toString());
                    rethrow;
                  }
                },
                child: Icon(
                  Icons.arrow_circle_down_outlined,
                  size: 30,
                ))
            : InkWell(
                onTap: () async {
                  try {
                    /// upgrade upgrade Group User only if you admin
                    await VChatController.instance.upgradeGroupUser(
                        groupId: widget.groupId, userId: user.id);
                    members.clear();
                    getGroupMembers();
                  } catch (err) {
                    CustomAlert.showError(
                        context: context, err: err.toString());
                    rethrow;
                  }
                },
                child: Icon(
                  Icons.arrow_circle_up_outlined,
                  size: 30,
                )),
        SizedBox(
          width: 10,
        ),
        SizedBox(
          width: 10,
        ),
        InkWell(
          onTap: () async {
            try {
              /// will delete user from group only if this user in the group
              /// and current current user is admin
              /// admin can delete admin but cant delete the group creator
              /// group creator can delete any user but cant be deleted
              await VChatController.instance.kickUserFromGroup(
                  groupId: widget.groupId, kickedId: user.id);
              members.clear();
              getGroupMembers();
            } catch (err) {
              CustomAlert.showError(context: context, err: err.toString());
              rethrow;
            }
          },
          child: Icon(
            Icons.block,
            size: 30,
          ),
        ),
      ],
    );
  }

  Future<List<VChatGroupUser>> getGroupMembersLoadMore() async {
    /// load more users group data don't forget to add one to paginationIndex
    return await VChatController.instance.getGroupMembers(
        groupId: widget.groupId, paginationIndex: paginationIndex);
  }

  Future<void> loadMore() async {
    paginationIndex += 1;

    final loadedUsers = await getGroupMembersLoadMore();

    loadingStatus = LoadMoreStatus.loaded;
    if (loadedUsers.isEmpty) {
      loadingStatus = LoadMoreStatus.completed;
    }
    members.addAll(loadedUsers);
    setState(() {});
  }
}
