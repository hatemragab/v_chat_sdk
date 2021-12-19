import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/generated/l10n.dart';
import 'package:example/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textless/textless.dart';
import 'choose_group_members_controller.dart';

/// please Note this is example you can have your own design
class ChooseGroupMembersPage extends StatelessWidget {
  final bool isFromGroupInfo;

  ChooseGroupMembersPage({Key? key, this.isFromGroupInfo = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ChooseGroupMembersController(
          context: context, isFromGroupInfo: isFromGroupInfo),
      builder: (context, child) => ChooseGroupMembersScreen(),
    );
  }
}

class ChooseGroupMembersScreen extends StatelessWidget {
  const ChooseGroupMembersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ChooseGroupMembersController>(context);
    final usersList = controller.users;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: controller.next,
        child: Icon(Icons.arrow_forward),
      ),
      appBar: AppBar(
        title: S.of(context).chooseMembers.text,
        centerTitle: true,
        elevation: 0,
      ),
      body: Scrollbar(
        child: ListView.separated(
          controller: controller.scrollController,
          padding: const EdgeInsets.all(10),
          itemBuilder: (context, index) => ListTile(
            title: usersList[index].name.text,
            onTap: () => controller.setSelectedUser(usersList[index]),
            leading: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: CachedNetworkImage(
                  imageUrl: baseImgUrl + usersList[index].imageThumb,
                  height: 100,
                  width: 60,
                  fit: BoxFit.cover,
                )),
            selected: usersList[index].isSelected,
          ),
          separatorBuilder: (context, index) => const Divider(),
          itemCount: usersList.length,
        ),
      ),
    );
  }
}
