import 'dart:developer';

import 'package:example/controllers/lang_controller.dart';
import 'package:example/main.dart';
import 'package:example/screens/splash_screen.dart';
import 'package:example/screens/update_user_profile_screen.dart';
import 'package:example/utils/custom_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textless/textless.dart';
import 'package:v_chat_sdk/v_chat_sdk.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ProfileItem(
              title: "Change language",
              icon: Icons.language,
              onTap: () async {
                final res = await CustomAlert.customChooseDialog(
                    context: context, data: ["ar", "en"]);
                if (res == 0) {
                  Provider.of<LangController>(context, listen: false)
                      .setLocale(const Locale.fromSubtags(languageCode: "ar"));
                }
                if (res == 1) {
                  Provider.of<LangController>(context, listen: false)
                      .setLocale(const Locale.fromSubtags(languageCode: "en"));
                }
              },
            ),
            ProfileItem(
              title: "Change Theme",
              icon: Icons.wb_sunny,
              onTap: () async {
                final res = await CustomAlert.customChooseDialog(
                    context: context, data: ["light", "dark"]);
                if (res == 0) {
                  Provider.of<LangController>(context, listen: false)
                      .changeTheme(false);
                }
                if (res == 1) {
                  Provider.of<LangController>(context, listen: false)
                      .changeTheme(true);
                }
              },
            ),
            ProfileItem(
              title: "Update profile",
              icon: Icons.edit,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => UpdateUserProfileScreen()));
              },
            ),
            ProfileItem(
              title: "All Chat notifications",
              icon: Icons.notification_important,
              onTap: () async {
                final res = await CustomAlert.customChooseDialog(
                    context: context, data: ["On", "Off"]);
                if (res == 0) {
                  VChatController.instance.startAllNotification();
                }
                if (res == 1) {
                  VChatController.instance.stopAllNotification();
                }
              },
            ),
            ProfileItem(
              title: "Log out",
              icon: Icons.logout,
              onTap: () async {
                await VChatController.instance.logOut();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => SplashScreen()),
                    (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 18),
        child: Row(
          children: [
            Icon(
              icon,
              size: 30,
            ),
            SizedBox(
              width: 10,
            ),
            title.text
          ],
        ),
      ),
    );
  }

  const ProfileItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
