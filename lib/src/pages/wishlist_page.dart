import 'dart:convert';
import 'package:alphadealdemo/src/locale/app_localization.dart';
import 'package:alphadealdemo/src/models/cart.dart';
import 'package:alphadealdemo/src/models/category.dart';
import 'package:alphadealdemo/src/models/home.dart';
import 'package:alphadealdemo/src/pages/cart_page.dart';
import 'package:alphadealdemo/src/pages/home_page.dart';
import 'package:alphadealdemo/src/pages/model_detail_page.dart';
import 'package:alphadealdemo/src/pages/product_detail_page.dart';
import 'package:alphadealdemo/src/services/databases.dart';
import 'package:alphadealdemo/src/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:http/http.dart' as http;

var globalScreen;
var globalOrder;
String catName;
var bnd = [];

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

// fetch Product list in Category
Future<List<ProductList>> fetchProductList(
    String catcode, String orderBy, List brand) async {
  String url = Constant.MAIN_URL_API + 'wishlist_app';
  if (orderBy != null && orderBy.length > 0) {
    url += '?app=pdts&XVConCode=$catcode&selectOrderby=$orderBy';
  } else {
    url += '?app=pdts&XVConCode=$catcode';
  }

  if (brand != []) {
    for (int i = 0; i < brand.length; i++) {
      int j = i + 1;
      url += '&XVBndCodeArr[$j]=' + brand[i].toString();
    }
  }

  //print(url);

  final response = await http.get(url);
  return parseProductList(response.body);
}

List<ProductList> parseProductList(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<ProductList>((json) => ProductList.fromJson(json)).toList();
}

// fetch Product list in Category
Future<List<ProductBrandList>> fetchBrandList(String cuscode) async {
  String url =
      Constant.MAIN_URL_API + 'wishlist_app?app=brands&XVConCode=$cuscode';

  //print(url);
  final response = await http.get(url);
  return parseBrandList(response.body);
}

List<ProductBrandList> parseBrandList(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  //print(parsed);
  return parsed
      .map<ProductBrandList>((json) => ProductBrandList.fromJson(json))
      .toList();
}

// fetch Category Detail
Future<CategoryDetail> fetchCategory(String catcode) async {
  String url = Constant.PDT_LIST_URL_SERVICES + catcode;
  url += '/?app=res';

  final response = await http.get(url);
  return parseCategoryDetail(response.body);
}

CategoryDetail parseCategoryDetail(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return CategoryDetail.fromJson(parsed);
}

class WishListPage extends StatefulWidget {
  final String cuscode;

  WishListPage({
    Key key,
    @required this.cuscode,
  }) : super(key: key);

  @override
  _WishListPageState createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  String dropdownValue = 'ความนิยม';
  String selectOrderby;
  String _categoryName;

