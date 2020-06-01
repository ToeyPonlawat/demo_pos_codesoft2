import 'package:alphadealdemo/src/locale/app_localization.dart';
import 'package:alphadealdemo/src/models/subgroup.dart';
import 'package:alphadealdemo/src/pages/category_page.dart';
import 'package:alphadealdemo/src/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sticky_headers/sticky_headers.dart';

var globalScreen;

// fetch Group Icon data
Future<GroupBanner> fetchGroup(String grpCode, String subCode) async {
  final url =
      Constant.CAT_URL_SERVICES + grpCode + '/' + subCode + '?app=pdt_group';
  final response = await http.get(url);
  return parseGroup(response.body);
}

GroupBanner parseGroup(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return GroupBanner.fromJson(parsed);
}

// fetch Group Icon data
Future<List<Category>> fetchCategory(String grpCode, String subCode) async {
  final url =
      Constant.CAT_URL_SERVICES + grpCode + '/' + subCode + '?app=pdt_cat';
  final response = await http.get(url);
  return parseCategory(response.body);
}

List<Category> parseCategory(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Category>((json) => Category.fromJson(json)).toList();
}

class SubGroupPage extends StatelessWidget {
  final String grpcode;
  final String subcode;

  SubGroupPage({Key key, @required this.subcode, this.grpcode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var screenSize = MediaQuery.of(context).size;
    globalScreen = screenSize;
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
                      child: Container(
                        width: double.infinity,
                        height: (screenSize.height / 100) * 7.5,
                        padding: EdgeInsets.only(top: 5),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: (screenSize.width * 0.74),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    width: (screenSize.width * 0.55),
                                    height: 40,
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 1)),
                                    child: TextField(
                                      autofocus: false,
                                      decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          hintText:
                                              'ชื่อสินค้า/รหัสสินค้า/ประเภทสินค้า',
                                          contentPadding: EdgeInsets.only(
                                              left: 7,
                                              top: 5,
                                              right: 20,
                                              bottom: 7)),
                                    ),
                                  ),
                                  Container(
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
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.search,
                                        color: Colors.black,
                                        size: 30,
                                      ),
                                      padding: EdgeInsets.only(bottom: 0.5),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: (screenSize.width * 0.13),
                              alignment: Alignment.centerRight,
                              child: Stack(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(
                                      Icons.shopping_cart,
                                      color: Colors.black,
                                      size: 30,
                                    ),
                                    padding: EdgeInsets.only(bottom: 0.5),
                                  ),
                                  Positioned(
                                    right: 4,
                                    top: 4,
                                    child: Container(
                                      padding: EdgeInsets.all(1),
                                      decoration: new BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      constraints: BoxConstraints(
                                        minWidth: 14,
                                        minHeight: 14,
                                      ),
                                      child: Text(
                                        '1',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: (screenSize.width * 0.10),
                              alignment: Alignment.centerLeft,
                              child: Stack(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(
                                      Icons.favorite,
                                      color: Colors.black,
                                      size: 30,
                                    ),
                                    padding: EdgeInsets.only(bottom: 0.5),
                                  ),
                                  Positioned(
                                    right: 2,
                                    top: 4,
                                    child: Container(
                                      padding: EdgeInsets.all(1),
                                      decoration: new BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      constraints: BoxConstraints(
                                        minWidth: 14,
                                        minHeight: 14,
                                      ),
                                      child: Text(
                                        '1',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                  content: Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(top: screenSize.height / 100),
                    child: Column(
                      children: <Widget>[
                        FutureBuilder<GroupBanner>(
                          future: fetchGroup(grpcode, subcode),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) print(snapshot.error);

                            return snapshot.hasData
                                ? GroupBannerList(groupList: snapshot.data)
                                : Center(child: CircularProgressIndicator());
                          },
                        ),
                        FutureBuilder<List<Category>>(
                          future: fetchCategory(grpcode, subcode),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) print(snapshot.error);

                            return snapshot.hasData
                                ? CategoryList(categoryList: snapshot.data)
                                : Center(child: CircularProgressIndicator());
                          },
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 75)),
                      ],
                    ),
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

class GroupBannerList extends StatelessWidget {
  final GroupBanner groupList;

  GroupBannerList({Key key, this.groupList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    // TODO: implement build
    return Container(
      width: double.infinity,
      height: 110,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Hexcolor(groupList.XVGrpColor1),
            Hexcolor(groupList.XVGrpColor2)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Container(
            width: screenSize.width / 3,
            height: 25,
            padding: EdgeInsets.only(
                top: (screenSize.width / 100),
                left: (screenSize.width / 100) * 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Hexcolor(groupList.XVGrpColor3),
                  Color(int.parse(groupList.XVGrpColor3.substring(1, 7),
                          radix: 16) +
                      0)
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Text(
              AppLocalizations.of(context).translate('general_label_group') +
                  ' ' +
                  groupList.XNGrpSeq,
              style: TextStyle(
                color: Hexcolor(groupList.XVGrpColor2),
                fontWeight: FontWeight.bold,
                fontSize: (screenSize.width / 100) * 3.75,
              ),
            ),
          ),
          Positioned(
            bottom: (screenSize.width / 100) * 12,
            left: (screenSize.width / 100) * 4,
            child: Text(
              groupList.XVSubName_th,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: (screenSize.width / 100) * 3.75,
              ),
            ),
          ),
          Positioned(
            left: (screenSize.width / 100) * 4,
            bottom: (screenSize.width / 100) * 6,
            child: Text(
              groupList.XVSubName_en,
              style: TextStyle(
                color: Colors.white,
                fontSize: (screenSize.width / 100) * 3.75,
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 4,
            child: Image.network(
              Constant.MAIN_URL_ASSETS + groupList.XVImgFile,
              alignment: Alignment.topRight,
              width: screenSize.width * .45,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryList extends StatelessWidget {
  final List<Category> categoryList;

  CategoryList({Key key, this.categoryList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    // TODO: implement build
    return Container(
      width: double.infinity,
      height: ((categoryList.length / 3).ceil() * (screenSize.width / 3)),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        physics: new NeverScrollableScrollPhysics(),
        itemCount: categoryList.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              var catcode = categoryList[index].XVCatCode;
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CategoryPage(
                      catcode: catcode,
                    )),
              );
            },
            child: Card(
              child: Container(
                margin: EdgeInsets.all(4),
                child: Stack(
                  children: <Widget>[
                    Center(
                        child: Image.asset('assets/images/box-background.png')),
                    Container(
                      margin: EdgeInsets.only(
                          top: 28, left: 24, right: 24, bottom: 8),
                      alignment: Alignment.bottomCenter,
                      child: Image.network(
                        Constant.MAIN_URL_ASSETS + categoryList[index].XVImgFile,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Text(
                        categoryList[index].XVCatName_th,
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),
                    ),
                    Positioned(
                      top: 24,
                      left: 8,
                      child: Text(
                        categoryList[index].XVCatName_en,
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
