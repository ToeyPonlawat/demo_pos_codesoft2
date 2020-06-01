import 'dart:convert';
import 'package:alphadealdemo/src/locale/app_localization.dart';
import 'package:alphadealdemo/src/models/category.dart';
import 'package:alphadealdemo/src/models/home.dart';
import 'package:alphadealdemo/src/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:http/http.dart' as http;

var globalScreen;
var globalOrder;
String catName;

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
    String catcode, String orderBy) async {
  String url = Constant.PDT_LIST_URL_SERVICES + catcode;
  if (orderBy != null && orderBy.length > 0) {
    url += '/?app=pdt&selectOrderby=$orderBy';
  } else {
    url += '/?app=pdt';
  }
  final response = await http.get(url);
  return parseProductList(response.body);
}

List<ProductList> parseProductList(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<ProductList>((json) => ProductList.fromJson(json)).toList();
}

// fetch Product list in Category
Future<List<BrandList>> fetchBrandList(String catcode) async {
  String url = Constant.PDT_LIST_URL_SERVICES + catcode + '/?app=brand';
  final response = await http.get(url);
  return parseBrandList(response.body);
}

List<BrandList> parseBrandList(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<BrandList>((json) => BrandList.fromJson(json)).toList();
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

class CategoryPage extends StatefulWidget {
  final String catcode;
  final CategoryDetail categoryDetail;

  CategoryPage({
    Key key,
    @required this.catcode,
    this.categoryDetail,
  }) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
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
      // appBar: AppBar(backgroundColor: Constant.MAIN_BASE_COLOR,),
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
          child: Column(
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
                child: FutureBuilder<CategoryDetail>(
                  future: fetchCategory(widget.catcode),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);

                    return snapshot.hasData
                        ? CategoryFuture(catDetail: snapshot.data, zone: 1)
                        : Center(child: CircularProgressIndicator());
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder<List<BrandList>>(
                  future: fetchBrandList(widget.catcode),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);

                    return snapshot.hasData
                        ? BrandWidget(brandList: snapshot.data)
                        : Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
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
                          _buildGroupIconFuture()
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
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: DropdownButton<String>(
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
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FutureBuilder<CategoryDetail>(
                              future: fetchCategory(widget.catcode),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) print(snapshot.error);

                                return snapshot.hasData
                                    ? CategoryFuture(
                                        catDetail: snapshot.data,
                                        zone: 0,
                                      )
                                    : Center(
                                        child: CircularProgressIndicator());
                              },
                            ),
                          ),
                        ),
                        FutureBuilder<List<ProductList>>
                          (
                          future:
                              fetchProductList(widget.catcode, selectOrderby),
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
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: ((row / 3).ceil() * (screenSize.width / 3)),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            physics: new NeverScrollableScrollPhysics(),
            itemCount: row,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Scaffold.of(context).openEndDrawer();
                },
                child: Card(
                  child: Container(
                    margin: EdgeInsets.all(4),
                    child: Stack(
                      children: <Widget>[
//                            Image.network(Constant.MAIN_URL_ASSETS +
//                                productList[i].),
                        Container(
                          padding: EdgeInsets.all(12),
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

// ignore: must_be_immutable
class BrandWidget extends StatelessWidget {
  Size screenSize = globalScreen;
  final List<BrandList> brandList;

  BrandWidget({Key key, this.brandList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Wrap(
      spacing: 5.0,
      runSpacing: 5.0,
      children: <Widget>[
        for (var i = 0; i < brandList.length; i++)
          filterChipWidget(chipName: brandList[i].XVBndCode),
      ],
    );
  }
}

// ignore: camel_case_types
class filterChipWidget extends StatefulWidget {
  final String chipName;

  filterChipWidget({Key key, this.chipName}) : super(key: key);

  @override
  _filterChipWidgetState createState() => _filterChipWidgetState();
}

// ignore: camel_case_types
class _filterChipWidgetState extends State<filterChipWidget> {
  var _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.chipName),
      labelStyle: TextStyle(
          color: Color(0xff6200ee),
          fontSize: 16.0,
          fontWeight: FontWeight.bold),
      selected: _isSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: Color(0xffededed),
      onSelected: (isSelected) {
        setState(() {
          _isSelected = isSelected;
        });
      },
      selectedColor: Color(0xffeadffd),
    );
  }
}
