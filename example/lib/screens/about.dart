import 'package:example/generated/l10n.dart';
import 'package:example/utils/custom_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:textless/textless.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: S.of(context).about.text,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            "V Chat Sdk".h5.alignCenter,
            SizedBox(
              height: 10,
            ),
            S.of(context).codePrivateAndGroupChatWithVChatItsVery.text,
            SizedBox(
              height: 6,
            ),
            "Directed to flutter developers who want to implement chat system in their apps without write chat code"
                .text,
            SizedBox(
              height: 6,
            ),
            "VChat Works with all backend service available because it not depend on your backend system it run isolated and connected to your backend with our public apis"
                .text,
            SizedBox(
              height: 6,
            ),
            S.of(context).areYouHaveQuestion.text.black,
            SizedBox(
              height: 6,
            ),
            Row(
              children: [
                S.of(context).contactMeOnWhatsapp.text,
                InkWell(
                    onTap: () async {
                      await Clipboard.setData(
                          ClipboardData(text: "+201012309598"));
                      CustomAlert.showSuccess(
                          context: context, err: "copiedToYourClipboard data");
                    },
                    child: "+201012309598".text.color(Colors.blue))
              ],
            ),
            SizedBox(
              height: 6,
            ),
            Row(
              children: [
                "Contact me on Skype ".text,
                InkWell(
                    onTap: () async {
                      await Clipboard.setData(
                          ClipboardData(text: "live:.cid.607250433850e3a6"));
                      CustomAlert.showSuccess(
                          context: context,
                          err: "copied to your ClipboardData");
                    },
                    child: "live:.cid.607250433850e3a6".text.color(Colors.blue))
              ],
            )
          ],
        ),
      ),
    );
  }
}
