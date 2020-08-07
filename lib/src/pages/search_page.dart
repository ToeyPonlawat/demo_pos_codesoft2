import 'package:alphadealdemo/src/locale/app_localization.dart';
import 'package:alphadealdemo/src/pages/search_result_page.dart';
import 'package:alphadealdemo/src/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    TextEditingController editingController = new TextEditingController();
    var screenSize = MediaQuery.of(context).size;
    var scWidth = screenSize.width;

    return Scaffold(
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        color: Constant.MAIN_BASE_COLOR,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                StickyHeader(
                  header: Container(
                    padding: EdgeInsets.only(bottom: 0, top: 0),
                    decoration: BoxDecoration(
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
                    child: Column(
                      children: <Widget>[
                        (scWidth < 600)
                            ? Container(
                                width: double.infinity,
                                height: (screenSize.height / 100) * 7.5,
                                padding: EdgeInsets.only(top: 5),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: (screenSize.width * 0.74),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Container(
                                            width: (screenSize.width * 0.55),
                                            height: 40,
                                            decoration: BoxDecoration(
                                                border: Border.all(width: 1)),
                                            child: TextField(
                                              controller: editingController,
                                              autofocus: true,
                                              decoration: InputDecoration(
                                                  fillColor: Colors.white,
                                                  hintText: AppLocalizations.of(
                                                          context)
                                                      .translate(
                                                          'home_label_default_search'),
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          left: 7,
                                                          top: 5,
                                                          right: 20,
                                                          bottom: 7)),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              var textSearch =
                                                  editingController.text;
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SearchResultPage(
                                                          textSearch:
                                                              textSearch),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: (screenSize.width * 0.14),
                                              height: 40,
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(width: 1),
                                                  top: BorderSide(width: 1),
                                                  right: BorderSide(width: 1),
                                                ),
                                                color: Colors.amber,
                                              ),
                                              child: Icon(
                                                Icons.search,
                                                color: Colors.black,
                                                size: 36,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    FlatButton(
                                      child: Text('ยกเลิก'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                ),
                              )
                            : Container(
                                width: double.infinity,
                                height: (screenSize.height * 0.070),
                                padding: EdgeInsets.only(top: 5, bottom: 12),
                                color: Color.fromRGBO(253, 250, 254, 1.0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 12,
                                          top: 12,
                                          right: 18,
                                          bottom: 0),
                                      child: Image.asset(
                                        'assets/images/logo-full.png',
                                      ),
                                    ),
                                    Container(
                                      width: (screenSize.width * 0.5),
                                      margin: EdgeInsets.only(right: 12),
                                      alignment: Alignment.bottomCenter,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Container(
                                            width: (screenSize.width * 0.42),
                                            height: 40,
                                            decoration: BoxDecoration(
                                                border: Border.all(width: 1)),
                                            child: TextField(
                                              controller: editingController,
                                              autofocus: true,
                                              style: TextStyle(fontSize: 16),
                                              decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                hintText: AppLocalizations.of(
                                                        context)
                                                    .translate(
                                                        'home_label_default_search'),
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.only(
                                                    bottom: 5,
                                                    left: 10,
                                                    top: 5),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              var textSearch =
                                                  editingController.text;
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SearchResultPage(
                                                          textSearch:
                                                              textSearch),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: (screenSize.width * 0.08),
                                              height: 40,
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(width: 1),
                                                  top: BorderSide(width: 1),
                                                  right: BorderSide(width: 1),
                                                ),
                                                color: Colors.amber,
                                              ),
                                              child: Icon(
                                                Icons.search,
                                                color: Colors.black,
                                                size: 36,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    FlatButton(
                                      child: Text('ยกเลิก'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                  content: Container(
                    width: double.infinity,
                    height: screenSize.height,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
