import 'dart:convert';

import 'package:alphadealdemo/src/bloc/database_bloc.dart';
import 'package:alphadealdemo/src/locale/app_localization.dart';
import 'package:alphadealdemo/src/models/cart.dart';
import 'package:alphadealdemo/src/models/product.dart';
import 'package:alphadealdemo/src/pages/cart_page.dart';
import 'package:alphadealdemo/src/pages/wishlist_page.dart';
import 'package:alphadealdemo/src/services/databases.dart';
import 'package:alphadealdemo/src/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

var qty = 1;

Future<bool> checkIsLogin() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getBool("isLogin") ?? false;
}

Future<String> getClientId() async {
  String a = await DBProvider.db.getClientId();
  return a ?? false;
}

// fetch Slide data
Future<int> fetchWishlistCount(String cuscode) async {
  final url =
      Constant.MAIN_URL_API + 'wishlist_app/?app=pdts&XVConCode=' + cuscode;
  final response = await http.get(url);
  return parseWishListCount(response.body);
}

int parseWishListCount(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  List<CartQuery> a =
      parsed.map<CartQuery>((json) => CartQuery.fromJson(json)).toList();
  return a.length;
}

// fetch Group Icon data
Future<ProductDetail> fetchModelDetail(String mdlCode) async {
  final url = Constant.URL_FRONT + 'product_model/$mdlCode?app=pdt';
  //print(url);
  final response = await http.get(url);
  return parseModelDetail(response.body);
}

ProductDetail parseModelDetail(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return ProductDetail.fromJson(parsed);
}

// fetch Group Icon data
Future<List<ModelList>> fetchModelList(String mdlCode) async {
  final url = Constant.URL_FRONT + 'product_model/$mdlCode?app=all';
  final response = await http.get(url);
  return parseModelList(response.body);
}

List<ModelList> parseModelList(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<ModelList>((json) => ModelList.fromJson(json)).toList();
}

class ModelDetailPage extends StatefulWidget {
  final String mdlCode;

  const ModelDetailPage({Key key, this.mdlCode}) : super(key: key);

  @override
  _ModelDetailPageState createState() => _ModelDetailPageState();
}

class _ModelDetailPageState extends State<ModelDetailPage> {
  void goRefreshParent() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var screenSize = MediaQuery.of(context).size;
    // TODO: implement build
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        color: Constant.MAIN_BASE_COLOR,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                StickyHeader(
                  header: Container(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
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
                      width: double.infinity,
                      height: (screenSize.height / 100) * 7.5,
                      child: _buildDefaultSearch(screenSize)),
                  content: Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        FutureBuilder<ProductDetail>(
                          future: fetchModelDetail(widget.mdlCode),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) print(snapshot.error);
                            //print(snapshot.data);
                            return snapshot.hasData
                                ? ModelDetailLayout(
                                    modelDetaiList: snapshot.data,
                                    mdlCode: widget.mdlCode,
                                    goRefresh: goRefreshParent,
                                  )
                                : Center(child: CircularProgressIndicator());
                          },
                        ),
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
}

class ModelDetailLayout extends StatefulWidget {
  final ProductDetail modelDetaiList;
  final String mdlCode;
  final Function goRefresh;

  ModelDetailLayout(
      {Key key, this.modelDetaiList, this.mdlCode, this.goRefresh})
      : super(key: key);

  void goRefreshParent() {
    goRefresh();
  }

  @override
  _ModelDetailLayoutState createState() => _ModelDetailLayoutState();
}

