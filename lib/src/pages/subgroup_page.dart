import 'package:alphadealdemo/src/locale/app_localization.dart';
import 'package:alphadealdemo/src/models/cart.dart';
import 'package:alphadealdemo/src/models/home.dart';
import 'package:alphadealdemo/src/models/subgroup.dart';
import 'package:alphadealdemo/src/pages/cart_page.dart';
import 'package:alphadealdemo/src/pages/category_page.dart' as catPage;
import 'package:alphadealdemo/src/pages/home_page.dart';
import 'package:alphadealdemo/src/pages/wishlist_page.dart';
import 'package:alphadealdemo/src/services/databases.dart';
import 'package:alphadealdemo/src/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:sticky_headers/sticky_headers.dart';

var globalScreen;
int intitialDonut = 0;

Future<bool> checkIsLogin() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getBool("isLogin") ?? false;
}

Future<String> getClientId() async {
  String a = await DBProvider.db.getClientId();
  //print(a);
  return a ?? false;
}

// fetch Slide data
Future<int> fetchWishlistCount(String cuscode) async {
  final url =
      Constant.MAIN_URL_API + 'wishlist_app/?app=pdts&XVConCode=' + cuscode;
  final response = await http.get(url);
  //print(url);
  return parseWishListCount(response.body);
}

int parseWishListCount(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  List<CartQuery> a =
      parsed.map<CartQuery>((json) => CartQuery.fromJson(json)).toList();
  return a.length;
}

// fetch Group Icon data
Future<GroupBanner> fetchGroup(String grpCode, String subCode) async {
  final url =
      Constant.CAT_URL_SERVICES + grpCode + '/' + subCode + '?app=pdt_group';
  //print(url);
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
} // fetch Group Icon data

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

class SubGroupPage extends StatefulWidget {
  final String grpcode;
  final String subcode;
  final Function goToDonut;

  void goToDonutParent() {
    goToDonut();
  }

  SubGroupPage({Key key, @required this.subcode, this.grpcode, this.goToDonut})
      : super(key: key);

  @override
  _SubGroupPageState createState() => _SubGroupPageState();
}

