import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../vchat_package/app/utils/get_storage_keys.dart';
import 'home.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startNavigate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("splash screen"),),
      body: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }

  void startNavigate() async {
    final myModel = GetStorage().hasData("myModel");
    final vChatUser = GetStorage().hasData(GetStorageKeys.KV_CHAT_MY_MODEL);

    await Future.delayed(Duration(seconds: 3));
    if (myModel && vChatUser) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Home(),
      ));
    } else {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ));
    }
  }
}
