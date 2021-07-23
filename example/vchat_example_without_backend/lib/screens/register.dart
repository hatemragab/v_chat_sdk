import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textless/textless.dart';
import '../controllers/register_controller.dart';

class RegisterScreen extends StatefulWidget {
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
              placeholder: "Name",
              controller: _controller.nameTxtController,
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
            InkWell(
                onTap: () async {
                  final picker = ImagePicker();
                  final img =
                      await picker.getImage(source: ImageSource.gallery);
                  if (img != null) {
                    _controller.imagePath = img.path;
                  }
                },
                child: "choose image".text),
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
