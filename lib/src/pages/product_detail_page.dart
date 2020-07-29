import 'package:alphadealdemo/src/bloc/database_bloc.dart';
import 'package:alphadealdemo/src/locale/app_localization.dart';
import 'package:alphadealdemo/src/models/cart.dart';
import 'package:alphadealdemo/src/models/home.dart';
import 'package:alphadealdemo/src/models/product.dart';
import 'package:alphadealdemo/src/pages/cart_page.dart';
import 'package:alphadealdemo/src/pages/wishlist_page.dart';
import 'package:alphadealdemo/src/services/databases.dart';
import 'package:alphadealdemo/src/utils/constant.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';

var globalScreen;
var qty = 1;
var imgIndex = 0;
var imgAll;
var isWishes = false;
var globalCusCode;
int globalWishlist = 0;

Future<WishlistAction> createPost(String url, {Map body}) async {
  return http.post(url, body: body).then((http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }

    return WishlistAction.fromJson(json.decode(response.body));
  });
}

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
Future<int> fetchWishlistCount(String cuscode, String pdtCode) async {
  final url =
      Constant.MAIN_URL_API + 'wishlist_app/?app=pdts&XVConCode=' + cuscode;
  final response = await http.get(url);
  //print(url);
  return parseWishListCount(response.body, pdtCode);
}

int parseWishListCount(String responseBody, String pdtCode) {
  isWishes = false;
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  List<CartQuery> a =
      parsed.map<CartQuery>((json) => CartQuery.fromJson(json)).toList();
  for (var row in a) {
    if (row.XVPdtCode == pdtCode) {
      isWishes = true;
    }
    //print(row.XVPdtCode + ' / ' + pdtCode);
  }
  return a.length;
}

// fetch Group Icon data
Future<ProductDetail> fetchProductDetail(String pdtCode) async {
  final url = Constant.URL_FRONT + 'product_detail/$pdtCode?app=pdt';
  //print(url);
  final response = await http.get(url);
  return parseProductDetail(response.body);
}

ProductDetail parseProductDetail(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return ProductDetail.fromJson(parsed);
}

// fetch Group Icon data
Future<List<ProductImage>> fetchProductImage(String pdtCode) async {
  final url = Constant.URL_FRONT + 'product_detail/$pdtCode?app=img';
  //print(url);
  final response = await http.get(url);
  return parseProductImage(response.body);
}

List<ProductImage> parseProductImage(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  //imgAll = parsed.length;
  return parsed
      .map<ProductImage>((json) => ProductImage.fromJson(json))
      .toList();
}

Future<int> getProductImageCount(String pdtCode) async {
  final url = Constant.URL_FRONT + 'product_detail/$pdtCode?app=img';
  final response = await http.get(url);
  return parseProductImageCount(response.body);
}

int parseProductImageCount(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.length;
}

class ProductDetailPage extends StatefulWidget {
  final String pdtCode;

  const ProductDetailPage({Key key, this.pdtCode}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  void goRefresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
                          future: fetchProductDetail(widget.pdtCode),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) print(snapshot.error);
                            //print(snapshot.data);
                            return snapshot.hasData
                                ? ProductDetailLayout(
                                    productDetaiList: snapshot.data,
                                    goRefresh: goRefresh,
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
      future: fetchWishlistCount(cuscode, widget.pdtCode),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if ((snapshot.data != null || snapshot.hasError == false) &&
              snapshot.data != 0) {
            globalWishlist = snapshot.data;
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
                  globalWishlist.toString(),
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

class ProductImageCarousel extends StatefulWidget {
  final List<ProductImage> productImageList;
  var indd = 1;

  ProductImageCarousel({Key key, this.productImageList}) : super(key: key);

  @override
  _ProductImageCarouselState createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var row = widget.productImageList.length;
    // TODO: implement build
    return (widget.productImageList[0].XVBarImgFile != null)
        ? Stack(
            children: <Widget>[
              Container(
                width: screenSize.width,
                height: screenSize.width,
                child: PhotoViewGallery.builder(
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: (BuildContext context, int index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider: NetworkImage(Constant.MAIN_URL_ASSETS +
                          widget.productImageList[index].XVBarImgFile),
                      initialScale: PhotoViewComputedScale.contained * 1,
                    );
                  },
                  itemCount: row,
                  loadingBuilder: (context, event) => Center(
                    child: Container(
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator(
                        value: event == null
                            ? 0
                            : event.cumulativeBytesLoaded /
                                event.expectedTotalBytes,
                      ),
                    ),
                  ),
                  onPageChanged: (index) {
                    setState(() {
                      widget.indd = index + 1;
                    });
                  },
                  backgroundDecoration:
                      BoxDecoration(color: Colors.transparent),
//            backgroundDecoration: widget.backgroundDecoration,
//            pageController: widget.pageController,
//            onPageChanged: onPageChanged,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  child: Text(
                    widget.indd.toString() + ' / ' + row.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: (screenSize.width / 100) * 3,
                        color: Colors.black),
                  ),
                ),
              ),
            ],
          )
        : Image.asset('assets/images/logo-mini.png');
  }
}

