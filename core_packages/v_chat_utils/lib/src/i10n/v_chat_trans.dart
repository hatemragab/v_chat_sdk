// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../v_chat_utils.dart';

const kDefaultLocale = Locale('en');

class VTrans<T extends VChatLocalizationLabels> {
  final Locale locale;
  final T labels;

  const VTrans(this.locale, this.labels);

  static VTrans of(BuildContext context) {
    final l = Localizations.of<VTrans>(
      context,
      VTrans,
    );

    if (l != null) {
      return l;
    }

    final defaultLocalizations = localizations[kDefaultLocale.languageCode]!;
    return VTrans(kDefaultLocale, defaultLocalizations);
  }

  static VChatLocalizationLabels labelsOf(BuildContext context) {
    return VTrans.of(context).labels;
  }

  static VChatLocalizationDelegate delegate = const VChatLocalizationDelegate();

  static VChatLocalizationDelegate
      withDefaultOverrides<T extends VChatLocalizationLabels>(
    T overrides,
    Locale locale,
  ) {
    return VChatLocalizationDelegate<T>(overrides, locale);
  }

  static VChatLocalizationDelegate
      addNewLocal<T extends VChatLocalizationLabels>(
    T overrides,
    Locale locale,
  ) {
    return VChatLocalizationDelegate<T>(overrides, locale);
  }
}

class VChatLocalizationDelegate<T extends VChatLocalizationLabels>
    extends LocalizationsDelegate<VTrans> {
  final T? overrides;
  final Locale? locale;
  final bool _forceSupportAllLocales;

  const VChatLocalizationDelegate([
    this.overrides,
    this.locale,
    this._forceSupportAllLocales = false,
  ]);

  @override
  bool isSupported(Locale locale) {
    if (this.locale != null) {
      return this.locale!.languageCode == locale.languageCode;
    }
    return _forceSupportAllLocales ||
        localizations.keys.contains(
          locale.languageCode,
        );
  }

  @override
  Future<VTrans> load(Locale locale) {
    final l = VTrans(
      locale,
      overrides ?? localizations[locale.languageCode]!,
    );
    return SynchronousFuture<VTrans>(l);
  }

  @override
  bool shouldReload(
    covariant LocalizationsDelegate<VTrans> old,
  ) =>
      false;
}
