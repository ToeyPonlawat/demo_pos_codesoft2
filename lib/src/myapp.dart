import 'package:alphadealdemo/src/locale/app_localization.dart';
import 'package:alphadealdemo/src/locale/fallback_localization.dart';
import 'package:alphadealdemo/src/pages/about_page.dart';
import 'package:alphadealdemo/src/pages/cart_page.dart';
import 'package:alphadealdemo/src/pages/donut_page.dart';
import 'package:alphadealdemo/src/pages/contact_page.dart';
import 'package:alphadealdemo/src/pages/home_page.dart';
import 'package:alphadealdemo/src/pages/profile_page.dart';
import 'package:alphadealdemo/src/services/app_language.dart';
import 'package:alphadealdemo/src/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

var selectedPage;

class MyApp extends StatelessWidget {
  final AppLanguage appLanguage;

  MyApp({this.appLanguage});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppLanguage>(
      create: (_) => appLanguage,
      child: Consumer<AppLanguage>(builder: (context, model, child) {
        return MaterialApp(
          locale: model.appLocal,
          supportedLocales: [
            Locale('en', 'US'),
            Locale('th', ''),
          ],
          routes: {
            '/': (context) => HomeApp(0,0),
            '/profile': (context) => HomeApp(4,0),
          },
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            const FallbackCupertinoLocalisationsDelegate()
          ],
          theme: ThemeData(fontFamily: 'Prompt'),
        );
      }),
    );
  }
}


