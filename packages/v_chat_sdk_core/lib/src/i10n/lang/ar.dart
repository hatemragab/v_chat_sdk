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
    this.emailInputLabel = 'الايميل',
    this.passwordInputLabel = 'باسورد',
    this.signInActionText = 'لوجن',
    this.registerActionText = 'ريجيستر',
  });
}