class _SubGroupPageState extends State<SubGroupPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var screenSize = MediaQuery.of(context).size;
    var scWidth = screenSize.width;
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
                    child: Column(
                      children: <Widget>[
                        _buildDefaultSearch(screenSize),
                        (scWidth < 600)
                            ? FutureBuilder<List<ProductGroup>>(
                                future: fetchProductGroup(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) print(snapshot.error);

                                  return snapshot.hasData
                                      ? GroupIconList(
                                          groupList: snapshot.data,
                                          goToDonut: widget.goToDonut,
                                        )
                                      : Center(
                                          child: CircularProgressIndicator());
                                },
                              )
                            : SizedBox()
                      ],
                    ),
                  ),
                  content: Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(top: screenSize.height / 100),
                    child: Column(
                      children: <Widget>[
                        FutureBuilder<GroupBanner>(
                          future: fetchGroup(widget.grpcode, widget.subcode),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) print(snapshot.error);

                            return snapshot.hasData
                                ? GroupBannerList(groupList: snapshot.data)
                                : Center(child: CircularProgressIndicator());
                          },
                        ),
                        FutureBuilder<List<Category>>(
                          future: fetchCategory(widget.grpcode, widget.subcode),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) print(snapshot.error);

                            return snapshot.hasData
                                ? CategoryList(categoryList: snapshot.data)
                                : SizedBox();
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

  Container _buildDefaultSearch(Size screenSize) {
    var scWidth = MediaQuery.of(context).size.width;
    if (scWidth < 600) {
      return Container(
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
                          hintText: AppLocalizations.of(context)
                              .translate('home_label_default_search'),
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
                    onPressed: () async {
                      var isLogin = await checkIsLogin();
                      (isLogin)
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CartPage(),
                              ),
                            ).then((value) => setState(() {}))
                          : Navigator.of(context).pushNamedAndRemoveUntil(
                              '/profile', (Route<dynamic> route) => false);
                    },
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Colors.black,
                      size: 30,
                    ),
                    padding: EdgeInsets.only(bottom: 0.5),
                  ),
                  FutureBuilder(
                    future: checkIsLogin(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data == true) {
                          return _buildNotiCart();
                        }
                        return SizedBox();
                      }
                      return SizedBox();
                    },
                  ),
                ],
              ),
            ),
            Container(
              width: (screenSize.width * 0.10),
              alignment: Alignment.centerLeft,
              child: Stack(
                children: <Widget>[
                  IconButton(
                    onPressed: () async {
                      var isLogin = await checkIsLogin();
                      if (isLogin) {
                        var cusCode = await getClientId();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                WishListPage(cuscode: cusCode),
                          ),
                        ).then((value) => setState(() {}));
                      } else {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/profile', (Route<dynamic> route) => false);
                      }
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.black,
                      size: 30,
                    ),
                    padding: EdgeInsets.only(bottom: 0.5),
                  ),
                  FutureBuilder(
                    future: DBProvider.db.getClientId(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data != null &&
                            snapshot.hasError == false) {
                          return _buildNotiWishlist(snapshot.data);
                        }
                        return SizedBox();
                      }
                      return SizedBox();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        height: (screenSize.height * 0.070),
        padding: EdgeInsets.only(top: 5, bottom: 12),
        color: Color.fromRGBO(253, 250, 254, 1.0),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 12, top: 12, right: 18, bottom: 0),
              child: Image.asset(
                'assets/images/logo-full.png',
              ),
            ),
            Container(
              width: (screenSize.width * 0.5),
              margin: EdgeInsets.only(right: 12),
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: (screenSize.width * 0.42),
                    height: 40,
                    decoration: BoxDecoration(border: Border.all(width: 1)),
                    child: TextField(
                      autofocus: false,
                      style: TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        hintText: 'ชื่อสินค้า/รหัสสินค้า/ประเภทสินค้า',
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.only(bottom: 5, left: 10, top: 5),
                      ),
                    ),
                  ),
                  Container(
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
                    child: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.black,
                        size: 36,
                      ),
                      padding: EdgeInsets.only(bottom: 0.5),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 12),
              width: (screenSize.width * 0.075),
              alignment: Alignment.centerRight,
              child: Stack(
                children: <Widget>[
                  IconButton(
                    onPressed: () async {
                      var isLogin = await checkIsLogin();
                      (isLogin)
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CartPage(),
                              ),
                            ).then((value) => setState(() {}))
                          : Navigator.of(context).pushNamedAndRemoveUntil(
                              '/profile', (Route<dynamic> route) => false);
                    },
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Colors.black,
                      size: 30,
                    ),
                    padding: EdgeInsets.only(bottom: 0.5),
                  ),
                  FutureBuilder(
                    future: checkIsLogin(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data == true) {
                          return _buildNotiCart();
                        }
                        return SizedBox();
                      }
                      return SizedBox();
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 12),
              width: (screenSize.width * 0.075),
              alignment: Alignment.centerLeft,
              child: Stack(
                children: <Widget>[
                  IconButton(
                    onPressed: () async {
                      var isLogin = await checkIsLogin();
                      if (isLogin) {
                        var cusCode = await getClientId();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                WishListPage(cuscode: cusCode),
                          ),
                        ).then((value) => setState(() {}));
                      } else {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/profile', (Route<dynamic> route) => false);
                      }
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.black,
                      size: 30,
                    ),
                    padding: EdgeInsets.only(bottom: 0.5),
                  ),
                  FutureBuilder(
                    future: DBProvider.db.getClientId(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data != null &&
                            snapshot.hasError == false) {
                          return _buildNotiWishlist(snapshot.data);
                        }
                        return SizedBox();
                      }
                      return SizedBox();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  FutureBuilder _buildNotiWishlist(String cuscode) {
    return FutureBuilder(
      future: fetchWishlistCount(cuscode),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if ((snapshot.data != null || snapshot.hasError == false) &&
              snapshot.data != 0) {
            return Positioned(
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
                  snapshot.data.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return SizedBox();
        }
        return SizedBox();
      },
    );
  }

  FutureBuilder _buildNotiCart() {
    return FutureBuilder(
      future: DBProvider.db.getCountNotiCart(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != 0 || snapshot.hasError == false) {
            return Positioned(
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
                  snapshot.data.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return SizedBox();
        }
        return SizedBox();
      },
    );
  }
}

