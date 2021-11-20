import 'package:v_chat_sdk/src/utils/theme/message_page_theme/message_page_theme.dart';
import 'common/v_chat_dialog_theme.dart';

class VChatTheme {
  VChatDialogTheme? vChatDialogTheme;
  VChatDialogTheme? vChatRoomsPageTheme;
  VChatDialogTheme? vChatMessagePageTheme;
  MessagePageTheme? messagePageTheme;

  VChatTheme.light({
    this.vChatDialogTheme,
    this.vChatRoomsPageTheme,
    this.vChatMessagePageTheme,
    this.messagePageTheme,
  }) {
    vChatDialogTheme ??= VChatDialogTheme.light();
  }

  VChatTheme.dark({
    this.vChatDialogTheme,
    this.vChatRoomsPageTheme,
    this.vChatMessagePageTheme,
    this.messagePageTheme,
  });
}
