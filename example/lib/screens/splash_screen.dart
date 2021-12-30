import 'package:example/controllers/app_controller.dart';
import 'package:example/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import 'home.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startNavigate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).splashScreen),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/icon.png",
              height: 150,
              width: 150,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 10,
            ),
            CupertinoActivityIndicator(),
          ],
        ),
      ),
    );
  }

  void startNavigate() async {
    final myModel = GetStorage().hasData("myModel");

    await Future.delayed(const Duration(seconds: 1));
    final lng = GetStorage().hasData("lng");
    if (lng) {
      final str = GetStorage().read("lng") as String;
      final country = str.split("_");

      Provider.of<AppController>(context, listen: false)
          .setLocale(Locale(country.first, country.last));
    }

    if (myModel) {
      /// there are login data saved
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Home()),
          (Route<dynamic> route) => false);
    } else {
      /// its the first time to open the app
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false);
    }
  }
}
