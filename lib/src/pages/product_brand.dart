import 'dart:convert';

import 'package:alphadealdemo/src/locale/app_localization.dart';
import 'package:alphadealdemo/src/models/category.dart';
import 'package:alphadealdemo/src/pages/product_detail_page.dart';
import 'package:alphadealdemo/src/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:http/http.dart' as http;

import 'model_detail_page.dart';

var globalScreen;
var globalOrder;
String bndName;

// fetch Product list in Category
Future<List<ProductList>> fetchProductList(
    String bndcode, String orderBy) async {
  String url = Constant.PDT_BND_LIST_URL_SERVICES + bndcode;
  if (orderBy != null && orderBy.length > 0) {
    url += '?app=pdt&selectOrderby=$orderBy';
  } else {
    url += '?app=pdt';
  }
//
//  if (brand != []) {
//    for (int i = 0; i < brand.length; i++)
//      url += '&XVBndCodeArr[$i]=' + brand[i].toString();
//  }

  //print(url);

  final response = await http.get(url);
  return parseProductList(response.body);
}

List<ProductList> parseProductList(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<ProductList>((json) => ProductList.fromJson(json)).toList();
}

class ProductBrandPage extends StatefulWidget {
  final String bndcode;

  ProductBrandPage({Key key, this.bndcode}) : super(key: key);

  @override
  _ProductBrandPageState createState() => _ProductBrandPageState();
}

class _ProductBrandPageState extends State<ProductBrandPage> {
  String dropdownValue = 'ความนิยม';
  String selectOrderby;
  String _categoryName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    selectOrderby = globalOrder;
    var screenSize = MediaQuery.of(context).size;
    globalScreen = screenSize;
    return Scaffold(
      body: Builder(
        builder: (ctx) => Container(
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
                                            padding:
                                                EdgeInsets.only(bottom: 0.5),
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
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
                            future:
                                fetchProductList(widget.bndcode, selectOrderby),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) print(snapshot.error);

                              return snapshot.hasData
                                  ? ProductGrid(productList: snapshot.data)
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
      ),
    );
  }
}

//class CategoryFuture extends StatelessWidget {
//  final CategoryDetail catDetail;
//  final int zone;
//
//  CategoryFuture({Key key, this.catDetail, this.zone}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    var screenSize = MediaQuery.of(context).size;
//    // TODO: implement build
//    (AppLocalizations.of(context).locale.toString() == 'th')
//        ? catName = catDetail.XVCatName_th
//        : catName = catDetail.XVCatName_en;
//
//    return Text(
//      catName,
//      style: TextStyle(
//        fontSize: (screenSize.width / 100) * 5.5,
//        color: (zone == 1) ? Colors.white : Colors.black,
//        fontWeight: FontWeight.bold,
//      ),
//    );
//  }
//}

// ignore: must_be_immutable
class ProductGrid extends StatefulWidget {
  final List<ProductList> productList;

  ProductGrid({
    Key key,
    this.productList,
  }) : super(key: key);

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

    if (row > 0) {
      (AppLocalizations.of(context).locale.toString() == 'th')
          ? bndName = widget.productList[0].XVBndName_th
          : bndName = widget.productList[0].XVBndName_en;
    } else {
      bndName = "";
    }

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              bndName,
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
                          child: (widget.productList[index].pdtImg != null)
                              ? Image.network(
                                  Constant.MAIN_URL_ASSETS +
                                      widget.productList[index].pdtImg,
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
