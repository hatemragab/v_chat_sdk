import 'package:flutter/material.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class MediaEditorTest extends StatefulWidget {
  const MediaEditorTest({Key? key}) : super(key: key);

  @override
  State<MediaEditorTest> createState() => _MediaEditorTestState();
}

class _MediaEditorTestState extends State<MediaEditorTest> {
  @override
  Widget build(BuildContext context) {
    final l = VChatLocalizations.labelsOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l.emailInputLabel,
        ),
      ),
    );
  }
}
