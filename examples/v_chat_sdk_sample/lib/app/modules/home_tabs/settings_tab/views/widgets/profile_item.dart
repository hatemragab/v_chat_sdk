import 'package:flutter/material.dart';

class ProfileItem extends StatelessWidget {
  final IconData iconData;
  final String title;
  final VoidCallback onPress;

  const ProfileItem({
    Key? key,
    required this.iconData,
    required this.title,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onPress,
        leading: Icon(iconData, size: 33),
        title: Text(title),
      ),
    );
  }
}
