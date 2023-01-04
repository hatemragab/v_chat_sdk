import '../default_localizations.dart';

class ArLocalizations extends VChatLocalizationLabels {
  @override
  final String emailInputLabel;

  @override
  final String passwordInputLabel;

  @override
  final String registerActionText;

  @override
  final String signInActionText;

  const ArLocalizations({
    this.emailInputLabel = 'البريد الالكتروني',
    this.passwordInputLabel = 'كلمه المرور',
    this.signInActionText = 'تسجيل دخول',
    this.registerActionText = 'تسجيل حساب جديد',
  });
}
