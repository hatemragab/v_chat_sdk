import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../main.dart';
import 'home.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
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
        title: Text("splash screen"),
      ),
      body: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }

  void startNavigate() async {
    final myModel = GetStorage().hasData("myModel");
    //final vChatUser = GetStorage().hasData(GetStorageKeys.KV_CHAT_MY_MODEL);
    await Future.delayed(const Duration(seconds: 2));
    if (myModel) {

      // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>Home() ,));


      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Home()),
          (Route<dynamic> route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false);
    }
  }
}
