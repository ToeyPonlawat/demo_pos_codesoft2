import 'package:flutter/material.dart';

class LogoPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
          child: Center(
            child: IconButton(
              icon: Image.asset(
                'assets/images/logo-mini.png',
              ),
              iconSize: 128,
            ),
          )
      ),
    );
  }

//  Future<bool> checkLocale() async{
//    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//  }


}