import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../l10n/messages_all.dart';
import 'dart:developer';

class AppLocalization {

  static Future<AppLocalization> load(Locale locale) {
    final String name = locale.languageCode;
    //log('data: $name');
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return AppLocalization();
    });
  }

  static AppLocalization of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  // list of locales
  String get heyWorld {
    return Intl.message(
      'Hey World',
      name: 'heyWorld',
      desc: 'Simpel word for greeting ',
    );
  }
  String get heyWorld2 {
    return Intl.message(
      'Hey World2',
      name: 'heyWorld2',
      desc: 'Simpel word for greeting ',
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization>{
  final Locale overriddenLocale;

  const AppLocalizationDelegate(this.overriddenLocale);

  @override
  bool isSupported(Locale locale) => ['th', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalization> load(Locale locale) => AppLocalization.load(locale);

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalization> old) => false;
}