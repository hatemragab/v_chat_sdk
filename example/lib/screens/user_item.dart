import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:textless/textless.dart';
import '../controllers/home_controller.dart';
import '../models/user.dart';
import 'user_profile_screen.dart';
import 'package:provider/provider.dart';

class UserItem extends StatelessWidget {
  final User user;

  const UserItem({
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfile(user),
          ),
        );
      },
      title: user.name.text,
      trailing: InkWell(
        onTap: () =>
            context.read<HomeController>().startChat(user.email, context),
        child: const Icon(Icons.message),
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: CachedNetworkImage(
          imageUrl: baseImgUrl + user.imageThumb,
          height: 100,
          width: 60,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
