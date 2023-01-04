import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class EmojiKeyboard extends StatelessWidget {
  final bool isEmojiShowing;
  final TextEditingController controller;

  const EmojiKeyboard({
    super.key,
    required this.isEmojiShowing,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.platformBrightness == Brightness.dark;
    return Offstage(
      offstage: !isEmojiShowing,
      child: SizedBox(
        height: VPlatforms.isWeb ? MediaQuery.of(context).size.height / 3 : 250,
        child: EmojiPicker(
          textEditingController: controller,
          config: Config(
            // Issue: https://github.com/flutter/flutter/issues/28894
            emojiSizeMax: 32 * (VPlatforms.isIOS ? 1.30 : 1.0),
            bgColor: isDark ? Colors.black54 : const Color(0xFFF2F2F2),
          ),
        ),
      ),
    );
  }
}
