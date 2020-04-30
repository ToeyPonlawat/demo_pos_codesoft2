import 'dart:convert';
import 'dart:developer';
import 'package:alphadealdemo/src/locale/app_localization.dart';
import 'package:alphadealdemo/src/services/home_json.dart';
import 'package:alphadealdemo/src/services/post_response.dart';
import 'package:alphadealdemo/src/utils/constant.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:http/http.dart' as http;

var globalScreen;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

Future<List<ProductGroup>> fetchPost(http.Client client) async {
  final url =
      'http://apiinnovation.dyndns.org/alphadeal_frontend_api/public/?app=true';

  final response = await client.get(url);

  return parseJSON(response.body);
}

List<ProductGroup> parseJSON(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<ProductGroup>((json) => ProductGroup.fromJson(json))
      .toList();
}

//List<SubGroup> getSubByGroupID(String groupID) {
//  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
//
//  return parsed.map<ProductGroup>((json) => ProductGroup.fromJson(json)).toList();
//}

Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response =
      await client.get('https://jsonplaceholder.typicode.com/photos');

  return parsePhotos(response.body);
}

List<Photo> parsePhotos(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}

class Photo {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  Photo({this.albumId, this.id, this.title, this.url, this.thumbnailUrl});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      albumId: json['albumId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }
}

class _HomePageState extends State<HomePage> {
  ScrollController _scrollController;
  GlobalKey _keyRed = GlobalKey();
  GlobalKey _keyBlue = GlobalKey();
  GlobalKey _keyGreen = GlobalKey();
  var _jsonList;
  var offsetRed;
  var offsetGreen;
  var offsetBlue;

  _declarePosition(BuildContext context) {
//    final RenderBox renderBoxRed = _keyRed.currentContext.findRenderObject();
//    final positionBoxRed = renderBoxRed.localToGlobal(Offset.zero);
//
//    final RenderBox renderBoxGreen = _keyGreen.currentContext.findRenderObject();
//    final positionBoxGreen = renderBoxGreen.localToGlobal(Offset.zero);
//
//    final RenderBox renderBoxBlue = _keyBlue.currentContext.findRenderObject();
//    final positionBoxBlue = renderBoxBlue.localToGlobal(Offset.zero);
//
//    offsetRed = positionBoxRed.dy - 80;
//    offsetGreen = positionBoxGreen.dy - 80;
//    offsetBlue = positionBoxBlue.dy - 80;
  }