class _ModelDetailLayoutState extends State<ModelDetailLayout> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    // TODO: implement build
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 12, right: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.modelDetaiList.XVPdtName_th,
              style: TextStyle(
                  fontSize: (screenSize.width / 100) * 6,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.modelDetaiList.XVPdtName_en,
              style: TextStyle(
                  fontSize: (screenSize.width / 100) * 6,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Container(
          width: screenSize.width - (screenSize.width / 7.5),
          height: screenSize.width - (screenSize.width / 7.5),
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(screenSize.width / 10),
                child: (widget.modelDetaiList.pdtImg != null)
                    ? Image.network(
                        Constant.MAIN_URL_ASSETS + widget.modelDetaiList.pdtImg)
                    : Image.asset('assets/images/not-found.png'),
              ),
              Positioned(
                left: 4,
                top: 4,
                child: Container(
                  width: screenSize.width / 5,
                  height: (screenSize.width / 5),
                  child: Image.network(
                      Constant.MAIN_URL_ASSETS + widget.modelDetaiList.bndImg),
                  //color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
          thickness: 3,
          color: Constant.MAIN_BASE_COLOR,
        ),
        Container(
          width: double.infinity,
          color: Color.fromRGBO(100, 100, 100, 0.075),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 8.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.fiber_manual_record,
                      size: 10,
                      color: Colors.black,
                    ),
                    Text(
                      ' Model : ' + widget.modelDetaiList.XVMdlCodeSpl,
                      style: TextStyle(
                          fontSize: (screenSize.width / 100) * 4,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: (screenSize.width / 100) * 8,
                      height: (screenSize.width / 100) * 8,
                      alignment: Alignment.center,
                      child: IconButton(
                        onPressed: () {
//                    launch(Uri.encodeFull(Constant.MAIN_URL_ASSETS +
//                        widget.productDetaiList.XVPdtWPdf));
                        },
                        icon: Icon(
                          Icons.picture_as_pdf,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'ระยะเวลาในการจัดส่ง ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: (screenSize.width / 100) * 4,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.modelDetaiList.XNPdtWShipDay,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                            fontSize: (screenSize.width / 100) * 3.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          ' วัน',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: (screenSize.width / 100) * 3.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
          thickness: 3,
          color: Constant.MAIN_BASE_COLOR,
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(100, 100, 100, 0.075),
                border: Border.symmetric(
                  vertical: BorderSide(
                    width: 2,
                    style: BorderStyle.solid,
                    color: Colors.black,
                  ),
                ),
              ),
              alignment: Alignment.center,
              height: (screenSize.width / 100) * 12,
              width: screenSize.width * 0.3,
              child: Text(
                'รหัสสินค้า',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: (screenSize.width / 100) * 3,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(100, 100, 100, 0.075),
                border: Border.symmetric(
                  vertical: BorderSide(
                    width: 2,
                    style: BorderStyle.solid,
                    color: Colors.black,
                  ),
                  horizontal: BorderSide(
                    width: 1,
                    style: BorderStyle.solid,
                    color: Colors.black,
                  ),
                ),
              ),
              alignment: Alignment.center,
              width: screenSize.width * 0.3,
              height: (screenSize.width / 100) * 12,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Product Model',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: (screenSize.width / 100) * 3,
                    ),
                  ),
                  Text(
                    '(SIZE)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: (screenSize.width / 100) * 2.75,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(100, 100, 100, 0.075),
                border: Border.symmetric(
                  vertical: BorderSide(
                    width: 2,
                    style: BorderStyle.solid,
                    color: Colors.black,
                  ),
                ),
              ),
              alignment: Alignment.center,
              width: screenSize.width * 0.25,
              height: (screenSize.width / 100) * 12,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        'ราคา',
                        style: TextStyle(
                          fontSize: (screenSize.width / 100) * 3,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.clip,
                      ),
                      Text(
                        '(PCE.)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: (screenSize.width / 100) * 2.75,
                        ),
                        overflow: TextOverflow.clip,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(100, 100, 100, 0.075),
                border: Border(
                  left: BorderSide(
                    width: 1,
                    style: BorderStyle.solid,
                    color: Colors.black,
                  ),
                  top: BorderSide(
                    width: 2,
                    style: BorderStyle.solid,
                    color: Colors.black,
                  ),
                  bottom: BorderSide(
                    width: 2,
                    style: BorderStyle.solid,
                    color: Colors.black,
                  ),
                ),
              ),
              width: screenSize.width * 0.15,
              height: (screenSize.width / 100) * 12,
              child: Text(
                '',
                overflow: TextOverflow.clip,
              ),
            ),
          ],
        ),
        FutureBuilder(
          future: fetchModelList(widget.mdlCode),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            //print(snapshot.data);
            return snapshot.hasData
                ? ModelListDetail(
                    modelList: snapshot.data,
                    goRefresh: widget.goRefreshParent,
                  )
                : Center(child: CircularProgressIndicator());
          },
        ),
      ],
    );
  }
}