class GroupBannerList extends StatelessWidget {
  final GroupBanner groupList;

  GroupBannerList({Key key, this.groupList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var scWidth = screenSize.width;
    // TODO: implement build
    if (scWidth < 600) {
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
    } else {
      return Container(
        width: double.infinity,
        height: 200,
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
              height: 50,
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
              top: (screenSize.width / 100) * 4,
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
}

class CategoryList extends StatelessWidget {
  final List<Category> categoryList;

  CategoryList({Key key, this.categoryList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var scWidth = screenSize.width;
    // TODO: implement build
    if (scWidth < 600) {
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
                    builder: (context) => catPage.CategoryPage(
                      catcode: catcode,
                    ),
                  ),
                ).then((value) => catPage.bnd = []);
              },
              child: Card(
                child: Container(
                  margin: EdgeInsets.all(4),
                  child: Stack(
                    children: <Widget>[
                      Center(
                          child:
                              Image.asset('assets/images/box-background.png')),
                      Container(
                        margin: EdgeInsets.only(
                            top: 28, left: 24, right: 24, bottom: 8),
                        alignment: Alignment.bottomCenter,
                        child: Image.network(
                          Constant.MAIN_URL_ASSETS +
                              categoryList[index].XVImgFile,
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
    } else {
      return Container(
        width: double.infinity,
        height: ((categoryList.length / 4).ceil() * (screenSize.width / 4)),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
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
                    builder: (context) => catPage.CategoryPage(
                      catcode: catcode,
                    ),
                  ),
                ).then((value) => catPage.bnd = []);
              },
              child: Card(
                child: Container(
                  margin: EdgeInsets.all(4),
                  child: Stack(
                    children: <Widget>[
                      Center(
                          child:
                              Image.asset('assets/images/box-background.png')),
                      Container(
                        margin: EdgeInsets.only(
                            top: 28, left: 24, right: 24, bottom: 8),
                        alignment: Alignment.bottomCenter,
                        child: Image.network(
                          Constant.MAIN_URL_ASSETS +
                              categoryList[index].XVImgFile,
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
}

// ignore: must_be_immutable
class GroupIconList extends StatefulWidget {
  final List<ProductGroup> groupList;

  final Function goToDonut;

  GroupIconList({Key key, this.groupList, this.goToDonut}) : super(key: key);

  @override
  _GroupIconListState createState() => _GroupIconListState();
}

class _GroupIconListState extends State<GroupIconList> {
  //Size screenSize = globalScreen;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var screenSize = MediaQuery.of(context).size;
    var scWidth = screenSize.width;
    if (scWidth < 600) {
      return Container(
        width: double.infinity,
        height: ((widget.groupList.length / 5.75).ceil() *
            (screenSize.width / 5.75)),
        margin: EdgeInsets.only(
            left: (screenSize.width * 0.025),
            right: (screenSize.width * 0.025)),
        padding: EdgeInsets.only(
            left: (screenSize.width * 0.025),
            right: (screenSize.width * 0.025)),
        child: ListView.builder(
          itemCount: widget.groupList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => HomeApp(1, index)),
                    (Route<dynamic> route) => false);
              },
              child: Container(
                width: ((widget.groupList.length / 6.25).ceil() *
                    (screenSize.width / 6.25)),
                margin: EdgeInsets.only(right: (screenSize.width * 0.025)),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: ((widget.groupList.length / 10.25).ceil() *
                          (screenSize.width / 10.25)),
                      height: ((widget.groupList.length / 12.25).ceil() *
                          (screenSize.width / 12.25)),
                      margin:
                          EdgeInsets.only(top: (screenSize.height * 0.0125)),
                      alignment: Alignment.topCenter,
                      child: Image.network(
                        Constant.MAIN_URL_ASSETS +
                            widget.groupList[index].XVGrpIconFile,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        (AppLocalizations.of(context).locale.toString() == 'th')
                            ? widget.groupList[index].XVGrpName_th
                            : widget.groupList[index].XVGrpName_en,
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
    } else {
      return SizedBox();
    }
  }
}