  void goRefresh() {
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    selectOrderby = globalOrder;
    var screenSize = MediaQuery.of(context).size;
    var scWidth = screenSize.width;
    globalScreen = screenSize;
    return Scaffold(
      endDrawer: SafeArea(
        child: Container(
          height: double.maxFinite,
          width: screenSize.width * 0.75,
          margin: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              topLeft: Radius.circular(16),
            ),
          ),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    width: double.infinity,
                    height: screenSize.height * 0.2,
                    decoration: BoxDecoration(
                      color: Constant.MAIN_BASE_COLOR,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'สินค้าที่สนใจ',
                      style: TextStyle(
                        fontSize: (screenSize.width / 100) * 5.5,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder<List<ProductBrandList>>(
                    future: fetchBrandList(widget.cuscode),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) print(snapshot.error);

                      return snapshot.hasData
                          ? BrandWidget(brandList: snapshot.data)
                          : Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
                Row(
                  children: <Widget>[
                    FlatButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        setState(() {
                          bnd = [];
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: (screenSize.width * 0.75) / 2,
                        height: (screenSize.height / 100) * 6.5,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                          ),
                        ),
                        child: Text(
                          'รีเซ็ต',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    FlatButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: (screenSize.width * 0.75) / 2,
                        height: (screenSize.height / 100) * 6.5,
                        decoration: BoxDecoration(
                          color: Colors.green,
                        ),
                        child: Text(
                          'เสร็จสิ้น',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      body: Builder(
        builder: (ctx) => Container(
          height: double.maxFinite,
          width: double.maxFinite,
          color: Constant.MAIN_BASE_COLOR,
          child: SafeArea(
            child: SingleChildScrollView(
              child: StickyHeader(
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
                                      onPressed: () async {
                                        var isLogin = await checkIsLogin();
                                        (isLogin)
                                            ? Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CartPage(),
                                                ),
                                              ).then((value) => setState(() {}))
                                            : Navigator.of(context)
                                                .pushNamedAndRemoveUntil(
                                                    '/profile',
                                                    (Route<dynamic> route) =>
                                                        false);
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
//                                        var isLogin = await checkIsLogin();
//                                        var cusCode = await getClientId();
//                                        (isLogin)
//                                            ? Navigator.push(
//                                          context,
//                                          MaterialPageRoute(
//                                            builder: (context) =>
//                                                WishListPage(cuscode: cusCode),
//                                          ),
//                                        )
//                                            : Navigator.of(context).pushNamedAndRemoveUntil(
//                                            '/profile', (Route<dynamic> route) => false);
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
                                            return _buildNotiWishlist(
                                                snapshot.data);
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
                        ),
                        (scWidth < 600) ? _buildGroupIconFuture() : SizedBox()
                      ],
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
                            GestureDetector(
                              onTap: () {
                                Scaffold.of(ctx).openEndDrawer();
                              },
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.filter_list, color: Colors.white),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'แบรนด์',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'สินค้าที่สนใจ',
                            style: TextStyle(
                              fontSize: (screenSize.width / 100) * 5.5,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      FutureBuilder<List<ProductList>>(
                        future: fetchProductList(
                            widget.cuscode, selectOrderby, bnd),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) print(snapshot.error);

                          if (snapshot.hasData) {
                            return ProductGrid(
                              productList: snapshot.data,
                              goRefresh: goRefresh,
                            );
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 75)),
                    ],
                  ),
                ),
              ),
            ),
          ),
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

class CategoryFuture extends StatelessWidget {
  final CategoryDetail catDetail;
  final int zone;

  CategoryFuture({Key key, this.catDetail, this.zone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    // TODO: implement build
    (AppLocalizations.of(context).locale.toString() == 'th')
        ? catName = catDetail.XVCatName_th
        : catName = catDetail.XVCatName_en;

    return Text(
      catName,
      style: TextStyle(
        fontSize: (screenSize.width / 100) * 5.5,
        color: (zone == 1) ? Colors.white : Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

// ignore: must_be_immutable
class ProductGrid extends StatefulWidget {
  final List<ProductList> productList;
  final Function goRefresh;

  ProductGrid({Key key, this.productList, this.goRefresh}) : super(key: key);

  void goRefreshParent() {
    goRefresh();
  }

  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  Size screenSize = globalScreen;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    int row = widget.productList.length;
    //print(row);
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: ((row / 3).ceil() * (screenSize.width / 3)) * 3,
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: GridView.builder(
            semanticChildCount: 3,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, childAspectRatio: 0.75),
            physics: new NeverScrollableScrollPhysics(),
            itemCount: row,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  var isModel = widget.productList[index].XBPdtIsModel;
                  var pdtCode = widget.productList[index].XVPdtCode;
                  var mdlCode = widget.productList[index].XVModCode;
                  (isModel == '0')
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailPage(pdtCode: pdtCode),
                          ),
                        ).then((value) => widget.goRefreshParent())
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ModelDetailPage(mdlCode: mdlCode),
                          ),
                        ).then((value) => widget.goRefreshParent());
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
                          child: (widget.productList[index].pdtImg != null)
                              ? Image.network(
                                  Constant.MAIN_URL_ASSETS +
                                      widget.productList[index].pdtImg,
                                  fit: BoxFit.cover,
                                )
                              : SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Container(
                                    color: Colors.red,
                                  ),
                                ),
                        ),
                        Positioned(
                          top: 8,
                          child: Text(
                            widget.productList[index].XVPdtName_th,
                            style: TextStyle(fontSize: 10, color: Colors.black),
                          ),
                        ),
                        Positioned(
                          top: 24,
                          child: Text(
                            widget.productList[index].XVPdtName_th,
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
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => HomeApp(1, index)),
                  (Route<dynamic> route) => false);
            },
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

// ignore: must_be_immutable
class BrandWidget extends StatelessWidget {
  Size screenSize = globalScreen;
  final List<ProductBrandList> brandList;

  BrandWidget({Key key, this.brandList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Wrap(
      spacing: 5.0,
      runSpacing: 5.0,
      children: <Widget>[
        for (var i = 0; i < brandList.length; i++)
          filterChipWidget(
              chipName: brandList[i].XVBndName_en,
              chipCode: brandList[i].XVBndCode),
      ],
    );
  }
}

// ignore: camel_case_types
class filterChipWidget extends StatefulWidget {
  final String chipName;
  final String chipCode;

  filterChipWidget({Key key, this.chipName, this.chipCode}) : super(key: key);

  @override
  _filterChipWidgetState createState() => _filterChipWidgetState();
}

// ignore: camel_case_types
class _filterChipWidgetState extends State<filterChipWidget> {
  var _isSelected = false;

  @override
  Widget build(BuildContext context) {
    var a = widget.chipCode;
    int isFound = bnd.indexOf(a);
    return FilterChip(
      label: Text(widget.chipName),
      labelStyle: TextStyle(
          color: Color(0xff6200ee),
          fontSize: 16.0,
          fontWeight: FontWeight.bold),
      selected: (isFound != -1) ? true : _isSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: Color(0xffededed),
      onSelected: (isSelected) {
        setState(() {
          _isSelected = isSelected;
          (_isSelected)
              ? bnd.add(widget.chipCode)
              : bnd.remove(widget.chipCode);
          print(bnd);
        });
      },
      selectedColor: Color(0xffeadffd),
    );
  }
}
