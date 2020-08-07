//import 'package:alphadealdemo/src/locale/app_localization.dart';
import 'package:alphadealdemo/src/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:sticky_headers/sticky_headers/widget.dart';

var globalScreen;

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    globalScreen = screenSize;

    return Scaffold(
      appBar: AppBar(
        title: Text('เกี่ยวกับเรา'),
        backgroundColor: Constant.MAIN_BASE_COLOR,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: Color.fromRGBO(254, 254, 254, 1),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 12, bottom: 12, left: 32, right: 32),
                child: Image.asset(
                  'assets/images/about.jpg',
                ),
              ),
            ),
            _buildBottomBanner1(),
          ],
        ),
      ),
    );
  }

  Padding _buildBottomBanner1() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 32, left: 32, right: 32),
      child: Image.asset(
        'assets/images/banner1_image.png',
      ),
    );
  }
}
