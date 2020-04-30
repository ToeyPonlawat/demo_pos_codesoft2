import 'package:alphadealdemo/src/pages/draft_page.dart';
import 'package:alphadealdemo/src/pages/home_page.dart';
import 'package:alphadealdemo/src/pages/logo_page.dart';
import 'package:alphadealdemo/src/pages/sample_silver.dart';
import 'package:alphadealdemo/src/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:alphadealdemo/src/locale/app_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  AppLocalizationDelegate _localeOverrideDelegate = AppLocalizationDelegate(Locale('th'));

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      localeResolutionCallback: (Locale locale, Iterable<Locale> supportedLocales) {
        return locale;
      },
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        _localeOverrideDelegate,
      ],
      supportedLocales: [
        const Locale('th'),
        const Locale('en'),
      ],
      theme: ThemeData(fontFamily: 'Prompt'),
      home: FutureBuilder(
        future: Future.delayed(const Duration(seconds: 2), () async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          return preferences.getBool("isEN") ?? false;}
          ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == true) {
              return HomePage();
            }
            AppLocalization.load(Locale('th'));
            return HomePage();
          }
          return LogoPage();
        },
      ),
    );
  }

  Future<bool> checkIsLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool("isEN") ?? false;
  }
}
