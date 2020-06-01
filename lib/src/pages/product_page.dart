import 'dart:convert';
import 'package:alphadealdemo/src/locale/app_localization.dart';
import 'package:alphadealdemo/src/models/home.dart';
import 'package:alphadealdemo/src/pages/subgroup_page.dart';
import 'package:alphadealdemo/src/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:http/http.dart' as http;


var globalScreen;

// fetch Group Icon data
Future<List<ProductGroup>> fetchProductGroup() async {
  final url = Constant.MAIN_URL_SERVICES + 'pdt_group';
  final response = await http.get(url);
  return parseProductGroup(response.body);
}

List<ProductGroup> parseProductGroup(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<ProductGroup>((json) => ProductGroup.fromJson(json))
      .toList();
}

class ProductPage extends StatelessWidget {
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
                      Container(
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
                                    decoration: BoxDecoration(border: Border.all(width: 1)),
                                    child: TextField(
                                      autofocus: false,
                                      decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          hintText: 'ชื่อสินค้า/รหัสสินค้า/ประเภทสินค้า',
                                          contentPadding: EdgeInsets.only(
                                              left: 7, top: 5, right: 20, bottom: 7)),
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
                      ),
                      _buildGroupIconFuture()
                    ],
                  )
                ),
                content: Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(top: screenSize.height/100),
                  child: Column(
                    children: <Widget>[
                      FutureBuilder<List<ProductGroup>>(
                        future: fetchProductGroup(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) print(snapshot.error);

                          return snapshot.hasData
                              ? GroupList(groupList: snapshot.data)
                              : Center(child: CircularProgressIndicator());
                        },
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 75)),
                    ],
                  ),
                )
              ),
            ],
          )
        ),
      ),
    );
  }

  FutureBuilder<List<ProductGroup>> _buildGroupIconFuture() {
    return FutureBuilder<List<ProductGroup>>(
      future: fetchProductGroup(),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);

        return snapshot.hasData
            ? GroupIconList(
          groupList: snapshot.data,
        )
            : Center(child: CircularProgressIndicator());
      },
    );
  }
}

// ignore: must_be_immutable
class GroupList extends StatelessWidget {
  Size screenSize = globalScreen;
  final List<ProductGroup> groupList;
  final List<SubGroup> subList;

  GroupList({Key key, this.groupList, this.subList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    int row = groupList.length;
    return Column(
      children: <Widget>[
        for (int i = 0; i < row; i++)
          Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 70,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Hexcolor(groupList[i].XVGrpColor1),
                      Hexcolor(groupList[i].XVGrpColor2)
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
                            Hexcolor(groupList[i].XVGrpColor3),
                            Color(int.parse(
                                groupList[i].XVGrpColor3.substring(1, 7),
                                radix: 16) +
                                0)
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)
                            .translate('general_label_group') +
                            ' ' +
                            (i + 1).toString(),
                        style: TextStyle(
                          color: Hexcolor(groupList[i].XVGrpColor2),
                          fontWeight: FontWeight.bold,
                          fontSize: (screenSize.width / 100) * 3.75,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: (screenSize.width / 100) * 5,
                      left: (screenSize.width / 100) * 4,
                      child: Text(
                        groupList[i].XVGrpName_th,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: (screenSize.width / 100) * 2.75,
                        ),
                      ),
                    ),
                    Positioned(
                      left: (screenSize.width / 100) * 4,
                      bottom: (screenSize.width / 100) * 1,
                      child: Text(
                        groupList[i].XVGrpName_en,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: (screenSize.width / 100) * 2.75,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 4,
                      child: Image.network(
                        Constant.MAIN_URL_ASSETS + groupList[i].XVGrpBannerFile,
                        alignment: Alignment.topRight,
                        width: screenSize.width * .6,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: ((groupList[i].subgroup.length / 3).ceil() *
                    (screenSize.width / 3)),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  physics: new NeverScrollableScrollPhysics(),
                  itemCount: groupList[i].subgroup.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        var subcode = groupList[i].subgroup[index].XVSubCode;
                        var grpcode = groupList[i].XVGrpCode;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SubGroupPage(
                                subcode: subcode,
                                grpcode: grpcode,
                              )),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.all(4),
                        child: Stack(
                          children: <Widget>[
                            Image.network(Constant.MAIN_URL_ASSETS +
                                groupList[i].XVGrpBoxFile),
                            Container(
                              padding: EdgeInsets.all(12),
                              alignment: Alignment.bottomCenter,
                              child: Image.network(
                                Constant.MAIN_URL_ASSETS +
                                    groupList[i].subgroup[index].XVImgFile,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Text(
                                groupList[i].subgroup[index].XVSubName_th,
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Hexcolor(groupList[i].XVGrpColor5)),
                              ),
                            ),
                            Positioned(
                              top: 24,
                              left: 8,
                              child: Text(
                                groupList[i].subgroup[index].XVSubName_en,
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Hexcolor(groupList[i].XVGrpColor5)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
      ],
    );
  }
}

// ignore: must_be_immutable
class GroupIconList extends StatelessWidget {
  Size screenSize = globalScreen;
  final List<ProductGroup> groupList;

  GroupIconList({Key key, this.groupList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: double.infinity,
      height: ((groupList.length / 5.75).ceil() * (screenSize.width / 5.75)),
      margin: EdgeInsets.only(
          left: (screenSize.width * 0.025), right: (screenSize.width * 0.025)),
      padding: EdgeInsets.only(
          left: (screenSize.width * 0.025), right: (screenSize.width * 0.025)),
      child: ListView.builder(
        itemCount: groupList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              width: ((groupList.length / 6.25).ceil() *
                  (screenSize.width / 6.25)),
              margin: EdgeInsets.only(right: (screenSize.width * 0.025)),
              child: Column(
                children: <Widget>[
                  Container(
                    width: ((groupList.length / 10.25).ceil() *
                        (screenSize.width / 10.25)),
                    height: ((groupList.length / 12.25).ceil() *
                        (screenSize.width / 12.25)),
                    margin: EdgeInsets.only(top: (screenSize.height * 0.0125)),
                    alignment: Alignment.topCenter,
                    child: Image.network(
                      Constant.MAIN_URL_ASSETS + groupList[index].XVGrpIconFile,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      (AppLocalizations.of(context).locale.toString() == 'th')
                          ? groupList[index].XVGrpName_th
                          : groupList[index].XVGrpName_en,
                      style: TextStyle(fontSize: 10),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}