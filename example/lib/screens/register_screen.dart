import 'dart:io';

import 'package:example/generated/l10n.dart';
import 'package:example/utils/custom_alert.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textless/textless.dart';
import '../app_terms.dart';
import '../controllers/register_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late RegisterController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RegisterController(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: S.of(context).register.text,
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
                height: 20,
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: S.of(context).name,
                ),
                controller: _controller.nameTxtController,
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: S.of(context).password,
                ),
                controller: _controller.passwordTxtController,
              ),
              const SizedBox(
                height: 20,
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
              InkWell(
                  onTap: () async {
                    final picker = ImagePicker();
                    final img =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (img != null) {
                      _controller.imagePath = img.path;
                      CustomAlert.done(msg: S.of(context).imageHasBeenSelected);
                      setState(() {});
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _controller.imagePath != null
                          ? Image.file(
                              File(_controller.imagePath!),
                              height: 100,
                              width: 100,
                            )
                          : const Icon(
                              Icons.image,
                              size: 40,
                            ),
                      S.of(context).chooseImage.text,
                    ],
                  )),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: _controller.register,
                  child: S.of(context).register.text),
            ],
          ),
        ),
      ),
    );
  }
}
