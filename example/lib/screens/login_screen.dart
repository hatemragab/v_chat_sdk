import 'package:example/app_terms.dart';
import 'package:example/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:textless/textless.dart';
import '../controllers/login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

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
        title: S.of(context).login.text,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
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
              TextField(
                decoration: InputDecoration(
                  hintText: S.of(context).email,
                ),
                controller: _controller.emailTxtController,
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: S.of(context).password,
                ),
                controller: _controller.passwordTxtController,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Checkbox(
                      value: _controller.appTerms,
                      onChanged: (v) {
                        setState(() {
                          _controller.appTerms = v!;
                        });
                      }),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => AppTerms()));
                      },
                      child: "accept V Chat terms".text.color(Colors.blue))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: _controller.login,
                child: S.of(context).login.text,
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: _controller.register,
                child: S.of(context).register.text,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
