import 'dart:convert';
import 'package:alphadealdemo/src/bloc/database_bloc.dart';
import 'package:alphadealdemo/src/locale/app_localization.dart';
import 'package:alphadealdemo/src/models/cart.dart';
import 'package:alphadealdemo/src/pages/about_page.dart';
import 'package:alphadealdemo/src/pages/cart_page.dart';
import 'package:alphadealdemo/src/pages/contact_page.dart';
import 'package:alphadealdemo/src/pages/donut_page.dart';
import 'package:alphadealdemo/src/pages/product_brand.dart';
import 'package:alphadealdemo/src/pages/product_detail_page.dart';
import 'package:alphadealdemo/src/pages/search_page.dart';
import 'package:alphadealdemo/src/pages/subgroup_page.dart';
import 'package:alphadealdemo/src/pages/profile_page.dart';
import 'package:alphadealdemo/src/pages/wishlist_page.dart';
import 'package:alphadealdemo/src/services/databases.dart';
import 'package:intl/intl.dart';
import 'package:alphadealdemo/src/models/home.dart';
import 'package:alphadealdemo/src/utils/constant.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:http/http.dart' as http;

import 'model_detail_page.dart';

var globalScreen;
final formatCurrency = new NumberFormat.currency(locale: "th", symbol: "");
int intitialDonut = 0;
int pageNavigate = 0;
var globalCuscode;

Future<bool> checkIsLogin() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getBool("isLogin") ?? false;
}

Future<String> getClientId() async {
  String a = await DBProvider.db.getClientId();
  return a ?? false;
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
  //print(url);
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

class HomeApp extends StatefulWidget {
  final int intitialNavigate;
  final int intitialHomeDonut;

  HomeApp(this.intitialNavigate, this.intitialHomeDonut);

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

  // ignore: missing_return
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
    setState(() {
      (widget.intitialNavigate != null)
          ? _selectedPage = widget.intitialNavigate
          : _selectedPage = _selectedPage;
      pageNavigate = _selectedPage;
      intitialDonut = widget.intitialHomeDonut;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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

class _HomePageState extends State<HomePage> {
  ScrollController _scrollController;
  final bloc = CartBloc();
  final userBloc = ClientsBloc();

  void goReParent() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    bloc.dispose();
    userBloc.dispose();
    super.dispose();
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

  StickyHeader _buildStickyHeader(Size screenSize) {
    var scWidth = MediaQuery.of(context).size.width;

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
            height: 50,
            color: Colors.transparent,
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(top: 20, left: 1),
            child: Container(
              width: screenSize.width / 3,
              height: 45,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(60, 8, 87, 1),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20))),
              alignment: Alignment.center,
              child: Text(
                AppLocalizations.of(context).translate('home_label_categories'),
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
          _buildBottomBanner1(),
          _buildBottomBanner2(),
          Padding(padding: EdgeInsets.only(bottom: 55)),
        ],
      ),
    );
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

  Padding _buildBottomBanner2() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 32, left: 32, right: 32),
      child: Image.asset(
        'assets/images/banner2_image.png',
      ),
    );
  }

  Padding _buildBottomBanner1() {
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 12, left: 32, right: 32),
      child: Image.asset(
        'assets/images/banner1_image.png',
      ),
    );
  }

  FutureBuilder<List<ProductGroup>> _buildProductGroupFuture() {
    return FutureBuilder<List<ProductGroup>>(
      future: fetchProductGroup(),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);

        return snapshot.hasData
            ? GroupList(
                groupList: snapshot.data,
                goToDonut: widget.goToDonut,
              )
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  FutureBuilder<List<ProductGroup>> _buildGroupIconFuture() {
    var scWidth = MediaQuery.of(context).size.width;

    return FutureBuilder<List<ProductGroup>>(
      future: fetchProductGroup(),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        if (scWidth < 600) {
          return snapshot.hasData
              ? GroupIconList(
                  groupList: snapshot.data,
                  goToDonut: widget.goToDonut,
                )
              : Center(child: CircularProgressIndicator());
        } else {
          return SizedBox();
        }
      },
    );
  }

  Container _buildBestSeller(Size screenSize) {
    var scWidth = MediaQuery.of(context).size.width;
    if (scWidth < 600) {
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
        height: 240,
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
                goReParent: goReParent,
              )
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  Container _buildNewProduct(Size screenSize) {
    var scWidth = MediaQuery.of(context).size.width;
    if (scWidth < 600) {
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
        height: 240,
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
                goReParent: goReParent,
              )
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  Container _buildSlideImage(Size screenSize) {
    var scWidth = MediaQuery.of(context).size.width;
    if (scWidth < 600) {
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
                : SizedBox();
          },
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        height: screenSize.height * 0.3,
        color: Colors.white,
        child: FutureBuilder<List<Slide>>(
          future: fetchSlide(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? SlideCarouselList(
                    slideList: snapshot.data,
                  )
                : SizedBox();
          },
        ),
      );
    }
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
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchPage(),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: (screenSize.width * 0.55),
                      height: 40,
                      decoration: BoxDecoration(border: Border.all(width: 1)),
                      child: TextField(
                        enabled: false,
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
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchPage(),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: (screenSize.width * 0.42),
                      height: 40,
                      decoration: BoxDecoration(border: Border.all(width: 1)),
                      child: TextField(
                        enabled: false,
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

  Container _buildFullLogo() {
    var scWidth = MediaQuery.of(context).size.width;
    if (scWidth < 600) {
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
  final Function goReParent;

  BestSellerList({Key key, this.bestSellerList, this.goReParent})
      : super(key: key);

  void goRefresh() {
    goReParent();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //print(bestSellerList);
    return ListView.builder(
      itemCount: bestSellerList.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Container(
          width: (screenSize.width < 600)
              ? (screenSize.width / 3.5)
              : (screenSize.width / 5.55),
          margin: EdgeInsets.only(
            right: (screenSize.width * 0.0125),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: GestureDetector(
            onTap: () {
              var isModel = bestSellerList[index].XBPdtIsModel;
              var pdtCode = bestSellerList[index].XVPdtCode;
              var mdlCode = bestSellerList[index].XVModCode;
              (isModel == '0')
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailPage(pdtCode: pdtCode),
                      ),
                    ).then((value) => goRefresh())
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ModelDetailPage(mdlCode: mdlCode),
                      ),
                    ).then((value) => goRefresh());
            },
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
                  child: (bestSellerList[index].XVImgFile != null)
                      ? Image.network((Constant.MAIN_URL_ASSETS +
                          bestSellerList[index].XVImgFile))
                      : Image.asset('assets/images/not-found.png'),
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
          ),
        );
      },
    );
  }
}

