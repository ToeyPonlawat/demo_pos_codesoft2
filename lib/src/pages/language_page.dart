import 'package:alphadealdemo/src/locale/app_localization.dart';
import 'package:alphadealdemo/src/services/app_language.dart';
import 'package:alphadealdemo/src/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguagePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var appLanguage = Provider.of<AppLanguage>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('title')),
        backgroundColor: Constant.MAIN_BASE_COLOR,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    appLanguage.changeLanguage(Locale("en"));
                  },
                  child: Text('English'),
                ),
                RaisedButton(
                  onPressed: () {
                    appLanguage.changeLanguage(Locale("th"));
                  },
                  child: Text('ไทย'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

}