class ProductDetailLayout extends StatefulWidget {
  final ProductDetail productDetaiList;
  final Function goRefresh;

  ProductDetailLayout({Key key, this.productDetaiList, this.goRefresh})
      : super(key: key);

  void goRefreshParent() {
    goRefresh();
  }

  @override
  _ProductDetailLayoutState createState() => _ProductDetailLayoutState();
}

class _ProductDetailLayoutState extends State<ProductDetailLayout> {
  final bloc = CartBloc();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    // TODO: implement build
    return Column(
      children: <Widget>[
//        Container(
//          width: double.infinity,
//          height: (screenSize.height / 100) * 50,
//          padding: EdgeInsets.all(24),
//          child: Image.network(
//            Constant.MAIN_URL_ASSETS + widget.productDetaiList.pdtImg,
//            fit: BoxFit.scaleDown,
//          ),
//        ),
        Stack(
          children: <Widget>[
            Positioned(
              left: 12,
              top: 12,
              child: Container(
                width: 50,
                height: 50,
                child: Image.network(
                    Constant.MAIN_URL_ASSETS + widget.productDetaiList.bndImg),
                //color: Colors.red,
              ),
            ),
            Container(
              width: double.infinity,
              height: (screenSize.height / 100) * 50,
              padding: EdgeInsets.all(12),
              child: FutureBuilder<List<ProductImage>>(
                future: fetchProductImage(widget.productDetaiList.XVPdtCode),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? ProductImageCarousel(
                          productImageList: snapshot.data,
                        )
                      : Image.asset('assets/images/not-found.png');
                },
              ),
            ),
          ],
        ),
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
                        height: 40,
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54, width: 1),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            bottomLeft: Radius.circular(4),
                          ),
                        ),
                        child: Text(
                          '-',
                          style:
                              TextStyle(fontSize: (screenSize.width / 100) * 6),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialogInputQty();
                      },
                      child: Container(
                        height: 40,
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 4),
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
                          style:
                              TextStyle(fontSize: (screenSize.width / 100) * 5),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        qty++;
                        setState(() {});
                      },
                      child: Container(
                        height: 40,
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54, width: 1),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(4),
                            bottomRight: Radius.circular(4),
                          ),
                        ),
                        child: Text(
                          '+',
                          style:
                              TextStyle(fontSize: (screenSize.width / 100) * 6),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  '฿ ' + widget.productDetaiList.XFPdtStdPrice,
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
              Container(
                width: 30,
                height: 30,
                child: IconButton(
                  onPressed: () {
                    launch(Uri.encodeFull(Constant.MAIN_URL_ASSETS +
                        widget.productDetaiList.XVPdtWPdf));
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
                      fontSize: (screenSize.width / 100) * 3.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.productDetaiList.XNPdtWShipDay,
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
              Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      var isLogin = await checkIsLogin();
                      if (isLogin == true) {
                        var pdtCode = widget.productDetaiList.XVPdtCode;
                        var pdtPrice = widget.productDetaiList.XFPdtStdPrice;
                        Cart n = new Cart(
                            XVBarCode: pdtCode,
                            XVBarName: '',
                            XVBarNameOth: '',
                            XFBarRetPri1: pdtPrice,
                            XIQty: qty);
                        bloc.add(n);

                        final snackBar = SnackBar(
                          content: Text('เพิ่มสินค้าไปยังรถเข็นแล้ว'),
                          action: SnackBarAction(
                            label: "",
                            onPressed: () {
                              // Some code to undo the change.
                            },
                          ),
                        );

                        Scaffold.of(context).showSnackBar(snackBar);

                        setState(() {
                          qty = 1;
                          widget.goRefreshParent();
                        });
                      } else {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/profile', (Route<dynamic> route) => false);
                      }
                    },
                    child: Container(
                      height: 40,
                      padding: EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                          color: Colors.blue),
                      child: Row(
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
                  GestureDetector(
                    onTap: () async {
                      var isLogin = await checkIsLogin();
                      if (isLogin == true) {
                        var cusCode = await getClientId();
                        var pdtCode = widget.productDetaiList.XVPdtCode;
                        var app = 'true';
                        WishlistAction newPost = new WishlistAction(
                            XVConCode: cusCode, pdtcode: pdtCode, app: app);

                        WishlistAction p = await createPost(
                            Constant.MAIN_URL_API + "addWishlist",
                            body: newPost.toMap());

                        if (p.status == 'success') {
                          if (p.type == 'remove') {
                            final snackBar = SnackBar(
                              content: Text('ลบออกจากสินค้าที่สนใจแล้ว'),
                              action: SnackBarAction(
                                label: "",
                                onPressed: () {
                                  // Some code to undo the change.
                                },
                              ),
                            );

                            Scaffold.of(context).showSnackBar(snackBar);

                            setState(() {
                              widget.goRefreshParent();
                            });
                          }
                          if (p.type == 'add') {
                            final snackBar = SnackBar(
                              content: Text('เพิ่มไปยังสินค้าที่สนใจแล้ว'),
                              action: SnackBarAction(
                                label: "",
                                onPressed: () {
                                  // Some code to undo the change.
                                },
                              ),
                            );

                            Scaffold.of(context).showSnackBar(snackBar);

                            setState(() {
                              widget.goRefreshParent();
                            });
                          }
                        } else {
                          //
                        }
                      } else {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/profile', (Route<dynamic> route) => false);
                      }
                    },
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                          color: Colors.blue),
                      child: IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: (isWishes) ? Colors.red : Colors.white,
                          size: (screenSize.width / 100) * 5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.productDetaiList.XVPdtName_th,
              style: TextStyle(
                  fontSize: (screenSize.width / 100) * 6,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'รหัสสินค้า : ' +
                  widget.productDetaiList.XVPdtCode +
                  ' | ' +
                  'บรรจุ ' +
                  widget.productDetaiList.XFPdtFactor +
                  ' ' +
                  widget.productDetaiList.XVUntName_en,
              style: TextStyle(
                  fontSize: (screenSize.width / 100) * 3.5,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.fiber_manual_record,
                  size: 10,
                  color: Colors.black,
                ),
                Text(
                  ' Model : ' + widget.productDetaiList.XVMdlCodeSpl,
                  style: TextStyle(
                      fontSize: (screenSize.width / 100) * 4,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Html(
                data: widget.productDetaiList.XVPdtWDesc_th,
              )),
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
                  var a = int.parse(qtyText.text);
                  qty = a;
                  setState(() {});
                  //print(qty);

                  Navigator.pop(context);
                  return;
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

class WishlistAction {
  final String XVConCode;
  final String pdtcode;
  final String app;
  final String status;
  final String type;

  WishlistAction(
      {this.XVConCode, this.pdtcode, this.status, this.type, this.app});

  factory WishlistAction.fromJson(Map<String, dynamic> json) {
    return WishlistAction(
      XVConCode: json['XVConCode'],
      pdtcode: json['pdtcode'],
      app: json['app'],
      status: json['status'],
      type: json['type'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["XVConCode"] = XVConCode;
    map["pdtcode"] = pdtcode;
    map["app"] = app;

    return map;
  }
}
