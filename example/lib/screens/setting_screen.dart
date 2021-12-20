import 'package:get_storage/get_storage.dart';
import 'package:example/controllers/app_controller.dart';
import 'package:example/generated/l10n.dart';

import 'package:example/screens/splash_screen.dart';
import 'package:example/screens/update_user_profile_screen.dart';
import 'package:example/utils/custom_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textless/textless.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:v_chat_sdk/v_chat_sdk.dart';

import 'about.dart';

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
                    data: [S.of(context).ar, S.of(context).en, "pt_BR"]);
                if (res == 0) {
                  await GetStorage().write("lng", "ar");
                  Provider.of<AppController>(context, listen: false)
                      .setLocale(const Locale.fromSubtags(languageCode: "ar"));
                  await VChatController.instance.changeLanguage("ar");
                }
                if (res == 1) {
                  await GetStorage().write("lng", "en");
                  Provider.of<AppController>(context, listen: false)
                      .setLocale(const Locale.fromSubtags(languageCode: "en"));
                  await VChatController.instance.changeLanguage("en");
                }
                if (res == 2) {
                  await GetStorage().write("lng", "pt_BR");
                  Provider.of<AppController>(context, listen: false).setLocale(
                      const Locale.fromSubtags(
                          languageCode: "pt", countryCode: "BR"));
                  await VChatController.instance.changeLanguage("pt_BR");
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
                  Provider.of<AppController>(context, listen: false)
                      .changeTheme(false);
                }
                if (res == 1) {
                  Provider.of<AppController>(context, listen: false)
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
                  VChatController.instance.stopAllNotification(context);
                }
              },
            ),
            ProfileItem(
              title: S.of(context).ourFullDocumentation,
              icon: Icons.document_scanner_outlined,
              onTap: () async {
                if (!await launch(
                    "https://hatemragab.github.io/VChatSdk-Documentation")) {
                  throw 'Could not launch  ';
                }
              },
            ),
            ProfileItem(
              title: S.of(context).buyTheBackendCode,
              icon: Icons.document_scanner_outlined,
              onTap: () async {
                if (!await launch(
                    "https://codecanyon.net/item/flutter-chat-app-with-node-js-and-socket-io-mongo-db/26142700")) {
                  throw 'Could not launch  ';
                }
              },
            ),
            ProfileItem(
              title: S.of(context).iosTestflightAndPublicFlutterUi,
              icon: Icons.document_scanner_outlined,
              onTap: () async {
                if (!await launch("https://github.com/hatemragab/v_chat_sdk")) {
                  throw 'Could not launch  ';
                }
              },
            ),
            ProfileItem(
              title: S.of(context).contactUsAndReportIssuesOrNewFeatures,
              icon: Icons.chat,
              onTap: () async {
                try {
                  final res = await CustomAlert.chatAlert(
                      context: context, peerEmail: "hatemragap5@gmail.com");
                  if (res != null) {
                    await VChatController.instance.createSingleChat(
                        peerEmail: "hatemragap5@gmail.com",
                        message: res,
                        context: context);
                    CustomAlert.showSuccess(
                      context: context,
                      err: S.of(context).success,
                    );
                  }
                } on VChatSdkException catch (err) {
                  CustomAlert.showError(context: context, err: err.toString());
                  rethrow;
                }
              },
            ),
            ProfileItem(
              title: S.of(context).about,
              icon: Icons.info,
              onTap: () async {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const About()));
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
            Flexible(child: title.text)
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
