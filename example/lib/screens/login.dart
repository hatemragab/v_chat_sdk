import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:textless/textless.dart';
import '../controllers/login_controller.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LoginController(context);
 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "login".text,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CupertinoTextField(
              placeholder: "Email",
              controller: _controller.emailTxtController,
            ),
            SizedBox(
              height: 10,
            ),
            CupertinoTextField(
              placeholder: "Password",
              controller: _controller.passwordTxtController,
            ),
            SizedBox(
              height: 10,
            ),
            TextButton(onPressed: _controller.login, child: "Login".text),
            SizedBox(
              height: 10,
            ),
            TextButton(onPressed: _controller.register, child: "Register".text),
          ],
        ),
      ),
    );
  }
}
