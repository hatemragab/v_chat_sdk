import 'package:example/generated/l10n.dart';
import 'package:example/utils/custom_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textless/textless.dart';
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
            const SizedBox(
              height: 20,
            ),
            CupertinoTextField(
              placeholder: S.of(context).name,
              controller: _controller.nameTxtController,
            ),
            const SizedBox(
              height: 20,
            ),
            CupertinoTextField(
              placeholder: S.of(context).password,
              controller: _controller.passwordTxtController,
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
                onTap: () async {
                  final picker = ImagePicker();
                  final img =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (img != null) {
                    _controller.imagePath = img.path;
                    CustomAlert.showSuccess(
                        context: context,
                        err: "image has been set successfully");
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.image,
                      size: 40,
                    ),
                    S.of(context).chooseImage.text,
                  ],
                )),
            const SizedBox(
              height: 10,
            ),
            TextButton(
                onPressed: _controller.register,
                child: S.of(context).register.text),
          ],
        ),
      ),
    );
  }
}
