import 'package:v_chat_sdk_core/src/i10n/default_localizations.dart';

class EnLocalizations extends VChatLocalizationLabels {
  @override
  final String emailInputLabel;

  @override
  final String passwordInputLabel;

  @override
  final String registerActionText;

  @override
  final String signInActionText;

  const EnLocalizations({
    this.emailInputLabel = 'Email',
    this.passwordInputLabel = 'Password',
    this.signInActionText = 'Sign In',
    this.registerActionText = 'Register',
  });
}
