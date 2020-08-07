import 'dart:convert';

import 'package:alphadealdemo/src/models/donut.dart';
import 'package:alphadealdemo/src/pages/category_page.dart';
import 'package:alphadealdemo/src/pages/subgroup_page.dart';
import 'package:http/http.dart' as http;
import 'package:alphadealdemo/src/locale/app_localization.dart';
import 'package:alphadealdemo/src/models/home.dart';
import 'package:alphadealdemo/src/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var globalScreen;
int groupCount = 0;
int activeIndex;

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

// fetch Group Icon data
Future<List<DonutGroup>> fetchDonutGroup() async {
  final url = Constant.MAIN_URL_SERVICES + 'pdt_donut';
  final response = await http.get(url);
  return parseDonutGroup(response.body);
}

List<DonutGroup> parseDonutGroup(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<DonutGroup>((json) => DonutGroup.fromJson(json)).toList();
}

class DonutPage extends StatefulWidget {
  final int intitialSelected;

  DonutPage(this.intitialSelected);

  @override
  _DonutPageState createState() => _DonutPageState();
}

class _DonutPageState extends State<DonutPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    globalScreen = screenSize;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Constant.MAIN_BASE_COLOR,
        title: Text(
          'สินค้าทุกหมวดหมู่',
          style: TextStyle(
            fontSize: (screenSize.width / 100) * 6.5,
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<ProductGroup>>(
          future: fetchProductGroup(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? GroupIconList(
                    groupList: snapshot.data,
                    intitialIndex: widget.intitialSelected,
                  )
                : Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class GroupIconList extends StatefulWidget {
  final List<ProductGroup> groupList;
  int intitialIndex;

  GroupIconList({Key key, this.groupList, this.intitialIndex})
      : super(key: key);

  @override
  _GroupIconListState createState() => _GroupIconListState();
}

class _GroupIconListState extends State<GroupIconList> {
  Size screenSize = globalScreen;
  int isSelect = 0;

  void defineDonut() {
    setState(() {
      isSelect = groupCount;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      (widget.intitialIndex != null)
          ? isSelect = widget.intitialIndex
          : isSelect = isSelect;
      groupCount = isSelect;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
            child: ListView.builder(
              itemCount: widget.groupList.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      isSelect = index;
                      groupCount = index;
                      activeIndex = null;
                    });
                  },
                  child: Card(
                    child: Container(
                      decoration: (isSelect == index)
                          ? BoxDecoration(
                              border: Border.all(
                                color: Constant.MAIN_BASE_COLOR,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            )
                          : BoxDecoration(),
                      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            width: ((widget.groupList.length / 10.25).ceil() *
                                (screenSize.width / 10.25)),
                            height: ((widget.groupList.length / 12.25).ceil() *
                                (screenSize.width / 12.25)),
                            margin: EdgeInsets.only(
                                top: (screenSize.height * 0.0125)),
                            alignment: Alignment.topCenter,
                            child: Image.network(
                              Constant.MAIN_URL_ASSETS +
                                  widget.groupList[index].XVGrpIconFile,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 2),
                            child: Text(
                              (AppLocalizations.of(context).locale.toString() ==
                                      'th')
                                  ? widget.groupList[index].XVGrpName_th
                                  : widget.groupList[index].XVGrpName_en,
                              style: TextStyle(
                                fontSize: (screenSize.width / 100) * 3.25,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: FutureBuilder<List<DonutGroup>>(
            future: fetchDonutGroup(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);

              return snapshot.hasData
                  ? new DonutList(
                      groupList: snapshot.data,
                      callParent: this.defineDonut,
                    )
                  : Center(child: CircularProgressIndicator());
            },
          ),
        )
      ],
    );
  }
}

// ignore: must_be_immutable
class DonutList extends StatefulWidget {
  final List<DonutGroup> groupList;
  final Function callParent;

  DonutList({Key key, this.groupList, this.callParent}) : super(key: key);

  @override
  _DonutListState createState() => _DonutListState();
}

class _DonutListState extends State<DonutList> {
  Size screenSize = globalScreen;
  int _activeMeterIndex;
  int groupSelect = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    groupSelect = groupCount;
    _activeMeterIndex = activeIndex;
    int row = widget.groupList[groupSelect].SubGrp.length;

    return Container(
      margin: EdgeInsets.only(top: (screenSize.width * 0.025)),
      child: ListView.builder(
        itemCount: row,
        itemBuilder: (BuildContext context, int i) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child: ExpansionPanelList(
              expandedHeaderPadding: EdgeInsets.all(2),
              expansionCallback: (int index, bool status) {
                setState(() {
                  activeIndex =
                      _activeMeterIndex = _activeMeterIndex == i ? null : i;
                });
              },
              children: [
                ExpansionPanel(
                  isExpanded: _activeMeterIndex == i,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return GestureDetector(
                      onTap: () {
                        var subcode =
                            widget.groupList[groupSelect].SubGrp[i].XVSubCode;
                        var grpcode = widget.groupList[groupSelect].XVGrpCode;

                        MaterialPageRoute material = MaterialPageRoute(
                          builder: (context) => SubGroupPage(
                            subcode: subcode,
                            grpcode: grpcode,
                          ),
                        );

                        Navigator.of(context).push(material).then((value) => {
                              if (value != null)
                                {
                                  setState(() {
                                    groupCount = value;
                                    widget.callParent();
                                  })
                                }
                            });
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 15.0),
                        alignment: Alignment.centerLeft,
                        child: new Text(
                          (AppLocalizations.of(context).locale.toString() ==
                                  'th')
                              ? widget
                                  .groupList[groupSelect].SubGrp[i].XVSubName_th
                              : widget.groupList[groupSelect].SubGrp[i]
                                  .XVSubName_en,
                          style: TextStyle(
                            fontSize: (screenSize.width / 100) * 4,
                          ),
                        ),
                      ),
                    );
                  },
                  body: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      children: <Widget>[
                        for (var item
                            in widget.groupList[groupSelect].SubGrp[i].Cats)
                          GestureDetector(
                            onTap: () {
                              var catcode = item.XVCatCode;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CategoryPage(
                                    catcode: catcode,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black87,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(24),
                                  ),
                                  shape: BoxShape.rectangle),
                              child: Text(
                                (AppLocalizations.of(context)
                                            .locale
                                            .toString() ==
                                        'th')
                                    ? item.XVCatName_th
                                    : item.XVCatName_en,
                                style: TextStyle(
                                  fontSize: (screenSize.width / 100) * 3.5,
                                ),
                              ),
                              margin: EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 4,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