class ModelListDetail extends StatefulWidget {
  final List<ModelList> modelList;
  final Function goRefresh;

  ModelListDetail({Key key, this.modelList, this.goRefresh}) : super(key: key);

  void goReParent() {
    goRefresh();
  }

  @override
  _ModelListDetailState createState() => _ModelListDetailState();
}

class _ModelListDetailState extends State<ModelListDetail> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    // TODO: implement build
    return Column(
      children: <Widget>[
        for (var i = 0; i < widget.modelList.length; i++)
          Row(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.075),
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      style: BorderStyle.solid,
                      color: Colors.black,
                    ),
                  ),
                ),
                alignment: Alignment.center,
                height: (screenSize.width / 100) * 10,
                width: screenSize.width * 0.3,
                child: Text(
                  widget.modelList[i].XVSkuCode,
                  style: TextStyle(
                    fontSize: (screenSize.width / 100) * 3,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.075),
                  border: Border(
                    left: BorderSide(
                      width: 1,
                      style: BorderStyle.solid,
                      color: Colors.black,
                    ),
                    right: BorderSide(
                      width: 1,
                      style: BorderStyle.solid,
                      color: Colors.black,
                    ),
                    bottom: BorderSide(
                      width: 1,
                      style: BorderStyle.solid,
                      color: Colors.black,
                    ),
                  ),
                ),
                alignment: Alignment.center,
                width: screenSize.width * 0.3,
                height: (screenSize.width / 100) * 10,
                child: Text(
                  widget.modelList[i].XVPdtSpec,
                  style: TextStyle(
                    fontSize: (screenSize.width / 100) * 3,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.075),
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      style: BorderStyle.solid,
                      color: Colors.black,
                    ),
                  ),
                ),
                alignment: Alignment.center,
                width: screenSize.width * 0.25,
                height: (screenSize.width / 100) * 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      widget.modelList[i].XFPdtStdPrice,
                      style: TextStyle(
                        fontSize: (screenSize.width / 100) * 3,
                      ),
                      overflow: TextOverflow.clip,
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  border: Border(
                    left: BorderSide(
                      width: 1,
                      style: BorderStyle.solid,
                      color: Colors.black,
                    ),
                    bottom: BorderSide(
                      width: 1,
                      style: BorderStyle.solid,
                      color: Colors.black,
                    ),
                  ),
                ),
                width: screenSize.width * 0.15,
                height: (screenSize.width / 100) * 10,
                child: IconButton(
                  onPressed: () async {
                    var isLogin = await checkIsLogin();
                    if (isLogin == true) {
                      showMaterialModalBottomSheet(
                        expand: false,
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context, scrollController) => ModalFit(
                          scrollController: scrollController,
                          pdtCode: widget.modelList[i].XVPdtCode,
                          pdtSpec: widget.modelList[i].XVPdtSpec,
                          pdtPrice: widget.modelList[i].XFPdtStdPrice,
                        ),
                      ).then((value) {
                        if (value) {
                          final snackBar = SnackBar(
                            content: Text('เพิ่มสินค้าไปยังรถเข็นแล้ว'),
                            action: SnackBarAction(
                              label: 'ดูรถเข็น',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CartPage(),
                                  ),
                                ).then((value) => setState(() {}));
                              },
                            ),
                          );

                          Scaffold.of(context).showSnackBar(snackBar);

                          setState(() {
                            qty = 1;
                            widget.goReParent();
                          });
                        }
                        return null;
                      });
                    } else {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/profile', (Route<dynamic> route) => false);
                    }
                  },
                  icon: Icon(
                    Icons.add_shopping_cart,
                    color: Colors.white,
                    size: (screenSize.width / 100) * 5,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  void showDialogInputQty() {
    TextEditingController qtyText = new TextEditingController();
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'ระบุจำนวน',
            style: TextStyle(color: Colors.green),
          ),
          content: TextField(
            controller: qtyText,
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                color: Colors.green,
                child: Text(
                  'ตกลง',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
//                  var a = int.parse(qtyText.text);
//                  qty = a;
//                  setState(() {});
//                  //print(qty);
//
//                  Navigator.pop(context);
//                  return;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                color: Colors.blue,
                child: Text(
                  'ปิด',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class ModalFit extends StatefulWidget {
  final ScrollController scrollController;
  final String pdtCode;
  final String pdtSpec;
  final String pdtPrice;

  const ModalFit(
      {Key key,
      this.scrollController,
      this.pdtCode,
      this.pdtSpec,
      this.pdtPrice})
      : super(key: key);

  @override
  _ModalFitState createState() => _ModalFitState();
}

class _ModalFitState extends State<ModalFit> {
  final cartBloc = CartBloc();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Material(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        width: screenSize.width,
        height: screenSize.height / 3.5,
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'จำนวน',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerRight,
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              int j = qty;
                              if (j == 1) {
                                //print(j);
                                return;
                              } else {
                                j--;
                                qty = j;
                                setState(() {});
                                //print(qty);
                                return;
                              }
                            },
                            child: Container(
                              height: (screenSize.width / 100) * 8,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 1),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black54, width: 1),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  bottomLeft: Radius.circular(4),
                                ),
                              ),
                              child: Text(
                                '-',
                                style: TextStyle(
                                    fontSize: (screenSize.width / 100) * 6),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              //showDialogInputQty();
                            },
                            child: Container(
                              height: (screenSize.width / 100) * 8,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide.none,
                                  right: BorderSide.none,
                                  top: BorderSide(
                                    color: Colors.black54,
                                    width: 1,
                                  ),
                                  bottom: BorderSide(
                                    color: Colors.black54,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Text(
                                qty.toString(),
                                style: TextStyle(
                                    fontSize: (screenSize.width / 100) * 5),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              qty++;
                              setState(() {});
                            },
                            child: Container(
                              height: (screenSize.width / 100) * 8,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 1),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black54, width: 1),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(4),
                                  bottomRight: Radius.circular(4),
                                ),
                              ),
                              child: Text(
                                '+',
                                style: TextStyle(
                                    fontSize: (screenSize.width / 100) * 6),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        '฿ ' + widget.pdtPrice,
//                                  formatCurrency.format(
//                                    double.parse(widget
//                                        .cartListShow[i].XFPdtStdPrice)
//                                        .toDouble(),
//                                  ),
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: (screenSize.width / 100) * 8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          'Model (SIZE)  ',
                          style: TextStyle(
                            fontSize: (screenSize.width / 100) * 3.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          widget.pdtSpec,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                            fontSize: (screenSize.width / 100) * 3.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        var pdtCode = widget.pdtCode;
                        var pdtPrice = widget.pdtPrice;
                        Cart n = new Cart(
                            XVBarCode: pdtCode,
                            XVBarName: '',
                            XVBarNameOth: '',
                            XFBarRetPri1: pdtPrice,
                            XIQty: qty);
                        cartBloc.add(n);

                        Navigator.of(context).pop(true);
                        return true;
                      },
                      child: Container(
                        height: 40,
                        padding: EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: Colors.blue),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.add_shopping_cart,
                                color: Colors.white,
                                size: (screenSize.width / 100) * 5,
                              ),
                            ),
                            Text(
                              'ใส่รถเข็น',
                              style: TextStyle(
                                  fontSize: (screenSize.width / 100) * 4,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
