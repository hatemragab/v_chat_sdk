import 'package:example/generated/l10n.dart';
import 'package:textless/textless.dart';
import 'package:flutter/material.dart';

class UpdateUserProfileScreen extends StatefulWidget {
  const UpdateUserProfileScreen({Key? key}) : super(key: key);

  @override
  _UpdateUserProfileScreenState createState() =>
      _UpdateUserProfileScreenState();
}

class _UpdateUserProfileScreenState extends State<UpdateUserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: S.of(context).update.text,
      ),
    );
  }
}
