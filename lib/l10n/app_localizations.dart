import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'localization_strings.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static List get _supportedLocalesList => ['en', 'es'];
  static get supportedLocales => _supportedLocalesList.map((e) => Locale(e));

  static final Map<String, Map<String, String>> _localizedStrings = {
    'en': en,
    'es': es,
  };

  String translate(String key, {String param = ''}) {
    return _localizedStrings[locale.languageCode]![key]?.replaceAll('[PARAM]', param) ?? '[$key]';
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations._supportedLocalesList.contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
