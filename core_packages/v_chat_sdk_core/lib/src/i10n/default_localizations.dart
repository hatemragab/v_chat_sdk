import 'lang/ar.dart';
import 'lang/en.dart';

abstract class VChatLocalizationLabels {
  const VChatLocalizationLabels();

  String get emailInputLabel;

  String get passwordInputLabel;

  String get signInActionText;

  String get registerActionText;
}

const localizations = <String, VChatLocalizationLabels>{
  'en': EnLocalizations(),
  'ar': ArLocalizations(),
};

class DefaultLocalizations extends EnLocalizations {
  const DefaultLocalizations();
}
