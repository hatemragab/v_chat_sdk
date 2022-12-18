import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class EmojiKeyboard extends StatelessWidget {
  final Function(Emoji emoji) onEmojiSelected;
  final VoidCallback onBackspacePressed;
  final bool isEmojiShowing;

  const EmojiKeyboard({
    super.key,
    required this.onEmojiSelected,
    required this.onBackspacePressed,
    required this.isEmojiShowing,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.platformBrightness == Brightness.dark;
    return Offstage(
      offstage: !isEmojiShowing,
      child: SizedBox(
        height: Platforms.isWeb ? MediaQuery.of(context).size.height / 3 : 250,
        child: EmojiPicker(
          onEmojiSelected: (category, emoji) {
            onEmojiSelected(emoji);
          },
          onBackspacePressed: onBackspacePressed,
          config: Config(
            // Issue: https://github.com/flutter/flutter/issues/28894
            emojiSizeMax: 32 * (Platforms.isIOS ? 1.30 : 1.0),
            bgColor: isDark ? Colors.black54 : const Color(0xFFF2F2F2),
          ),
        ),
      ),
    );
  }
}