// ignore: must_be_immutable
class NewProductList extends StatelessWidget {
  final List<NewProduct> newProductList;
  final Function goReParent;

  NewProductList({Key key, this.newProductList, this.goReParent})
      : super(key: key);

  void goRefresh() {
    goReParent();
  }

  Size screenSize = globalScreen;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
      itemCount: newProductList.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Container(
          width: (screenSize.width < 600)
              ? (screenSize.width / 3.5)
              : (screenSize.width / 5.55),
          margin: EdgeInsets.only(
            right: (screenSize.width * 0.0125),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: GestureDetector(
            onTap: () {
              var isModel = newProductList[index].XBPdtIsModel;
              var pdtCode = newProductList[index].XVPdtCode;
              var mdlCode = newProductList[index].XVModCode;
              (isModel == '0')
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailPage(pdtCode: pdtCode),
                      ),
                    ).then((value) => goRefresh())
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ModelDetailPage(mdlCode: mdlCode),
                      ),
                    ).then((value) => goRefresh());
            },
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
                  child: (newProductList[index].XVImgFile != null)
                      ? Image(
                          width: 75,
                          height: 75,
                          image: NetworkImage(Constant.MAIN_URL_ASSETS +
                              newProductList[index].XVImgFile))
                      : Image.asset('assets/images/not-found.png'),
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
class GroupList extends StatefulWidget {
  final List<ProductGroup> groupList;
  final List<SubGroup> subList;
  final Function goToDonut;

  GroupList({Key key, this.groupList, this.subList, this.goToDonut})
      : super(key: key);