  _getPositions(String keyName) {
//    final RenderBox renderBoxRed = _keyRed.currentContext.findRenderObject();
//    final positionRed = renderBoxRed.localToGlobal(Offset.zero);
    final RenderBox renderBoxRed = _keyRed.currentContext.findRenderObject();
    final positionBoxRed = renderBoxRed.localToGlobal(Offset.zero);

    final RenderBox renderBoxGreen =
        _keyGreen.currentContext.findRenderObject();
    final positionBoxGreen = renderBoxGreen.localToGlobal(Offset.zero);

    final RenderBox renderBoxBlue = _keyBlue.currentContext.findRenderObject();
    final positionBoxBlue = renderBoxBlue.localToGlobal(Offset.zero);

    final offsetRed = positionBoxRed.dy - 160;
    final offsetGreen = positionBoxGreen.dy - 160;
    final offsetBlue = positionBoxBlue.dy - 160;

    switch (keyName) {
      case '_keyRed':
        return _scrollController.animateTo(800,
            duration: Duration(milliseconds: 200), curve: Curves.linear);
        break;
      case '_keyGreen':
        return _scrollController.animateTo(1290,
            duration: Duration(milliseconds: 200), curve: Curves.linear);
        break;
      case '_keyBlue':
        return _scrollController.animateTo(1780,
            duration: Duration(milliseconds: 200), curve: Curves.linear);
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    SchedulerBinding.instance
        .addPostFrameCallback((_) => _declarePosition(context));
  }

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    String name = myLocale.languageCode;
    log('data: $name');
    bool lang = true;
    var deviceData = MediaQuery.of(context);
    var screenSize = MediaQuery.of(context).size;
    globalScreen = screenSize;
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        color: Constant.MAIN_BASE_COLOR,
        child: SafeArea(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Container(
              color: Color.fromRGBO(253, 250, 254, 1),
              child: Column(
                children: [
                  _buildFullLogo(),
                  _buildStickyHeader(screenSize),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigate(screenSize),
    );
  }

  SafeArea _buildBottomNavigate(Size screenSize) {
    var scWidth = MediaQuery.of(context).size.width;
    if (scWidth < 760) {
      return SafeArea(
          top: false,
          child: Container(
            width: double.infinity,
            height: 50,
            color: Constant.MAIN_BASE_COLOR,
            child: Row(
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    width: screenSize.width / 5,
                    height: 48,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Icon(
                          Icons.home,
                          color: Colors.white,
                          size: 24.0,
                        ),
                        Text(
                          'Home',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: screenSize.width / 5,
                  height: 48,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(
                        Icons.redeem,
                        color: Colors.white,
                        size: 24.0,
                      ),
                      Text(
                        'Product',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: screenSize.width / 5,
                  height: 48,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(
                        Icons.business,
                        color: Colors.white,
                        size: 24.0,
                      ),
                      Text(
                        'About',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: screenSize.width / 5,
                  height: 48,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(
                        Icons.contact_phone,
                        color: Colors.white,
                        size: 24.0,
                      ),
                      Text(
                        'Contact',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: screenSize.width / 5,
                  height: 48,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 24.0,
                      ),
                      Text(
                        'Me',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ));
    } else {
      return SafeArea(
          top: false,
          child: Container(
            width: double.infinity,
            height: 80,
            color: Constant.MAIN_BASE_COLOR,
            child: Row(
              children: <Widget>[
                Container(
                  width: screenSize.width / 5,
                  height: 48,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(
                        Icons.home,
                        color: Colors.white,
                        size: 24.0,
                      ),
                      Text(
                        'Home',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: screenSize.width / 5,
                  height: 48,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(
                        Icons.redeem,
                        color: Colors.white,
                        size: 24.0,
                      ),
                      Text(
                        'Product',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: screenSize.width / 5,
                  height: 48,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(
                        Icons.business,
                        color: Colors.white,
                        size: 24.0,
                      ),
                      Text(
                        'About',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: screenSize.width / 5,
                  height: 48,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(
                        Icons.contact_phone,
                        color: Colors.white,
                        size: 24.0,
                      ),
                      Text(
                        'Contact',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: screenSize.width / 5,
                  height: 48,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 24.0,
                      ),
                      Text(
                        'Me',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ));
    }
  }

  StickyHeader _buildStickyHeader(Size screenSize) {
    var scWidth = MediaQuery.of(context).size.width;
    if (scWidth < 760) {
      return StickyHeader(
        overlapHeaders: false,
        header: Container(
          padding: EdgeInsets.only(bottom: 0),
          decoration: BoxDecoration(
            color: Color.fromRGBO(253, 250, 254, 1.0),
          ),
          child: Column(
            children: <Widget>[
              _buildDefaultSearch(screenSize),
              _buildGroupIcons(screenSize),
              Container(
                width: double.infinity,
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(250, 250, 250, 1.0),
                      Color.fromRGBO(255, 255, 255, 0.5)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              )
            ],
          ),
        ),
        content: Column(
          children: <Widget>[
            _buildSlideImage(screenSize),
            _buildNewProduct(screenSize),
            _buildBestSeller(screenSize),
            Container(
              width: double.infinity,
              height: 30,
              color: Colors.transparent,
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(top: 10, left: 1),
              child: Container(
                width: screenSize.width / 3,
                height: 40,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(60, 8, 87, 1),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20))),
                alignment: Alignment.center,
                child: Text(
                  'หมวดหมู่สินค้า',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              height: 3,
              width: double.infinity,
              color: Color.fromRGBO(60, 8, 87, 1),
            ),
            FutureBuilder<List<ProductGroup>>(
              future: fetchPost(http.Client()),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);

                return snapshot.hasData
                    ? GroupList(groupList: snapshot.data)
                    : Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      );
    } else {
      return StickyHeader(
        overlapHeaders: false,
        header: Container(
          padding: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Color.fromRGBO(253, 250, 254, 1.0),
          ),
          child: Column(
            children: <Widget>[
              _buildDefaultSearch(screenSize),
              _buildGroupIcons(screenSize),
              Container(
                width: double.infinity,
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(250, 250, 250, 1.0),
                      Color.fromRGBO(255, 255, 255, 0.5)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              )
            ],
          ),
        ),
        content: Column(
          children: <Widget>[
            _buildSlideImage(screenSize),
            _buildNewProduct(screenSize),
            _buildBestSeller(screenSize),
            Container(
              width: double.infinity,
              height: 60,
              color: Colors.transparent,
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(top: 20, left: 1),
              child: Container(
                width: screenSize.width / 4,
                height: 60,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(60, 8, 87, 1),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40))),
                alignment: Alignment.center,
                child: Text(
                  'หมวดหมู่สินค้า',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              height: 3,
              width: double.infinity,
              color: Color.fromRGBO(60, 8, 87, 1),
            ),
            Container(
              width: double.infinity,
              height: 200,
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(140, 97, 158, 1.0),
                    Color.fromRGBO(87, 17, 116, 1.0)
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
                    padding: EdgeInsets.only(top: 5, left: 32),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(217, 217, 217, 1.0),
                          Color.fromRGBO(255, 255, 255, 0)
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Text(
                      'กลุ่มที่ 1',
                      style: TextStyle(
                          color: Color.fromRGBO(87, 17, 116, 1.0),
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Positioned(
                    bottom: 60,
                    left: 32,
                    child: Text(
                      'ฮาร์ดแวร์ทูล',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 32,
                    bottom: 20,
                    child: Text(
                      'Tools & Hardware',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 5,
                    child: Image.asset(
                      'assets/images/g01.png',
                      alignment: Alignment.topRight,
                      width: screenSize.width * .63,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  Container _buildGroupIcons(Size screenSize) {
    var scWidth = MediaQuery.of(context).size.width;
    if (scWidth < 760) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
        color: Color.fromRGBO(253, 250, 254, 1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                _scrollController.jumpTo(offsetRed);
              },
              child: Container(
                width: 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/g1.png',
                      width: 30,
                      height: 30,
                    ),
                    Text(
                      'Hardware Tools',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _scrollController.jumpTo(offsetGreen);
              },
              child: Container(
                width: 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/g2.png',
                      width: 30,
                      height: 30,
                    ),
                    Text(
                      'Measurement',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _scrollController.jumpTo(offsetBlue);
              },
              child: Container(
                width: 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/g3.png',
                      width: 30,
                      height: 30,
                    ),
                    Text(
                      'Lighting',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.asset(
                    'assets/images/g4.png',
                    width: 30,
                    height: 30,
                  ),
                  Text(
                    'Machinery',
                    style: TextStyle(fontSize: 12, color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Container(
              width: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.asset(
                    'assets/images/g5.png',
                    width: 30,
                    height: 30,
                  ),
                  Text(
                    'Paint &',
                    style: TextStyle(fontSize: 12, color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
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
        padding: EdgeInsets.only(left: 60, right: 60, top: 20),
        color: Color.fromRGBO(253, 250, 254, 1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.asset(
                    'assets/images/g1.png',
                    width: 45,
                    height: 45,
                  ),
                  Text(
                    'Hardware Tools',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Container(
              width: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.asset(
                    'assets/images/g2.png',
                    width: 45,
                    height: 45,
                  ),
                  Text(
                    'Measurement',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Container(
              width: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.asset(
                    'assets/images/g3.png',
                    width: 45,
                    height: 45,
                  ),
                  Text(
                    'Lighting',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Container(
              width: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.asset(
                    'assets/images/g4.png',
                    width: 45,
                    height: 45,
                  ),
                  Text(
                    'Machinery',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Container(
              width: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.asset(
                    'assets/images/g5.png',
                    width: 45,
                    height: 45,
                  ),
                  Text(
                    'Paint &',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  Container _buildBestSeller(Size screenSize) {
    var scWidth = MediaQuery.of(context).size.width;
    if (scWidth < 760) {
      return Container(
        width: double.infinity,
        height: 220,
        padding: EdgeInsets.only(left: 10, top: 0, right: 10, bottom: 0),
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(255, 214, 55, 1.0),
              Color.fromRGBO(231, 56, 39, 1.0)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: EdgeInsets.only(top: 5, left: 5),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Best Seller',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4),
                    ),
                    Icon(
                      Icons.fiber_manual_record,
                      size: 10,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: EdgeInsets.all(4),
                    ),
                    Text(
                      'สินค้าขายดี',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.bottomLeft,
              margin: EdgeInsets.only(left: 4, right: 4, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: (screenSize.width / 3.5),
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                  Container(
                    width: (screenSize.width / 3.5),
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                  Container(
                    width: (screenSize.width / 3.5),
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        height: 420,
        padding: EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 0),
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(255, 214, 55, 1.0),
              Color.fromRGBO(231, 56, 39, 1.0)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: EdgeInsets.only(top: 10, left: 10),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Best Seller',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                    ),
                    Icon(
                      Icons.fiber_manual_record,
                      size: 20,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                    ),
                    Text(
                      'สินค้าขายดี',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.bottomLeft,
              margin: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: (screenSize.width / 4),
                    height: 320,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  Container(
                    width: (screenSize.width / 4),
                    height: 320,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  Container(
                    width: (screenSize.width / 4),
                    height: 320,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  Container _buildNewProduct(Size screenSize) {
    var scWidth = MediaQuery.of(context).size.width;
    if (scWidth < 760) {
      return Container(
        width: double.infinity,
        height: 220,
        padding: EdgeInsets.only(left: 10, top: 0, right: 10, bottom: 0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(91, 1, 126, 1.0),
              Color.fromRGBO(231, 56, 39, 1.0)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: EdgeInsets.only(top: 5, left: 5),
                child: Row(
                  children: <Widget>[
                    Text(
                      'New Product',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4),
                    ),
                    Icon(
                      Icons.fiber_manual_record,
                      size: 10,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: EdgeInsets.all(4),
                    ),
                    Text(
                      'สินค้าใหม่',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(left: 4, right: 4, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: (screenSize.width / 3.5),
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                  Container(
                    width: (screenSize.width / 3.5),
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                  Container(
                    width: (screenSize.width / 3.5),
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        height: 420,
        padding: EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 0),
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(91, 1, 126, 1.0),
              Color.fromRGBO(231, 56, 39, 1.0)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: EdgeInsets.only(top: 10, left: 10),
                child: Row(
                  children: <Widget>[
                    Text(
                      'New Product',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                    ),
                    Icon(
                      Icons.fiber_manual_record,
                      size: 20,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: EdgeInsets.all(4),
                    ),
                    Text(
                      'สินค้าใหม่',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: (screenSize.width / 4),
                    height: 320,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  Container(
                    width: (screenSize.width / 4),
                    height: 320,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  Container(
                    width: (screenSize.width / 4),
                    height: 320,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  Container _buildSlideImage(Size screenSize) {
    var scWidth = MediaQuery.of(context).size.width;
    if (scWidth < 760) {
      return Container(
        width: double.infinity,
        height: 200,
        color: Colors.white,
        child: Carousel(
          boxFit: BoxFit.fitWidth,
          autoplay: false,
          animationCurve: Curves.fastOutSlowIn,
          animationDuration: Duration(milliseconds: 5000),
          dotSize: 10.0,
          dotIncreasedColor: Colors.grey,
          dotBgColor: Colors.transparent,
          dotPosition: DotPosition.bottomCenter,
          dotVerticalPadding: 5.0,
          showIndicator: true,
          images: [
            ExactAssetImage(
              'assets/images/6-02.png',
            ),
            ExactAssetImage('assets/images/6-02.png'),
            ExactAssetImage('assets/images/6-02.png'),
            ExactAssetImage('assets/images/6-02.png'),
          ],
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        height: 420,
        color: Colors.white,
        child: Carousel(
          boxFit: BoxFit.fitWidth,
          autoplay: false,
          animationCurve: Curves.fastOutSlowIn,
          animationDuration: Duration(milliseconds: 5000),
          dotSize: 10.0,
          dotIncreasedColor: Colors.grey,
          dotBgColor: Colors.transparent,
          dotPosition: DotPosition.bottomCenter,
          dotVerticalPadding: 5.0,
          showIndicator: true,
          images: [
            ExactAssetImage(
              'assets/images/6-02.png',
            ),
            ExactAssetImage('assets/images/6-02.png'),
            ExactAssetImage('assets/images/6-02.png'),
            ExactAssetImage('assets/images/6-02.png'),
          ],
        ),
      );
    }
  }

  Container _buildDefaultSearch(Size screenSize) {
    var scWidth = MediaQuery.of(context).size.width;
    if (scWidth < 760) {
      return Container(
        width: double.infinity,
        height: (screenSize.height * 0.055),
        padding: EdgeInsets.only(top: 5),
        color: Color.fromRGBO(253, 250, 254, 1.0),
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
      );
    } else {
      return Container(
        width: double.infinity,
        height: (screenSize.height * 0.060),
        padding: EdgeInsets.only(top: 5),
        color: Color.fromRGBO(253, 250, 254, 1.0),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 36, top: 12, right: 36, bottom: 0),
              child: Image.asset(
                'assets/images/logo-full.png',
              ),
            ),
            Container(
              width: (screenSize.width * 0.50),
              margin: EdgeInsets.only(right: 20),
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: (screenSize.width * 0.42),
                    height: 60,
                    decoration: BoxDecoration(border: Border.all(width: 1)),
                    child: TextField(
                      autofocus: false,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        hintText: 'ชื่อสินค้า/รหัสสินค้า/ประเภทสินค้า',
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.only(bottom: 0, left: 20, top: 10),
                      ),
                    ),
                  ),
                  Container(
                    width: (screenSize.width * 0.08),
                    height: 60,
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
                        size: 45,
                      ),
                      padding: EdgeInsets.only(bottom: 0.5),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: (screenSize.width * 0.055),
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(top: 10),
              child: Stack(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Colors.black,
                      size: 50,
                    ),
                    padding: EdgeInsets.only(bottom: 0.5),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(1),
                      decoration: new BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 28,
                        minHeight: 28,
                      ),
                      child: Text(
                        '1',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: (screenSize.width * 0.055),
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(top: 10),
              child: Stack(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.black,
                      size: 50,
                    ),
                    padding: EdgeInsets.only(bottom: 0.5),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(0),
                      decoration: new BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 28,
                        minHeight: 28,
                      ),
                      child: Text(
                        '1',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  Container _buildFullLogo() {
    var scWidth = MediaQuery.of(context).size.width;
    if (scWidth < 760) {
      return Container(
        margin: EdgeInsets.only(left: 36, top: 12, right: 36, bottom: 0),
        child: Image.asset(
          'assets/images/logo-full.png',
        ),
      );
    } else {
      return Container();
    }
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
          Container(
            width: double.infinity,
            height: 250,
            margin: EdgeInsets.only(top: 5),
            child: Column(
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
                        padding: EdgeInsets.only(top: 5, left: 20),
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
                          'กลุ่มที่ ' + (i + 1).toString() + '',
                          style: TextStyle(
                              color: Hexcolor(groupList[i].XVGrpColor2),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: Text(
                          groupList[i].XVGrpName_th,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        bottom: 5,
                        child: Text(
                          groupList[i].XVGrpName_en,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 4,
                        child: Image.network(
                          'http://apiinnovation.dyndns.org/alphadeal_backend_api/storage/app/' +
                              groupList[i].XVGrpBannerFile,
                          alignment: Alignment.topRight,
                          width: screenSize.width * .6,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 180,
                  child: ListView.builder(
                    itemCount: groupList[i].subgroup.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16)),
                        child: Stack(
                          children: <Widget>[
                            Image.network(
                                'http://apiinnovation.dyndns.org/alphadeal_backend_api/storage/app/' +
                                    groupList[i].XVGrpBoxFile),
                            Container(
                              padding: EdgeInsets.all(12),
                              alignment: Alignment.bottomCenter,
                              width: 180,
                              height: 180,
                              child: Image.network(
                                'http://apiinnovation.dyndns.org/alphadeal_backend_api/storage/app/' +
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
                                    fontSize: 12,
                                    color: Hexcolor(groupList[i].XVGrpColor5)),
                              ),
                            ),
                            Positioned(
                              top: 24,
                              left: 8,
                              child: Text(
                                groupList[i].subgroup[index].XVSubName_en,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Hexcolor(groupList[i].XVGrpColor5)),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
//                  child: GridView.builder(
//                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                      crossAxisCount: 4,
//                    ),
//                    itemCount: groupList[i].subgroup.length,
//                    itemBuilder: (context, index) {
//                      return Container(
//                        margin: EdgeInsets.all(4),
//                        decoration: BoxDecoration(
//                            borderRadius: BorderRadius.circular(16)),
//                        child: Stack(
//                          children: <Widget>[
//                            Image.network(
//                                'http://apiinnovation.dyndns.org/alphadeal_backend_api/storage/app/' +
//                                    groupList[i].XVGrpBoxFile),
//                            Positioned(
//                              top: 8,
//                              left: 8,
//                              child: Text(
//                                groupList[i].subgroup[index].XVSubName_th,
//                                style: TextStyle(
//                                    fontSize: 10,
//                                    color: Hexcolor(groupList[i].XVGrpColor5)),
//                              ),
//                            ),
//                            Positioned(
//                              top: 18,
//                              left: 8,
//                              child: Text(
//                                groupList[i].subgroup[index].XVSubName_en,
//                                style: TextStyle(
//                                    fontSize: 10,
//                                    color: Hexcolor(groupList[i].XVGrpColor5)),
//                              ),
//                            ),
//                            Align(
//                              heightFactor: 20,
//                              child: Column(
//                                children: <Widget>[
//                                  Container(
//                                    height: 40,
//                                    alignment: Alignment.bottomCenter,
//                                  ),
//                                  Container(
//                                    width: 100,
//                                    height: 75,
//                                    alignment: Alignment.bottomCenter,
//                                    child: Image.network(
//                                      'http://apiinnovation.dyndns.org/alphadeal_backend_api/storage/app/' +
//                                          groupList[i]
//                                              .subgroup[index]
//                                              .XVImgFile,
//                                      fit: BoxFit.cover,
//                                    ),
//                                  ),
//                                ],
//                              ),
//                            ),
//                          ],
//                        ),
//                      );
//                    },
//                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class PhotosList extends StatelessWidget {
  final List<Photo> photos;

  PhotosList({Key key, this.photos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: 7,
      itemBuilder: (context, index) {
        return Image.network(
          photos[index].thumbnailUrl,
          width: 200,
          height: 200,
        );
      },
    );
  }
}

class SubGroupList extends StatelessWidget {
  final List<SubGroup> subList;

  SubGroupList({Key key, this.subList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: 7,
      itemBuilder: (context, index) {
        return Image.network(
          subList[index].XVImgFile,
          width: 200,
          height: 200,
        );
      },
    );
  }
}
