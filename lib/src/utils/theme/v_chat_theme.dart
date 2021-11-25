
import 'common/v_chat_dialog_theme.dart';
import 'theme.dart';

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
