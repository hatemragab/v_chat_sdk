import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textless/textless.dart';
import '../../../../models/vchat_user.dart';
import '../../../../utils/custom_widgets/circle_image.dart';



class UserItem extends StatelessWidget {
  final VChatUser _user;

  UserItem(this._user);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Obx(() => CircleImage.network(
          path: _user.imageThumb,
          height: 60,
          width: 60,
          isSelected: _user.isSelected.value)),
      title: _user.name.text,
    );
  }
}
