import 'package:alphadealdemo/src/utils/constant.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:indexed_list_view/indexed_list_view.dart';

class DraftPage extends StatelessWidget {
  static IndexedScrollController controller = IndexedScrollController(initialIndex: 20);

    GlobalKey _keyRed = GlobalKey();
    //
    _getSizes() {
    }

    _getPositions(){
      final RenderBox renderBoxRed = _keyRed.currentContext.findRenderObject();
      final positionRed = renderBoxRed.localToGlobal(Offset.zero);
      print("POSITION of Red: $positionRed ");
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
        ),
        body: Column(
          children: <Widget>[
            Flexible(
              flex: 2,
              child: Container(
                color: Colors.red,
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                color: Colors.purple,
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                key: _keyRed,
                color: Colors.green,
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  MaterialButton(
                    elevation: 5.0,
                    padding: EdgeInsets.all(15.0),
                    color: Colors.grey,
                    child: Text("Get Sizes"),
                    onPressed: _getSizes,
                  ),
                  MaterialButton(
                    elevation: 5.0,
                    color: Colors.grey,
                    padding: EdgeInsets.all(15.0),
                    child: Text("Get Positions"),
                    onPressed: _getPositions,
                  )
                ],
              ),
            )
          ],
        ),
      );
    }


  Widget button(String text, VoidCallback function) => Padding(
    padding: const EdgeInsets.all(4.0),
    child: RawMaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.all(10.0),
      fillColor: Colors.blue,
      constraints: const BoxConstraints(minWidth: 88.0, minHeight: 30.0),
      child: Text(text, style: TextStyle(fontSize: 12)),
      onPressed: function,
    ),
  );

  Function itemBuilder() {
    //
    final List<double> heights =
    new List<double>.generate(10, (i) => Random().nextInt(5).toDouble() + 30.0);

    return (BuildContext context, int index) {
      //
      return Card(
        child: Container(
          height: heights[index % 3],
          color: (index == 0) ? Colors.red : Colors.green,
          child: Center(child: Text('ITEM $index')),
        ),
      );
    };
  }
}
