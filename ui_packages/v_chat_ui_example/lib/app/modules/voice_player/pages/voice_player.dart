import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:v_chat_ui/v_chat_ui.dart';

class VoicePlayer extends StatefulWidget {
  final String url;
  final Duration duration;

  const VoicePlayer({required this.url, required this.duration, Key? key})
      : super(key: key);

  @override
  _VoicePlayerState createState() => _VoicePlayerState();
}

class _VoicePlayerState extends State<VoicePlayer> {
  bool isLoading = true;
  late String path;
  late final VoiceMessageController messageController;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();

    return WillPopScope(
      onWillPop: () async {
        messageController.dispose();
        return true;
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  if (isLoading)
                    const CircularProgressIndicator.adaptive()
                  else
                    VoiceMessageView(
                      controller: messageController,
                    ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future download() async {
    try {
      final file = await DefaultCacheManager().getSingleFile(
        widget.url,
      );
      path = file.path;
    } catch (err) {
      //
      rethrow;
    }
  }

  void init() async {
    await download();
    messageController = VoiceMessageController(
      audioSrc: FileSrc(path),
      maxDuration: widget.duration,
      id: "1",
      onPlaying: (id) {},
      onComplete: (id) {
        print("On onComplete called ! $id");
      },
      onPause: (id) {},
    );
    setState(() {
      isLoading = false;
    });
  }
}
