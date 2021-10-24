import 'package:get_storage/get_storage.dart';
import 'package:example/controllers/lang_controller.dart';
import 'package:example/generated/l10n.dart';

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
              title: S.of(context).changeLanguage,
              icon: Icons.language,
              onTap: () async {
                final res = await CustomAlert.customChooseDialog(
                    context: context,
                    data: [S.of(context).ar, S.of(context).en]);
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
              title: S.of(context).changeTheme,
              icon: Icons.wb_sunny,
              onTap: () async {
                final res = await CustomAlert.customChooseDialog(
                    context: context,
                    data: [S.of(context).light, S.of(context).dark]);
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
              title: S.of(context).updateProfile,
              icon: Icons.edit,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const UpdateUserProfileScreen()));
              },
            ),
            ProfileItem(
              title: S.of(context).allChatNotifications,
              icon: Icons.notification_important,
              onTap: () async {
                final res = await CustomAlert.customChooseDialog(
                    context: context,
                    data: [S.of(context).on, S.of(context).off]);
                if (res == 0) {
                  VChatController.instance.enableAllNotification();
                }
                if (res == 1) {
                  VChatController.instance.stopAllNotification();
                }
              },
            ),
            ProfileItem(
              title: S.of(context).logOut,
              icon: Icons.logout,
              onTap: () async {
                await VChatController.instance.logOut();

                await GetStorage().remove("myModel");

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const SplashScreen()),
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
            const SizedBox(
              width: 10,
            ),
            title.text
          ],
        ),
      ),
    );
  }

  const ProfileItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);
}
