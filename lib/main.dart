import 'package:alphadealdemo/src/myapp.dart';
import 'package:alphadealdemo/src/services/app_language.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp],
  );
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  runApp(
    MyApp(
      appLanguage: appLanguage,
    ),
  );
}
