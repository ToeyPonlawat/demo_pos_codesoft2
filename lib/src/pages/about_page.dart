import 'package:alphadealdemo/src/locale/app_localization.dart';
import 'package:alphadealdemo/src/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

var globalScreen;

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    globalScreen = screenSize;
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      color: Constant.MAIN_BASE_COLOR,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Color.fromRGBO(254, 254, 254, 1),
            width: double.infinity,
            child: Column(
              children: <Widget>[
                StickyHeader(
                  header: Stack(children: <Widget>[
                    Container(
                      height: 100,
                      padding: EdgeInsets.only(bottom: 0, top: 0),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: ExactAssetImage(
                                'assets/images/pic-about-banner.jpg'),
                            fit: BoxFit.cover,
                          ),
                          color: Color.fromRGBO(253, 250, 254, 1.0),
                          shape: BoxShape.rectangle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black38,
                              offset: const Offset(0.0, 6.0),
                              blurRadius: 3.0,
                              spreadRadius: 1.0,
                            ),
                          ]),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: screenSize.height * 0.1,
                      child: Text(
                        AppLocalizations.of(context)
                            .translate('general_label_about'),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: (screenSize.width / 100) * 7.5,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              BoxShadow(
                                color: Colors.black,
                                offset: const Offset(1.0, 1.0),
                                blurRadius: 5.0,
                                spreadRadius: 5.0,
                              ),
                            ]),
                      ),
                    )
                  ]),
                  content: Container(
                    width: double.infinity,
                    color: Colors.white,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                      top: (screenSize.height / screenSize.width) * 15,
                    ),
                    padding: EdgeInsets.all((screenSize.width / 100) * 5),
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: '" Provide ',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Prompt',
                                fontStyle: FontStyle.italic,
                                fontSize: 16)),
                        TextSpan(
                            text: 'high quality ',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                        TextSpan(
                            text: 'products \n       with reasonable price.',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Prompt',
                                fontStyle: FontStyle.italic,
                                fontSize: 16)),
                        TextSpan(
                            text: '\n\tOffer swift and ',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Prompt',
                                fontStyle: FontStyle.italic,
                                fontSize: 16)),
                        TextSpan(
                            text: 'excellent services. ',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        TextSpan(
                            text: '\n\t\t In addition, \n      exceptional ',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Prompt',
                                fontStyle: FontStyle.italic,
                                fontSize: 16)),
                        TextSpan(
                            text: 'product warranty',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Prompt',
                                fontStyle: FontStyle.italic,
                                fontSize: 16,
                                decoration: TextDecoration.underline)),
                        TextSpan(
                            text: ' "',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Prompt',
                                fontStyle: FontStyle.italic,
                                fontSize: 16)),
                      ]),
                    ),
                  ),
                ),
                StickyHeader(
                  overlapHeaders: false,
                  header: Container(
                    padding: EdgeInsets.only(bottom: 10, top: 0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            offset: const Offset(0.0, 3.0),
                            blurRadius: 2.0,
                            spreadRadius: 0.0,
                          ),
                        ]),
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(left: 10, top: 20),
                          padding: EdgeInsets.only(left: 5),
                          child: Text(
                            'Who we are',
                            style: TextStyle(
                              color: Constant.MAIN_BASE_COLOR,
                              fontSize: (screenSize.width / 100) * 6,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: screenSize.height / screenSize.width,
                          color: Constant.MAIN_BASE_COLOR,
                          margin: EdgeInsets.only(left: 10, right: 10),
                        ),
                      ],
                    ),
                  ),
                  content: Container(
                      width: double.infinity,
                      height: screenSize.width * 2,
                      color: Colors.white,
                      margin: EdgeInsets.all(20),
                      child: Column(
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: 'A',
                                    style: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    )),
                                TextSpan(
                                    text: 'lpha Deal was established in 2011, '
                                        'We are a leading supplier of welding consumable product in Thailand , '
                                        'Especial in Spot welding ,Machining and Special Tools.',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Prompt',
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          RichText(
                            text: TextSpan(
                                text:
                                    'We offer complete services in welding and machining world : '
                                    'Wire Cut machine, CNC / manual machining, '
                                    'CNC / manual Milling, grinding, consulting and designing robot parts and arms.'
                                    'With a team of trained professional, advance technology manufacturing, strictly in quality control, '
                                    'high standard products with accelerated production that make us a leading company in industry for you best satisfaction and your expect an increase business.',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Prompt',
                                )),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
