import 'package:example/generated/l10n.dart';
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
        title: S.of(context).login.text,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CupertinoTextField(
              placeholder: S.of(context).email,
              controller: _controller.emailTxtController,
            ),
            SizedBox(
              height: 10,
            ),
            CupertinoTextField(
              placeholder: S.of(context).name,
              controller: _controller.nameTxtController,
            ),
            SizedBox(
              height: 10,
            ),
            CupertinoTextField(
              placeholder: S.of(context).password,
              controller: _controller.passwordTxtController,
            ),
            const SizedBox(
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
                child: S.of(context).chooseImage.text),
            SizedBox(
              height: 10,
            ),
            TextButton(onPressed: _controller.register, child: S.of(context).register.text),
          ],
        ),
      ),
    );
  }
}
