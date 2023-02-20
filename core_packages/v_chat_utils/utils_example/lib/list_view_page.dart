// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:recase/recase.dart';
import 'package:translator/translator.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class ListViewPage extends StatefulWidget {
  const ListViewPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return ListViewPageState();
  }
}

class ListViewPageState extends State<ListViewPage> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    //  _parse();
    // _transTo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [Icon(Icons.ac_unit)],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.multiline,
              minLines: 20,
              maxLines: 40,
            ),
            VImagePicker(
              onDone: (file) {},
              size: 100,
              initImage:
                  VPlatformFileSource.fromAssets(assetsPath: "assets/logo.png"),
            ),
            TextButton(
              onPressed: () async {
                VAppAlert.showLoading(context: context);
                await Future.delayed(const Duration(seconds: 5));
                Navigator.pop(context);
              },
              child: const Text("show loading alert"),
            ),
            TextButton(
              onPressed: () async {
                if (VLanguageListener.I.appLocal.toString() == "ar") {
                  await VLanguageListener.I.setLocal(const Locale("en"));
                } else {
                  await VLanguageListener.I.setLocal(const Locale("ar"));
                }
              },
              child: const Text("Trans"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () async {
                if (VThemeListener.I.appTheme == ThemeMode.light) {
                  await VThemeListener.I.setTheme(ThemeMode.dark);
                } else {
                  await VThemeListener.I.setTheme(ThemeMode.light);
                }
              },
              child: const Text("Theme"),
            ),
            const SizedBox(
              height: 20,
            ),
            // TextButton(
            //   onPressed: () async {
            //     await VAwesomeNotifications.I.init();
            //     await VAwesomeNotifications.I
            //         .showNotification(title: "title", body: "body", id: 1);
            //   },
            //   child: const Text("Push notify"),
            // ),
          ],
        ),
      ),
    );
  }

  List<String> _parse() {
    final listOfParsed = <String>[];
    StringBuffer buffer = StringBuffer();
    for (var element in _data) {
      element = element.replaceAll(RegExp(r'[^\w\s]+'), '');
      buffer.writeln("String get ${element.camelCase};");
      listOfParsed.add(element.camelCase);
    }
    controller.text = buffer.toString();
    return listOfParsed;
  }

  final translator = GoogleTranslator();

  void _transTo() async {
    final parsed = _parse();
    String language = "en";
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < _data.length; i++) {
      var translation = await translator.translate(_data[i], to: language);
      buffer.writeln('''
        @override
        String get ${parsed[i]} => "$translation";                 
      ''');
    }
    controller.text = buffer.toString();
  }
}

final _data = [
  "Ok",
  "Cancel",
  "Yes",
  "Error while download file",
  "Unsupported Platform",
  "Successfully downloaded in",
  "Please wait ...",
  "Search ...",
  "Update title to",
  "Update image",
  "Joined By",
  "Promoted to admin by",
  "Dismissed to member by",
  "Left the group",
  "kicked by",
  "Group created by",
  "Added you to new broadcast",
  "Connecting...",
  "Delete",
  "Download",
  "Copy",
  "Info",
  "Share",
  "Forward",
  "Reply",
  "Delete from all",
  "Delete from me",
  "Downloading ...",
  "File has been saved to",

  "Online",
  "You don't have access",
  "Reply to your self",
  "Forwarded",
  "Replied to your self",
  "Message has been deleted",
  "Choose Rooms",
  "Mute",
  "Un mute",
  "Report",
  "Un block",
  "Block",
  "Leave",
  "Chat muted",
  "Chat un muted",
  "Delete you copy?",
  "Are you sure to permit your copy this action cant undo",
  "Block this user?",
  "Are you sure to block this user cant send message to you",
  "User blocked",
  "User un blocked",
  "Are you sure to leave?",
  "Leave group and delete your message copy?",
  "Group left",
  "Typing...",
  "Recording...",
  "Share files",
  "Media",
  "Share location",
  "Share Media And Location",
  "Type your message...",

  ///new
  "End-to-end encryption",
  "Exit from the call",
  "Are you sure to end the call ?",
  "Message info",
  "Read",
  "Delivered",
  "Chat media",
  "Busy",
  "Members",
  "Ring",
  "Room Already In Call",
  "Timeout",
  "Call end",
  "Rejected",
  "Video call",
  "Audio call",
  "Canceled",
  "In call",
  "Make call",
  "Are you want to make video call",
  "Are you want to make voice call",
];
