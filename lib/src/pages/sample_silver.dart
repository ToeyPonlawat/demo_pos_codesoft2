//import 'package:carousel_pro/carousel_pro.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
//
//class HomePage extends StatefulWidget {
//  @override
//  _HomePageState createState() => _HomePageState();
//}
//
//class _HomePageState extends State<HomePage> {
//  // Height of your Container
//  static final _containerHeight = 100.0;
//
//  // You don't need to change any of these variables
//  var _fromTop = -_containerHeight;
//  var _controller = ScrollController();
//  var _allowReverse = true, _allowForward = true;
//  var _prevOffset = 0.0;
//  var _prevForwardOffset = -_containerHeight;
//  var _prevReverseOffset = 0.0;
//
//  @override
//  void initState() {
//    super.initState();
//    _controller.addListener(_listener);
//  }
//
//  // entire logic is inside this listener for ListView
//  void _listener() {
//    double offset = _controller.offset;
//    var direction = _controller.position.userScrollDirection;
//
//    if (direction == ScrollDirection.reverse) {
//      _allowForward = true;
//      if (_allowReverse) {
//        _allowReverse = false;
//        _prevOffset = offset;
//        _prevForwardOffset = _fromTop;
//      }
//
//      var difference = offset - _prevOffset;
//      _fromTop = _prevForwardOffset + difference;
//      if (_fromTop > 0) _fromTop = 0;
//    } else if (direction == ScrollDirection.forward) {
//      _allowReverse = true;
//      if (_allowForward) {
//        _allowForward = false;
//        _prevOffset = offset;
//        _prevReverseOffset = _fromTop;
//      }
//
//      var difference = offset - _prevOffset;
//      _fromTop = _prevReverseOffset + difference;
//      if (_fromTop < -_containerHeight) _fromTop = -_containerHeight;
//    }
//    setState(() {}); // for simplicity I'm calling setState here, you can put bool values to only call setState when there is a genuine change in _fromTop
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: Stack(
//        children: <Widget>[
//          _yourListView(),
//          Positioned(
//            top: _fromTop,
//            left: 0,
//            right: 0,
//            child: _yourContainer(),
//          )
//        ],
//      ),
//    );
//  }
//
//  Widget _yourListView() {
//    var screenSize = MediaQuery.of(context).size;
//    return ListView.builder(
//      itemCount: 1,
//      controller: _controller,
//      itemBuilder: (_, index) {
//        return Column(
//          children: <Widget>[
//            _buildFullLogo(),
//            _buildDefaultSearch(),
//            _buildSlideImage(screenSize),
//            _buildNewProduct(screenSize),
//            _buildBestSeller(screenSize),
//          ],
//        );
//      },
//
//    );
//  }
//
//
//  Container _buildBestSeller(Size screenSize) {
//    return Container(
//      width: double.infinity,
//      height: (screenSize.height * 0.27),
//      color: Colors.white,
//      child: Container(
//        width: double.maxFinite,
//        height: double.maxFinite,
//        padding: EdgeInsets.only(left: 10, top: 0, right: 10, bottom: 10),
//        margin: EdgeInsets.only(top: 20),
//        decoration: BoxDecoration(
//          gradient: LinearGradient(
//            colors: [
//              Color.fromRGBO(255, 214, 55, 1.0),
//              Color.fromRGBO(231, 56, 39, 1.0)
//            ],
//            begin: Alignment.topCenter,
//            end: Alignment.bottomCenter,
//          ),
//        ),
//        child: Column(
//          children: <Widget>[
//            Align(
//              alignment: Alignment.topLeft,
//              child: Container(
//                padding: EdgeInsets.only(top: 5, left: 5),
//                child: Row(
//                  children: <Widget>[
//                    Text(
//                      'Best Seller',
//                      style: TextStyle(
//                        color: Colors.black,
//                        fontSize: 20,
//                      ),
//                    ),
//                    Padding(
//                      padding: EdgeInsets.all(4),
//                    ),
//                    Icon(
//                      Icons.fiber_manual_record,
//                      size: 10,
//                      color: Colors.black,
//                    ),
//                    Padding(
//                      padding: EdgeInsets.all(4),
//                    ),
//                    Text(
//                      'สินค้าขายดี',
//                      style: TextStyle(
//                        color: Colors.black,
//                        fontSize: 20,
//                      ),
//                    )
//                  ],
//                ),
//              ),
//            ),
//            Container(
//              width: double.maxFinite,
//              height: (screenSize.height * 0.19),
//              alignment: Alignment.bottomLeft,
//              margin: EdgeInsets.only(left: 4, right: 4, top: 4),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  Container(
//                    width: (screenSize.width / 3.5),
//                    height: (screenSize.height * 0.175),
//                    decoration: BoxDecoration(
//                      color: Colors.white,
//                      borderRadius: BorderRadius.all(Radius.circular(10)),
//                    ),
//                  ),
//                  Container(
//                    width: (screenSize.width / 3.5),
//                    height: (screenSize.height * 0.175),
//                    decoration: BoxDecoration(
//                      color: Colors.white,
//                      borderRadius: BorderRadius.all(Radius.circular(10)),
//                    ),
//                  ),
//                  Container(
//                    width: (screenSize.width / 3.5),
//                    height: (screenSize.height * 0.175),
//                    decoration: BoxDecoration(
//                      color: Colors.white,
//                      borderRadius: BorderRadius.all(Radius.circular(10)),
//                    ),
//                  )
//                ],
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//
//  Container _buildNewProduct(Size screenSize) {
//    return Container(
//      width: double.infinity,
//      height: (screenSize.height * 0.25),
//      color: Colors.white,
//      child: Container(
//        width: double.maxFinite,
//        height: double.maxFinite,
//        padding: EdgeInsets.only(left: 10, top: 0, right: 10, bottom: 10),
//        decoration: BoxDecoration(
//          gradient: LinearGradient(
//            colors: [
//              Color.fromRGBO(91, 1, 126, 1.0),
//              Color.fromRGBO(231, 56, 39, 1.0)
//            ],
//            begin: Alignment.topCenter,
//            end: Alignment.bottomCenter,
//          ),
//        ),
//        child: Column(
//          children: <Widget>[
//            Align(
//              alignment: Alignment.topLeft,
//              child: Container(
//                padding: EdgeInsets.only(top: 5, left: 5),
//                child: Row(
//                  children: <Widget>[
//                    Text(
//                      'New Product',
//                      style: TextStyle(
//                        color: Colors.white,
//                        fontSize: 20,
//                      ),
//                    ),
//                    Padding(
//                      padding: EdgeInsets.all(4),
//                    ),
//                    Icon(
//                      Icons.fiber_manual_record,
//                      size: 10,
//                      color: Colors.white,
//                    ),
//                    Padding(
//                      padding: EdgeInsets.all(4),
//                    ),
//                    Text(
//                      'สินค้าใหม่',
//                      style: TextStyle(
//                        color: Colors.white,
//                        fontSize: 20,
//                      ),
//                    )
//                  ],
//                ),
//              ),
//            ),
//            Container(
//              width: double.maxFinite,
//              height: (screenSize.height * 0.19),
//              alignment: Alignment.bottomLeft,
//              margin: EdgeInsets.only(left: 4, right: 4, top: 4),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  Container(
//                    width: (screenSize.width / 3.5),
//                    height: (screenSize.height * 0.175),
//                    decoration: BoxDecoration(
//                      color: Colors.white,
//                      borderRadius: BorderRadius.all(Radius.circular(10)),
//                    ),
//                  ),
//                  Container(
//                    width: (screenSize.width / 3.5),
//                    height: (screenSize.height * 0.175),
//                    decoration: BoxDecoration(
//                      color: Colors.white,
//                      borderRadius: BorderRadius.all(Radius.circular(10)),
//                    ),
//                  ),
//                  Container(
//                    width: (screenSize.width / 3.5),
//                    height: (screenSize.height * 0.175),
//                    decoration: BoxDecoration(
//                      color: Colors.white,
//                      borderRadius: BorderRadius.all(Radius.circular(10)),
//                    ),
//                  )
//                ],
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//
//  Container _buildSlideImage(Size screenSize) {
//    return Container(
//      width: double.infinity,
//      height: (screenSize.height * 0.25),
//      color: Colors.white,
//      child: Container(
//        width: double.infinity,
//        height: (screenSize.height * 0.2),
//        margin: EdgeInsets.only(left: 10, top: 0, right: 10, bottom: 10),
//        child: Carousel(
//          boxFit: BoxFit.fitWidth,
//          autoplay: false,
//          animationCurve: Curves.fastOutSlowIn,
//          animationDuration: Duration(milliseconds: 5000),
//          dotSize: 7.0,
//          dotIncreasedColor: Colors.grey,
//          dotBgColor: Colors.transparent,
//          dotPosition: DotPosition.bottomCenter,
//          dotVerticalPadding: 0.0,
//          showIndicator: true,
//          indicatorBgPadding: 0.0,
//          moveIndicatorFromBottom: 20,
//          images: [
//            ExactAssetImage(
//              'assets/images/6-02.png',
//            ),
//            ExactAssetImage('assets/images/6-02.png'),
//            ExactAssetImage('assets/images/6-02.png'),
//            ExactAssetImage('assets/images/6-02.png'),
//          ],
//        ),
//      ),
//    );
//  }
//
//  Container _buildFullLogo() {
//    return Container(
//      margin: EdgeInsets.only(left: 36, top: 12, right: 36, bottom: 6),
//      child: Image.asset(
//        'assets/images/logo-full.png',
//      ),
//    );
//  }
//
//  Container _buildDefaultSearch() {
//
//    var screenSize = MediaQuery.of(context).size;
//    return Container(
//      width: double.infinity,
//      height: (screenSize.height * 0.055),
//      child: Row(
//        children: <Widget>[
//          Container(
//            width: (screenSize.width * 0.74),
//            height: (screenSize.height * 0.055),
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.end,
//              children: <Widget>[
//                Container(
//                  width: (screenSize.width * 0.55),
//                  height: (screenSize.height * 0.045),
//                  decoration: BoxDecoration(border: Border.all(width: 1)),
//                  child: TextField(
//                    autofocus: false,
//                    decoration: InputDecoration(
//                        fillColor: Colors.white,
//                        hintText: 'ชื่อสินค้า/รหัสสินค้า/ประเภทสินค้า',
//                        contentPadding: EdgeInsets.only(
//                            left: 10, top: 5, right: 20, bottom: 10)),
//                  ),
//                ),
//                Container(
//                  width: (screenSize.width * 0.14),
//                  height: (screenSize.height * 0.045),
//                  decoration: BoxDecoration(
//                    border: Border(
//                      bottom: BorderSide(width: 1),
//                      top: BorderSide(width: 1),
//                      right: BorderSide(width: 1),
//                    ),
//                    color: Colors.amber,
//                  ),
//                  child: IconButton(
//                    icon: Icon(
//                      Icons.search,
//                      color: Colors.black,
//                      size: (screenSize.height * 0.040),
//                    ),
//                    padding: EdgeInsets.only(bottom: 0.5),
//                  ),
//                )
//              ],
//            ),
//          ),
//          Container(
//            width: (screenSize.width * 0.13),
//            height: (screenSize.height * 0.075),
//            alignment: Alignment.centerRight,
//            child: Stack(
//              children: <Widget>[
//                IconButton(
//                  icon: Icon(
//                    Icons.shopping_cart,
//                    color: Colors.black,
//                    size: (screenSize.height * 0.030),
//                  ),
//                  padding: EdgeInsets.only(bottom: 0.5),
//                ),
//                Positioned(
//                  right: 4,
//                  top: 4,
//                  child: Container(
//                    padding: EdgeInsets.all(1),
//                    decoration: new BoxDecoration(
//                      color: Colors.red,
//                      borderRadius: BorderRadius.circular(10),
//                    ),
//                    constraints: BoxConstraints(
//                      minWidth: 14,
//                      minHeight: 14,
//                    ),
//                    child: Text(
//                      '1',
//                      style: TextStyle(
//                        color: Colors.white,
//                        fontSize: 8,
//                      ),
//                      textAlign: TextAlign.center,
//                    ),
//                  ),
//                )
//              ],
////                        child: IconButton(
////                          icon: Icon(
////                            Icons.favorite,
////                            color: Colors.black,
////                            size: (screenSize.height * 0.030),
////                          ),
////                          padding: EdgeInsets.only(bottom: 0.5),
////                        ),
//            ),
//          ),
//          Container(
//            width: (screenSize.width * 0.10),
//            height: (screenSize.height * 0.075),
//            alignment: Alignment.centerLeft,
//            child: Stack(
//              children: <Widget>[
//                IconButton(
//                  icon: Icon(
//                    Icons.favorite,
//                    color: Colors.black,
//                    size: (screenSize.height * 0.030),
//                  ),
//                  padding: EdgeInsets.only(bottom: 0.5),
//                ),
//                Positioned(
//                  right: 2,
//                  top: 4,
//                  child: Container(
//                    padding: EdgeInsets.all(1),
//                    decoration: new BoxDecoration(
//                      color: Colors.red,
//                      borderRadius: BorderRadius.circular(10),
//                    ),
//                    constraints: BoxConstraints(
//                      minWidth: 14,
//                      minHeight: 14,
//                    ),
//                    child: Text(
//                      '1',
//                      style: TextStyle(
//                        color: Colors.white,
//                        fontSize: 8,
//                      ),
//                      textAlign: TextAlign.center,
//                    ),
//                  ),
//                )
//              ],
////                        child: IconButton(
////                          icon: Icon(
////                            Icons.favorite,
////                            color: Colors.black,
////                            size: (screenSize.height * 0.030),
////                          ),
////                          padding: EdgeInsets.only(bottom: 0.5),
////                        ),
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//
//  Widget _yourContainer() {
//    return Opacity(
//      opacity: 1 - (-_fromTop / _containerHeight),
//      child: Container(
//        height: _containerHeight,
//        color: Colors.red,
//        alignment: Alignment.center,
//        child: Text("Your Container", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
//      ),
//    );
//  }
//}