  @override
  _GroupListState createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  //Size screenSize = globalScreen;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    int row = widget.groupList.length;
    var screenSize = MediaQuery.of(context).size;
    var scWidth = screenSize.width;
    if (scWidth < 600) {
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
                        Hexcolor(widget.groupList[i].XVGrpColor1),
                        Hexcolor(widget.groupList[i].XVGrpColor2)
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
                              Hexcolor(widget.groupList[i].XVGrpColor3),
                              Color(int.parse(
                                      widget.groupList[i].XVGrpColor3
                                          .substring(1, 7),
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
                            color: Hexcolor(widget.groupList[i].XVGrpColor2),
                            fontWeight: FontWeight.bold,
                            fontSize: (screenSize.width / 100) * 3.75,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: (screenSize.width / 100) * 5,
                        left: (screenSize.width / 100) * 4,
                        child: Text(
                          widget.groupList[i].XVGrpName_th,
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
                          widget.groupList[i].XVGrpName_en,
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
                          Constant.MAIN_URL_ASSETS +
                              widget.groupList[i].XVGrpBannerFile,
                          alignment: Alignment.topRight,
                          width: screenSize.width * .6,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: ((widget.groupList[i].subgroup.length / 3).ceil() *
                      (screenSize.width / 3)),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    physics: new NeverScrollableScrollPhysics(),
                    itemCount: widget.groupList[i].subgroup.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          var subcode =
                              widget.groupList[i].subgroup[index].XVSubCode;
                          var grpcode = widget.groupList[i].XVGrpCode;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SubGroupPage(
                                subcode: subcode,
                                grpcode: grpcode,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.all(4),
                          child: Stack(
                            children: <Widget>[
                              Image.network(Constant.MAIN_URL_ASSETS +
                                  widget.groupList[i].XVGrpBoxFile),
                              Container(
                                padding: EdgeInsets.all(12),
                                alignment: Alignment.bottomCenter,
                                child: Image.network(
                                  Constant.MAIN_URL_ASSETS +
                                      widget.groupList[i].subgroup[index]
                                          .XVImgFile,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Text(
                                  widget.groupList[i].subgroup[index]
                                      .XVSubName_th,
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Hexcolor(
                                          widget.groupList[i].XVGrpColor5)),
                                ),
                              ),
                              Positioned(
                                top: 24,
                                left: 8,
                                child: Text(
                                  widget.groupList[i].subgroup[index]
                                      .XVSubName_en,
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Hexcolor(
                                          widget.groupList[i].XVGrpColor5)),
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
    } else {
      return Column(
        children: <Widget>[
          for (int i = 0; i < row; i++)
            Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Hexcolor(widget.groupList[i].XVGrpColor1),
                        Hexcolor(widget.groupList[i].XVGrpColor2)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: screenSize.width / 3,
                        height: 40,
                        padding: EdgeInsets.only(
                            top: (screenSize.width / 100),
                            left: (screenSize.width / 100) * 2),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Hexcolor(widget.groupList[i].XVGrpColor3),
                              Color(int.parse(
                                      widget.groupList[i].XVGrpColor3
                                          .substring(1, 7),
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
                            color: Hexcolor(widget.groupList[i].XVGrpColor2),
                            fontWeight: FontWeight.bold,
                            fontSize: (screenSize.width / 100) * 3.75,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: (screenSize.width / 100) * 6,
                        left: (screenSize.width / 100) * 2,
                        child: Text(
                          widget.groupList[i].XVGrpName_th,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: (screenSize.width / 100) * 2.75,
                          ),
                        ),
                      ),
                      Positioned(
                        left: (screenSize.width / 100) * 2,
                        bottom: (screenSize.width / 100) * 2,
                        child: Text(
                          widget.groupList[i].XVGrpName_en,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: (screenSize.width / 100) * 2.75,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: (screenSize.width / 100) * 2,
                        child: Image.network(
                          Constant.MAIN_URL_ASSETS +
                              widget.groupList[i].XVGrpBannerFile,
                          alignment: Alignment.topRight,
                          width: screenSize.width * .6,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: ((widget.groupList[i].subgroup.length / 4).ceil() *
                      (screenSize.width / 4)),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                    ),
                    physics: new NeverScrollableScrollPhysics(),
                    itemCount: widget.groupList[i].subgroup.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          var subcode =
                              widget.groupList[i].subgroup[index].XVSubCode;
                          var grpcode = widget.groupList[i].XVGrpCode;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SubGroupPage(
                                subcode: subcode,
                                grpcode: grpcode,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.all(4),
                          child: Stack(
                            children: <Widget>[
                              Image.network(Constant.MAIN_URL_ASSETS +
                                  widget.groupList[i].XVGrpBoxFile),
                              Container(
                                padding: EdgeInsets.all(12),
                                alignment: Alignment.bottomCenter,
                                child: Image.network(
                                  Constant.MAIN_URL_ASSETS +
                                      widget.groupList[i].subgroup[index]
                                          .XVImgFile,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Text(
                                  widget.groupList[i].subgroup[index]
                                      .XVSubName_th,
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Hexcolor(
                                          widget.groupList[i].XVGrpColor5)),
                                ),
                              ),
                              Positioned(
                                top: 24,
                                left: 8,
                                child: Text(
                                  widget.groupList[i].subgroup[index]
                                      .XVSubName_en,
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Hexcolor(
                                          widget.groupList[i].XVGrpColor5)),
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
              var bndcode = brandList[index].XVBndCode;
              // print('you pressed : $bndcode ');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductBrandPage(
                    bndcode: bndcode,
                  ),
                ),
              );
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
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(2),
                child: Image.network(
                  Constant.MAIN_URL_ASSETS + brandList[index].XVImgFile,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
