import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:v_chat_sdk_core/src/i10n/lang/en.dart';

import 'default_localizations.dart';

const kDefaultLocale = Locale('ar');

class VChatLocalizations<T extends VChatLocalizationLabels> {
  final Locale locale;
  final T labels;

  const VChatLocalizations(this.locale, this.labels);

  static VChatLocalizations of(BuildContext context) {
    final l = Localizations.of<VChatLocalizations>(
      context,
      VChatLocalizations,
    );

    if (l != null) {
      return l;
    }

    final defaultLocalizations = localizations[kDefaultLocale.languageCode]!;
    return VChatLocalizations(kDefaultLocale, defaultLocalizations);
  }

  static VChatLocalizationLabels labelsOf(BuildContext context) {
    return VChatLocalizations.of(context).labels;
  }

  static VChatLocalizationDelegate delegate = const VChatLocalizationDelegate();

  static VChatLocalizationDelegate
      withDefaultOverrides<T extends EnLocalizations>(T overrides) {
    return VChatLocalizationDelegate<T>(overrides);
  }
}

class VChatLocalizationDelegate<T extends VChatLocalizationLabels>
    extends LocalizationsDelegate<VChatLocalizations> {
  final T? overrides;
  final bool _forceSupportAllLocales;

  const VChatLocalizationDelegate([
    this.overrides,
    this._forceSupportAllLocales = false,
  ]);

  @override
  bool isSupported(Locale locale) {
    return _forceSupportAllLocales ||
        localizations.keys.contains(locale.languageCode);
  }

  @override
  Future<VChatLocalizations> load(Locale locale) {
    final l = VChatLocalizations(
      locale,
      overrides ?? localizations[locale.languageCode]!,
    );

    return SynchronousFuture<VChatLocalizations>(l);
  }

  @override
  bool shouldReload(
    covariant LocalizationsDelegate<VChatLocalizations> old,
  ) {
    return false;
  }
}
