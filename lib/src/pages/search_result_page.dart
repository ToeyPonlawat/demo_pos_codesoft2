import 'dart:convert';

import 'package:alphadealdemo/src/locale/app_localization.dart';
import 'package:alphadealdemo/src/models/cart.dart';
import 'package:alphadealdemo/src/models/category.dart';
import 'package:alphadealdemo/src/pages/cart_page.dart';
import 'package:alphadealdemo/src/pages/model_detail_page.dart';
import 'package:alphadealdemo/src/pages/product_detail_page.dart';
import 'package:alphadealdemo/src/pages/wishlist_page.dart';
import 'package:alphadealdemo/src/services/databases.dart';
import 'package:alphadealdemo/src/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:http/http.dart' as http;

var globalOrder;
String searchName;

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

// fetch Product list in Category
Future<List<ProductList>> fetchProductList(
    String textSearch, String orderBy) async {
  String url = Constant.MAIN_URL_API+'search/?app=pdt&input_search=' + textSearch;
  if (orderBy != null && orderBy.length > 0) {
    url += '&selectOrderby=$orderBy';
  } else {
    url += '';
  }
  //print(url);
  final response = await http.get(url);
  return parseProductList(response.body);
}

List<ProductList> parseProductList(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  //print(parsed);
  return parsed.map<ProductList>((json) => ProductList.fromJson(json)).toList();
}

class SearchResultPage extends StatefulWidget {
  final String textSearch;

  const SearchResultPage({Key key, this.textSearch}) : super(key: key);
  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  String dropdownValue = 'ความนิยม';
  String selectOrderby;

  @override
  Widget build(BuildContext context) {
    selectOrderby = globalOrder;
    var screenSize = MediaQuery.of(context).size;
    // TODO: implement build
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
                        children: <Widget>[_buildDefaultSearch(screenSize)],
                      )),
                  content: Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(top: screenSize.height / 100),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 50,
                          width: double.infinity,
                          color: Constant.MAIN_BASE_COLOR,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              DropdownButton<String>(
                                value: dropdownValue,
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                                iconSize: 18,
                                elevation: 16,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Prompt',
                                ),
                                underline: Container(
                                  margin: EdgeInsets.only(right: 4),
                                  height: 2,
                                  color: Colors.white,
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    dropdownValue = newValue;
                                    if (newValue == 'ราคาต่ำไปสูง') {
                                      globalOrder = '1';
                                    } else if (newValue == 'ราคาสูงไปต่ำ') {
                                      globalOrder = '2';
                                    } else
                                      globalOrder = '';
                                  });
                                },
                                dropdownColor: Constant.MAIN_BASE_COLOR,
                                items: <String>[
                                  'ความนิยม',
                                  'ราคาต่ำไปสูง',
                                  'ราคาสูงไปต่ำ'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        FutureBuilder<List<ProductList>>(
                          future: fetchProductList(
                              widget.textSearch, selectOrderby),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) print(snapshot.error);

                            return snapshot.hasData
                                ? ProductGrid(productList: snapshot.data)
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

class ProductGrid extends StatelessWidget {
  final List<ProductList> productList;

  ProductGrid({
    Key key,
    this.productList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var screenSize = MediaQuery.of(context).size;
    int row = productList.length;
    print(row);
    if (row > 0) {
      (AppLocalizations.of(context).locale.toString() == 'th')
          ? searchName = productList[0].XVBndName_th
          : searchName = productList[0].XVBndName_en;
    } else {
      searchName = "";
    }

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              searchName,
              style: TextStyle(
                fontSize: (screenSize.width / 100) * 5.5,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: ((row / 3).ceil() * (screenSize.width / 3)) * 3,
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, childAspectRatio: 0.75),
            physics: new NeverScrollableScrollPhysics(),
            itemCount: row,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  var isModel = productList[index].XBPdtIsModel;
                  var pdtCode = productList[index].XVPdtCode;
                  var mdlCode = productList[index].XVModCode;
                  (isModel == "0")
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailPage(pdtCode: pdtCode),
                          ),
                        )
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ModelDetailPage(mdlCode: mdlCode),
                          ),
                        );
                },
                child: Card(
                  elevation: 4,
                  child: Container(
                    margin: EdgeInsets.all(4),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 40),
                          alignment: Alignment.center,
                          child: (productList[index].pdtImg != null)
                              ? Image.network(
                                  Constant.MAIN_URL_ASSETS +
                                      productList[index].pdtImg,
                                  fit: BoxFit.cover,
                                )
                              : SizedBox(
                                  width: 40,
                                  height: 40,
                                ),
                        ),
                        Positioned(
                          top: 8,
                          child: Text(
                            productList[index].XVPdtName_th,
                            style: TextStyle(fontSize: 10, color: Colors.black),
                          ),
                        ),
                        Positioned(
                          top: 24,
                          child: Text(
                            productList[index].XVPdtName_th,
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
        ),
      ],
    );
  }
}
