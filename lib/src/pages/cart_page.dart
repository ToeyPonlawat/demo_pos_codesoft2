import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:alphadealdemo/src/services/databases.dart';
import 'package:alphadealdemo/src/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alphadealdemo/src/bloc/database_bloc.dart';
import 'package:alphadealdemo/src/models/cart.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

final formatCurrency = new NumberFormat.currency(locale: "th", symbol: "");

var globalScreen;
var pdtCart = '';
var qty = [];

// fetch Group Icon data
Future<List<CartQuery>> fetchCartList(List pdt) async {
  var url = Constant.MAIN_URL_API + 'product_cart?';
  for (var i = 0; i < pdt.length; i++) {
    (i >= 1) ? url += '&pdtcode[$i]=' + pdt[i] : url += 'pdtcode[$i]=' + pdt[i];
  }
  final response = await http.get(url);
  //print(url);
  return parseCartList(response.body);
}

List<CartQuery> parseCartList(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<CartQuery>((json) => CartQuery.fromJson(json)).toList();
}

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final bloc = CartBloc();

  void setList() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
//    Cart n = new Cart(XVBarCode: '2229637982123',XVBarName: '',XVBarNameOth: '',XFBarRetPri1: '153.00',XIQty: 2);
//    bloc.add(n);
    //bloc.delete('2229637982116');
    var screenSize = MediaQuery.of(context).size;
    globalScreen = screenSize;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('รถเข็นสินค้า'),
        backgroundColor: Constant.MAIN_BASE_COLOR,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FutureBuilder(
              future: DBProvider.db.getAllCarts(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Cart>> snapshot) {
                if (snapshot.hasData) {
                  //print('case1');
                  return CartList(
                    cartList: snapshot.data,
                  );
                } else {
                  //print(snapshot.data == null);
                  if (snapshot.data == null) {
                    return Container(
                      width: screenSize.width,
                      height: screenSize.height,
                      color: Colors.red,
                    );
                  } else {
                    //print('case');
                    return Center(child: CircularProgressIndicator());
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CartList extends StatefulWidget {
  final List<Cart> cartList;

  CartList({Key key, this.cartList}) : super(key: key);

  @override
  _CartListState createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  Size screenSize = globalScreen;

  @override
  Widget build(BuildContext context) {
    var pdt = [];
    var pdtQty = [];
//    print(widget.cartList.length);
    for (var i = 0; i < widget.cartList.length; i++) {
      pdt.add(widget.cartList[i].XVBarCode);
      pdtQty.add(widget.cartList[i].XIQty);
      qty = pdtQty;
      setState(() {});
    }
    // TODO: implement build
    return FutureBuilder<List<CartQuery>>(
      future: fetchCartList(pdt),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return CartShow(
            cartListShow: snapshot.data,
          );
        } else {
          if(widget.cartList.length < 1){
            return Container(
              width: screenSize.width,
              height: screenSize.height,
              color: Colors.white,
              child: Center(
                child: Text('empty'),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

// ignore: must_be_immutable
class CartShow extends StatefulWidget {
  final List<CartQuery> cartListShow;

  CartShow({Key key, this.cartListShow}) : super(key: key);

  @override
  _CartShowState createState() => _CartShowState();
}

class _CartShowState extends State<CartShow> {
  final bloc = CartBloc();
  Size screenSize = globalScreen;
  @override
  Widget build(BuildContext context) {
    var sumPurchase = cal(widget.cartListShow, qty);
    // TODO: implement build
    if (widget.cartListShow.length > 0) {
      return Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Divider(
                    height: 1,
                    color: Colors.black54,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'ยอดรวมสุทธิ',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '฿ ' +
                          formatCurrency.format(
                            sumPurchase,
                          ),
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FlatButton(
                        onPressed: () {
                          //
                        },
                        color: Colors.green,
                        child: Container(
                          alignment: Alignment.center,
                          width: 100,
                          child: Text(
                            'สั่งซื้อสินค้า',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FlatButton(
                        onPressed: () {
                          //
                        },
                        color: Constant.MAIN_BASE_COLOR,
                        child: Container(
                          alignment: Alignment.center,
                          width: 100,
                          child: Text(
                            'ขอใบเสนอราคา',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          for (var i = 0; i < widget.cartListShow.length; i++)
            Card(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: (screenSize.width / 100) * 32,
                    height: (screenSize.height / 100) * 18,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        (widget.cartListShow[i].pdtImg != null)
                            ? Container(
                                margin: EdgeInsets.only(left: 8),
                                child: Image.network(
                                  Constant.MAIN_URL_ASSETS +
                                      widget.cartListShow[i].pdtImg,
                                  fit: BoxFit.scaleDown,
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.only(left: 8),
                                child: Image.asset(
                                  ('assets/images/not-found.png'),
                                ),
                              ),
                        (widget.cartListShow[i].bndImg != null)
                            ? Positioned(
                                top: 4,
                                left: 8,
                                child: Container(
                                  width: (screenSize.width / 100) * 8,
                                  child: Image.network(
                                    Constant.MAIN_URL_ASSETS +
                                        widget.cartListShow[i].bndImg,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                  Container(
                    width: (screenSize.width / 100) * 60,
                    height: (screenSize.height / 100) * 18,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.cartListShow[i].XVPdtName_th,
                          style: TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            'รหัสสินค้า : ' +
                                widget.cartListShow[i].XVPdtCode +
                                ' | ' +
                                'บรรจุ ' +
                                widget.cartListShow[i].XFPdtFactor +
                                ' ' +
                                widget.cartListShow[i].XVUntName_th,
                            style:
                                TextStyle(fontSize: 9, color: Colors.black54),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerRight,
                              child: Row(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      int j = qty[i];
                                      if (j == 1) {
                                        //print(j);
                                        return;
                                      } else {
                                        j--;
                                        qty[i] = j;
                                        setState(() {});
                                        Cart n = new Cart(
                                            XVBarCode: widget
                                                .cartListShow[i].XVPdtCode,
                                            XIQty: j,
                                            XFBarRetPri1: '',
                                            XVBarNameOth: '',
                                            XVBarName: '');
                                        bloc.edit(n);
                                        //print(qty);
                                        return;
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black54, width: 1),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(4),
                                          bottomLeft: Radius.circular(4),
                                        ),
                                      ),
                                      child: Text(
                                        '-',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialogInputQty(
                                          widget.cartListShow[i].XVPdtCode, i);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 4),
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
                                        qty[i].toString(),
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      int j = qty[i];
                                      j++;
                                      qty[i] = j;
                                      setState(() {});
                                      //print(qty);
                                      Cart n = new Cart(
                                          XVBarCode:
                                              widget.cartListShow[i].XVPdtCode,
                                          XIQty: j,
                                          XFBarRetPri1: '',
                                          XVBarNameOth: '',
                                          XVBarName: '');
                                      bloc.edit(n);
                                      return;
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black54, width: 1),
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(4),
                                          bottomRight: Radius.circular(4),
                                        ),
                                      ),
                                      child: Text(
                                        '+',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                '฿ ' +
                                    formatCurrency.format(
                                      double.parse(widget
                                              .cartListShow[i].XFPdtStdPrice)
                                          .toDouble(),
                                    ),
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                showDialogRemoveCart(
                                    widget.cartListShow[i].XVPdtCode, i);
                              },
                              icon: Icon(Icons.delete_outline),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              '* ระยะเวลาในการจัดส่ง ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              widget.cartListShow[i].XNPdtWShipDay,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              ' วัน',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
        ],
      );
    } else {
      return SizedBox();
    }
  }

  void showDialogInputQty(String barCode, int index) {
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
                  qty[index] = a;
                  setState(() {});
                  //print(qty);
                  Cart n = new Cart(
                      XVBarCode: barCode,
                      XIQty: a,
                      XFBarRetPri1: '',
                      XVBarNameOth: '',
                      XVBarName: '');
                  bloc.edit(n);
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

  void showDialogRemoveCart(String barCode, int index) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'ลบสินค้าออกจากรถเข็น',
            style: TextStyle(color: Colors.orangeAccent),
          ),
          content: Text(
            'คุณแน่ใจว่าจะลบสินค้านี้?',
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                color: Colors.orange,
                child: Text(
                  'ยืนยัน',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  bloc.delete(barCode);
                  qty.removeAt(index);
                  widget.cartListShow.removeAt(index);
                  setState(() {});
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

  cal(List<CartQuery> cartListShow, List qty) {
    var sum = 0.0;
    for (int i = 0; i < cartListShow.length; i++) {
      sum += (double.parse(cartListShow[i].XFPdtStdPrice) * qty[i]);
    }
    return sum;
  }
}
