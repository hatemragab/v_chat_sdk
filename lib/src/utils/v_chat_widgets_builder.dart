import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:textless/textless.dart';
import 'custom_widgets/audio_wave.dart';
import 'custom_widgets/auto_direction.dart';
import 'custom_widgets/read_more_text.dart';
import 'custom_widgets/rounded_container.dart';

class VChatWidgetBuilder {
  const VChatWidgetBuilder();

  Color messageInputBackgroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Colors.black : Colors.grey[300]!;
  }

  Color sendButtonColor(BuildContext context, bool isDark) {
    return isDark ? Colors.red : Colors.blue;
  }

  Widget senderTextMessageWidget(BuildContext context, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff876969) : Colors.tealAccent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(17),
          bottomLeft: Radius.circular(17),
          topRight: Radius.circular(17),
        ),
        border: Border.all(color: Colors.black12),
      ),
      child: AutoDirection(
        text: text,
        child: ReadMoreText(
          text.toString(),
          trimLines: 5,
          trimMode: TrimMode.line,
          trimCollapsedText: "show More",
          trimExpandedText: "show Less",
          moreStyle: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(fontWeight: FontWeight.bold),
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }

  Widget receiverTextMessageWidget(BuildContext context, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      decoration: BoxDecoration(
        color: isDark ? Colors.black26 : Colors.blueGrey[100],
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(17),
          bottomRight: Radius.circular(17),
          topLeft: Radius.circular(17),
        ),
        border: Border.all(color: Colors.black12),
      ),
      child: AutoDirection(
        text: text,
        child: ReadMoreText(
          text.toString(),
          trimLines: 5,
          trimMode: TrimMode.line,
          trimCollapsedText: "show More",
          trimExpandedText: "show Less",
          moreStyle: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(fontWeight: FontWeight.bold),
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }

  Widget senderVoiceMessageWidget(BuildContext context, String duration) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isDark ? const Color(0xff876969) : Colors.tealAccent),
      height: 40,
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          Icon(
            Icons.play_circle,
            color: isDark ? Colors.white54 : Colors.blue,
            size: 30,
          ),
          const SizedBox(
            width: 10,
          ),
          duration.cap,
          const SizedBox(
            width: 10,
          ),
          AudioWave(
            height: 32,
            animation: false,
            width: MediaQuery.of(context).size.width / 2,
            spacing: 3,
            bars: [
              AudioWaveBar(height: 10, color: Colors.lightBlueAccent),
              AudioWaveBar(height: 30, color: Colors.blue),
              AudioWaveBar(height: 70, color: Colors.black),
              AudioWaveBar(height: 40),
              AudioWaveBar(height: 20, color: Colors.orange),
              AudioWaveBar(height: 10, color: Colors.lightBlueAccent),
              AudioWaveBar(height: 30, color: Colors.blue),
              AudioWaveBar(height: 70, color: Colors.black),
              AudioWaveBar(height: 40),
              AudioWaveBar(height: 20, color: Colors.orange),
              AudioWaveBar(height: 10, color: Colors.lightBlueAccent),
              AudioWaveBar(height: 30, color: Colors.blue),
              AudioWaveBar(height: 70, color: Colors.black),
              AudioWaveBar(height: 40),
              AudioWaveBar(height: 20, color: Colors.orange),
              AudioWaveBar(height: 10, color: Colors.lightBlueAccent),
              AudioWaveBar(height: 30, color: Colors.blue),
              AudioWaveBar(height: 70, color: Colors.black),
              AudioWaveBar(height: 40),
              AudioWaveBar(height: 20, color: Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget receiverVoiceMessageWidget(BuildContext context, String duration) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark ? Colors.black26 : Colors.blueGrey[100],
      ),
      height: 40,
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          Icon(
            Icons.play_circle,
            color: Colors.red,
            size: 30,
          ),
          const SizedBox(
            width: 10,
          ),
          duration.cap,
          const SizedBox(
            width: 10,
          ),
          AudioWave(
            height: 32,
            animation: false,
            width: MediaQuery.of(context).size.width / 2,
            spacing: 3,
            bars: [
              AudioWaveBar(height: 10, color: Colors.lightBlueAccent),
              AudioWaveBar(height: 30, color: Colors.blue),
              AudioWaveBar(height: 70, color: Colors.black),
              AudioWaveBar(height: 40),
              AudioWaveBar(height: 20, color: Colors.orange),
              AudioWaveBar(height: 10, color: Colors.lightBlueAccent),
              AudioWaveBar(height: 30, color: Colors.blue),
              AudioWaveBar(height: 70, color: Colors.black),
              AudioWaveBar(height: 40),
              AudioWaveBar(height: 20, color: Colors.orange),
              AudioWaveBar(height: 10, color: Colors.lightBlueAccent),
              AudioWaveBar(height: 30, color: Colors.blue),
              AudioWaveBar(height: 70, color: Colors.black),
              AudioWaveBar(height: 40),
              AudioWaveBar(height: 20, color: Colors.orange),
              AudioWaveBar(height: 10, color: Colors.lightBlueAccent),
              AudioWaveBar(height: 30, color: Colors.blue),
              AudioWaveBar(height: 70, color: Colors.black),
              AudioWaveBar(height: 40),
              AudioWaveBar(height: 20, color: Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget senderFileMessageWidget(
      BuildContext context, String fileName, String fileSize) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return RoundedContainer(
      height: 75,
      color: isDark ? const Color(0xff876969) : Colors.tealAccent,
      borderRadius: BorderRadius.circular(20),
      child: Row(
        children: [
          const SizedBox(
            width: 25,
          ),
          Icon(
            Icons.insert_drive_file_outlined,
            size: 40,
            color: isDark ? Colors.white54 : Colors.blue,
          ),
          const SizedBox(
            width: 5,
          ),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [fileName.b2.size(13.4).overflowEllipsis, fileSize.cap],
            ),
          )
        ],
      ),
    );
  }

  Widget receiverFileMessageWidget(
      BuildContext context, String fileName, String fileSize) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return RoundedContainer(
      height: 75,
      color: isDark ? Colors.black26 : Colors.blueGrey[100],
      borderRadius: BorderRadius.circular(20),
      child: Row(
        children: [
          const SizedBox(
            width: 25,
          ),
          Icon(
            Icons.insert_drive_file_outlined,
            size: 40,
            color: isDark ? Colors.white54 : Colors.red,
          ),
          const SizedBox(
            width: 5,
          ),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                fileName.b2.size(13.4).maxLine(1).overflowEllipsis,
                fileSize.cap
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget infoLightMessage(String message, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      child: message.text.color(isDark ? Colors.white : Colors.red),
      decoration: BoxDecoration(
          color: isDark ? Colors.black : Colors.grey[300],
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(5),
    );
  }

  Widget infoDarkMessage(String message, BuildContext context) {
    //final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      child: message.text.color(Colors.white),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(5),
    );
  }
}
