import 'package:example/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:textless/textless.dart';
import 'package:v_chat_sdk/v_chat_sdk.dart';

class AppRoomsScreen extends StatefulWidget {
  const AppRoomsScreen({Key? key}) : super(key: key);

  @override
  _AppRoomsScreenState createState() => _AppRoomsScreenState();
}

class _AppRoomsScreenState extends State<AppRoomsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: S.of(context).myGreatRooms.text,
      ),
      body: VChatRoomsView(),
    );
  }
}
