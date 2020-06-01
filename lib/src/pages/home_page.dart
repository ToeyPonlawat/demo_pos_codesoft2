import 'dart:convert';
import 'package:alphadealdemo/src/locale/app_localization.dart';
import 'package:alphadealdemo/src/myapp.dart';
import 'package:alphadealdemo/src/pages/about_page.dart';
import 'package:alphadealdemo/src/pages/contact_page.dart';
import 'package:alphadealdemo/src/pages/donut_page.dart';
import 'package:alphadealdemo/src/pages/subgroup_page.dart';
import 'package:alphadealdemo/src/pages/me_page.dart';
import 'package:alphadealdemo/src/services/app_language.dart';
import 'package:intl/intl.dart';
import 'package:alphadealdemo/src/models/home.dart';
import 'package:alphadealdemo/src/utils/constant.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:http/http.dart' as http;

var globalScreen;
final formatCurrency = new NumberFormat.currency(locale: "th", symbol: "");
int intitialDonut = 0;

class HomeApp extends StatefulWidget {
  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  int _selectedPage = 0;

  void goToDonut() {
    setState(() {
      _selectedPage = 1;
    });
  }

  Widget _body() {
    switch (_selectedPage) {
      case 0:
        return HomePage(goToDonut);
        break;
      case 1:
        return DonutPage(intitialDonut);
        break;
      case 2:
        return AboutPage();
        break;
      case 3:
        return ContactPage();
        break;
      case 4:
        return MePage();
        break;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    return Scaffold(
      body: _body(),
      bottomNavigationBar: SafeArea(
        top: false,
        child: BottomNavigationBar(
          iconSize: 20,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: TextStyle(fontSize: 10),
          selectedIconTheme: IconThemeData(size: 24),
          backgroundColor: Constant.MAIN_BASE_COLOR,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedPage,
          onTap: (int index) {
            setState(() {
              intitialDonut = 0;
              _selectedPage = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              title: Text(
                AppLocalizations.of(context).translate('general_label_home'),
                style: TextStyle(color: Colors.white),
              ),
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.redeem,
                  color: Colors.white,
                ),
                title: Text(
                  AppLocalizations.of(context)
                      .translate('general_label_product'),
                  style: TextStyle(color: Colors.white),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.business,
                  color: Colors.white,
                ),
                title: Text(
                  AppLocalizations.of(context).translate('general_label_about'),
                  style: TextStyle(color: Colors.white),
                )),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_call,
                color: Colors.white,
              ),
              title: Text(
                AppLocalizations.of(context).translate('general_label_contact'),
                style: TextStyle(color: Colors.white),
              ),
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                title: Text(
                  AppLocalizations.of(context).translate('general_label_me'),
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage(this.goToDonut);
  final Function goToDonut;

  void goToDonutParent() {
    goToDonut();
  }

  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

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

// fetch Slide data
Future<List<Slide>> fetchSlide() async {
  final url = Constant.MAIN_URL_SERVICES + 'slides';
  final response = await http.get(url);
  return parseSlide(response.body);
}

List<Slide> parseSlide(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Slide>((json) => Slide.fromJson(json)).toList();
}

// fetch New Product data
Future<List<NewProduct>> fetchNewProduct() async {
  final url = Constant.MAIN_URL_SERVICES + 'pdt_new';
  final response = await http.get(url);
  return parseNewProduct(response.body);
}

List<NewProduct> parseNewProduct(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<NewProduct>((json) => NewProduct.fromJson(json)).toList();
}

// fetch Best Seller data
Future<List<BestSeller>> fetchBestSeller() async {
  final url = Constant.MAIN_URL_SERVICES + 'pdt_best';
  final response = await http.get(url);
  return parseBestSeller(response.body);
}

List<BestSeller> parseBestSeller(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<BestSeller>((json) => BestSeller.fromJson(json)).toList();
}

// fetch Brand data
Future<List<Brand>> fetchBrand() async {
  final url = Constant.MAIN_URL_SERVICES + 'pdt_brand';
  final response = await http.get(url);
  return parseBrand(response.body);
}

List<Brand> parseBrand(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Brand>((json) => Brand.fromJson(json)).toList();
}

class _HomePageState extends State<HomePage> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
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
              color: Color.fromRGBO(254, 254, 254, 1),
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
//      bottomNavigationBar: _buildBottomNavigate(screenSize),
    );
  }

  SafeArea _buildBottomNavigate(Size screenSize) {
    var scWidth = MediaQuery.of(context).size.width;
    var scRatio = screenSize.height / screenSize.width;
    if (scWidth < 760) {
      return SafeArea(
          top: false,
          child: Container(
            width: double.infinity,
            height: 100 / scRatio,
            padding: EdgeInsets.only(left: 20, right: 20),
            color: Constant.MAIN_BASE_COLOR,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    _scrollController.animateTo(
                      0.0,
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 300),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: (screenSize.height * 0.0075)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.home,
                          color: Colors.white,
                          size: 22,
                        ),
                        Text(
                          'หน้าหลัก',
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.only(top: (screenSize.height * 0.0075)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.redeem,
                          color: Colors.white,
                          size: 22,
                        ),
                        Text(
                          'สินค้า',
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.only(top: (screenSize.height * 0.0075)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.business,
                          color: Colors.white,
                          size: 22,
                        ),
                        Text(
                          'เกี่ยวกับเรา',
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.only(top: (screenSize.height * 0.0075)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.contact_phone,
                          color: Colors.white,
                          size: 22,
                        ),
                        Text(
                          'ติอต่อเรา',
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MePage()),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: (screenSize.height * 0.0075)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 22,
                        ),
                        Text(
                          'ฉัน',
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ],
                    ),
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildDefaultSearch(screenSize),
              _buildGroupIconFuture(),
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
                  AppLocalizations.of(context)
                      .translate('home_label_categories'),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: (scWidth / 100) * 4,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              height: 3,
              width: double.infinity,
              color: Color.fromRGBO(60, 8, 87, 1),
            ),
            _buildProductGroupFuture(),
            SizedBox(
              height: screenSize.height * 0.025,
            ),
            _buildBrandFuture(),
            _buildBottomBanner(),
            Padding(padding: EdgeInsets.only(bottom: 55)),
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

  FutureBuilder<List<Brand>> _buildBrandFuture() {
    return FutureBuilder<List<Brand>>(
      future: fetchBrand(),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        return snapshot.hasData
            ? BrandList(
                brandList: snapshot.data,
              )
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  Padding _buildBottomBanner() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 32, left: 32, right: 32),
      child: Image.asset(
        'assets/images/banner2_image.png',
      ),
    );
  }

  FutureBuilder<List<ProductGroup>> _buildProductGroupFuture() {
    return FutureBuilder<List<ProductGroup>>(
      future: fetchProductGroup(),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);

        return snapshot.hasData
            ? GroupList(groupList: snapshot.data)
            : Center(child: CircularProgressIndicator());
      },
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
                goToDonut: widget.goToDonut,
              )
            : Center(child: CircularProgressIndicator());
      },
    );
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
              onTap: () {},
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
                        fontSize: (scWidth / 100) * 5,
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
                        fontSize: (scWidth / 100) * 5,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
                width: double.infinity,
                height: 150,
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(left: 4, right: 4, top: 20),
                child: _buildBestSellerFuture()),
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

  FutureBuilder<List<BestSeller>> _buildBestSellerFuture() {
    return FutureBuilder<List<BestSeller>>(
      future: fetchBestSeller(),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);

        return snapshot.hasData
            ? BestSellerList(
                bestSellerList: snapshot.data,
              )
            : Center(child: CircularProgressIndicator());
      },
    );
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
                        fontSize: (scWidth / 100) * 5,
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
                        fontSize: (scWidth / 100) * 5,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 150,
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(left: 4, right: 4, top: 20),
              child: _buildNewProductFuture(),
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

  FutureBuilder<List<NewProduct>> _buildNewProductFuture() {
    return FutureBuilder<List<NewProduct>>(
      future: fetchNewProduct(),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);

        return snapshot.hasData
            ? NewProductList(
                newProductList: snapshot.data,
              )
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  Container _buildSlideImage(Size screenSize) {
    var scWidth = MediaQuery.of(context).size.width;
    if (scWidth < 760) {
      return Container(
          width: double.infinity,
          height: screenSize.height * 0.225,
          color: Colors.white,
          child: FutureBuilder<List<Slide>>(
            future: fetchSlide(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);

              return snapshot.hasData
                  ? SlideCarouselList(
                      slideList: snapshot.data,
                    )
                  : Center(child: CircularProgressIndicator());
            },
          ));
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
        width: double.infinity,
        padding: EdgeInsets.only(left: 36, top: 12, right: 36, bottom: 0),
        color: Color.fromRGBO(253, 250, 254, 1.0),
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
class BestSellerList extends StatelessWidget {
  Size screenSize = globalScreen;
  final List<BestSeller> bestSellerList;

  BestSellerList({Key key, this.bestSellerList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
      itemCount: bestSellerList.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Container(
          width: (screenSize.width / 3.5),
          margin: EdgeInsets.only(
            right: (screenSize.width * 0.0325),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 12, right: 12),
                padding: EdgeInsets.only(top: 12),
                width: double.infinity,
                height: 45,
                child: Text(
                  (AppLocalizations.of(context).locale.toString() == 'th')
                      ? bestSellerList[index].XVPdtName_th
                      : bestSellerList[index].XVPdtName_en,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                width: 75,
                height: 75,
                child: Image.network(
                  (Constant.MAIN_URL_ASSETS + bestSellerList[index].XVImgFile),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 12, right: 12),
                padding: EdgeInsets.only(bottom: 12),
                width: double.infinity,
                height: 30,
                child: Text(
                  formatCurrency.format(
                      double.parse(bestSellerList[index].XFPdtStdPrice)
                          .toDouble()),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

// ignore: must_be_immutable
class NewProductList extends StatelessWidget {
  Size screenSize = globalScreen;
  final List<NewProduct> newProductList;

  NewProductList({Key key, this.newProductList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
      itemCount: newProductList.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Container(
          width: (screenSize.width / 3.5),
          margin: EdgeInsets.only(
            right: (screenSize.width * 0.0325),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 12, right: 12),
                padding: EdgeInsets.only(top: 12),
                width: double.infinity,
                height: 45,
                child: Text(
                  (AppLocalizations.of(context).locale.toString() == 'th')
                      ? newProductList[index].XVPdtName_th
                      : newProductList[index].XVPdtName_en,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                width: 75,
                height: 75,
                child: Image.network(
                  (Constant.MAIN_URL_ASSETS + newProductList[index].XVImgFile),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 12, right: 12),
                padding: EdgeInsets.only(bottom: 12),
                width: double.infinity,
                height: 30,
                child: Text(
                  formatCurrency.format(
                      double.parse(newProductList[index].XFPdtStdPrice)
                          .toDouble()),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

// ignore: must_be_immutable
class SlideCarouselList extends StatelessWidget {
  Size screenSize = globalScreen;
  final List<Slide> slideList;

  SlideCarouselList({Key key, this.slideList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Carousel(
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
        for (int i = 0; i < slideList.length; i++)
          Image.network(
            Constant.MAIN_URL_ASSETS + slideList[i].XVBanFileName,
          ),
      ],
    );
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
  Size screenSize = globalScreen;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
      width: double.infinity,
      height:
          ((widget.groupList.length / 5.75).ceil() * (screenSize.width / 5.75)),
      margin: EdgeInsets.only(
          left: (screenSize.width * 0.025), right: (screenSize.width * 0.025)),
      padding: EdgeInsets.only(
          left: (screenSize.width * 0.025), right: (screenSize.width * 0.025)),
      child: ListView.builder(
        itemCount: widget.groupList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              intitialDonut = index;
              setState(() {
                widget.goToDonut();
              });
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
                    margin: EdgeInsets.only(top: (screenSize.height * 0.0125)),
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
class BrandList extends StatelessWidget {
  Size screenSize = globalScreen;
  final List<Brand> brandList;

  BrandList({Key key, this.brandList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: double.infinity,
      height: screenSize.height * 0.14,
      margin: EdgeInsets.only(left: 12, right: 12),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 1,
        ),
        itemCount: brandList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              var a = brandList[index].XVBndCode;
              print('you pressed : $a ');
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: const Offset(1.0, 1.0),
                      blurRadius: 4.0,
                      spreadRadius: 1.0,
                    ),
                  ]),
              margin: EdgeInsets.all(4),
              padding: EdgeInsets.all(2),
              child: Image.network(
                Constant.MAIN_URL_ASSETS + brandList[index].XVImgFile,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
