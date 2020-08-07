import 'dart:ui';

//import 'package:alphadealdemo/src/locale/app_localization.dart';
import 'package:alphadealdemo/src/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:sticky_headers/sticky_headers/widget.dart';
//import 'package:url_launcher/url_launcher.dart';

var globalScreen;

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
//  GoogleMapController mapController;
//
//  final LatLng _center = const LatLng(13.703003, 100.706307);
//
//  void _onMapCreated(GoogleMapController controller) {
//    mapController = controller;
//  }
//
//  Set<Marker> adMarker() {
//    return <Marker>[
//      Marker(
//        position: _center,
//        markerId: MarkerId('idAD'),
//      ),
//    ].toSet();
//  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    globalScreen = screenSize;

    return Scaffold(
      appBar: AppBar(
        title: Text('ติดต่อเรา'),
        backgroundColor: Constant.MAIN_BASE_COLOR,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: Color.fromRGBO(254, 254, 254, 1),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 12, bottom: 12, left: 32, right: 32),
                child: Image.asset(
                  'assets/images/alphadeal_map.jpg',
                ),
              ),
            ),
            _buildBottomBanner1(),
          ],
        ),
      ),
    );

//    return Container(
//      height: double.maxFinite,
//      width: double.maxFinite,
//      color: Constant.MAIN_BASE_COLOR,
//      child: SafeArea(
//        child: SingleChildScrollView(
//          child: Container(
//            color: Color.fromRGBO(254, 254, 254, 1),
//            width: double.infinity,
//            child: Column(
//              children: <Widget>[
//                StickyHeader(
//                  header: Stack(children: <Widget>[
//                    Container(
//                      height: 100,
//                      padding: EdgeInsets.only(bottom: 0, top: 0),
//                      decoration: BoxDecoration(
//                          image: DecorationImage(
//                            image: ExactAssetImage(
//                                'assets/images/pic-contact-banner.jpg'),
//                            fit: BoxFit.cover,
//                          ),
//                          color: Color.fromRGBO(253, 250, 254, 1.0),
//                          shape: BoxShape.rectangle,
//                          boxShadow: [
//                            BoxShadow(
//                              color: Colors.black38,
//                              offset: const Offset(0.0, 6.0),
//                              blurRadius: 3.0,
//                              spreadRadius: 1.0,
//                            ),
//                          ]),
//                    ),
//                    Container(
//                      alignment: Alignment.center,
//                      height: screenSize.height * 0.1,
//                      child: Text(
//                        AppLocalizations.of(context)
//                            .translate('general_label_contact'),
//                        style: TextStyle(
//                            color: Colors.white,
//                            fontSize: (screenSize.width / 100) * 7.5,
//                            fontWeight: FontWeight.bold,
//                            shadows: [
//                              BoxShadow(
//                                color: Colors.black,
//                                offset: const Offset(1.0, 1.0),
//                                blurRadius: 5.0,
//                                spreadRadius: 5.0,
//                              ),
//                            ]),
//                      ),
//                    )
//                  ]),
//                  content: Column(children: <Widget>[
//                    Container(
//                      width: double.infinity,
//                      color: Colors.white,
//                      alignment: Alignment.centerLeft,
//                      margin: EdgeInsets.only(
//                        top: (screenSize.height / screenSize.width) * 10,
//                        bottom: (screenSize.height / screenSize.width),
//                      ),
//                      padding:
//                          EdgeInsets.only(left: (screenSize.width / 100) * 5),
//                      child: SelectableText.rich(
//                        TextSpan(children: [
//                          TextSpan(
//                              text: 'ALPHA DEAL CO., LTD.\n',
//                              style: TextStyle(
//                                  color: Constant.MAIN_BASE_COLOR,
//                                  fontFamily: 'Prompt',
//                                  fontWeight: FontWeight.bold,
//                                  fontSize: 16)),
//                          TextSpan(
//                              text: 'No. 22/41 H-Cape Biz Sector,\n',
//                              style: TextStyle(
//                                  color: Colors.black,
//                                  fontFamily: 'Prompt',
//                                  fontSize: (screenSize.width / 100) * 3.5)),
//                          TextSpan(
//                              text: 'Sukhapiban2 Rd., Pravet Sub-District,\n',
//                              style: TextStyle(
//                                  color: Colors.black,
//                                  fontFamily: 'Prompt',
//                                  fontSize: (screenSize.width / 100) * 3.5)),
//                          TextSpan(
//                              text: 'Pravet District, Bangkok 10250\n',
//                              style: TextStyle(
//                                  color: Colors.black,
//                                  fontFamily: 'Prompt',
//                                  fontSize: (screenSize.width / 100) * 3.5)),
//                        ]),
//                      ),
//                    ),
//                    Container(
//                      width: double.infinity,
//                      height: 200,
//                      margin: EdgeInsets.only(left: 20, right: 20),
//                      child: Stack(
//                        children: <Widget>[
//                          GoogleMap(
//                            zoomGesturesEnabled: false,
//                            scrollGesturesEnabled: false,
//                            myLocationButtonEnabled: false,
//                            onMapCreated: _onMapCreated,
//                            initialCameraPosition: CameraPosition(
//                              target: _center,
//                              zoom: 11.0,
//                            ),
//                            markers: adMarker(),
//                          ),
//                          Positioned(
//                              right: 20,
//                              bottom: 20,
//                              child: IconButton(
//                                onPressed: _launchMaps,
//                                padding: EdgeInsets.only(right: 60, bottom: 60),
//                                icon: Icon(
//                                  Icons.directions,
//                                  color: Colors.blue,
//                                  size: (screenSize.width / 100) * 25,
//                                ),
//                              ))
//                        ],
//                      ),
//                    ),
//                    Container(
//                      width: double.infinity,
//                      color: Colors.white,
//                      alignment: Alignment.center,
//                      margin: EdgeInsets.only(
//                        top: (screenSize.height / screenSize.width) * 5,
//                      ),
//                      padding: EdgeInsets.only(
//                        top: (screenSize.width / 100) * 2,
//                        left: (screenSize.width / 100) * 2,
//                        right: (screenSize.width / 100) * 4,
//                      ),
//                      child: Column(
//                        children: <Widget>[
//                          Padding(
//                              padding: EdgeInsets.only(
//                                  bottom: (screenSize.height / 100) * 1)),
//                          FlatButton(
//                            onPressed: () {
//                              launch('tel:+662-002-4501');
//                            },
//                            child: Container(
//                              width: double.infinity,
//                              height: 50,
//                              child: Row(
//                                mainAxisSize: MainAxisSize.max,
//                                children: <Widget>[
//                                  Container(
//                                    margin: EdgeInsets.only(
//                                      left: (screenSize.width / 100) * 2,
//                                      right: (screenSize.width / 100) * 2,
//                                    ),
//                                    width: (screenSize.width / 100) * 12,
//                                    alignment: Alignment.center,
//                                    decoration: BoxDecoration(
//                                      color: Constant.MAIN_BASE_COLOR,
//                                      shape: BoxShape.circle,
//                                      boxShadow: [
//                                        BoxShadow(
//                                          color: Colors.black38,
//                                          offset: const Offset(0.0, 1.0),
//                                          blurRadius: 2.0,
//                                          spreadRadius: 1.0,
//                                        ),
//                                      ],
//                                    ),
//                                    child: Icon(
//                                      Icons.call,
//                                      color: Colors.white,
//                                    ),
//                                  ),
//                                  Padding(
//                                    padding: EdgeInsets.only(right: 10),
//                                  ),
//                                  Text(
//                                    '(+66) 2-002-4501-04',
//                                    style: TextStyle(
//                                      fontSize: (screenSize.width / 100) * 4,
//                                    ),
//                                  )
//                                ],
//                              ),
//                            ),
//                          ),
//                          Padding(
//                              padding: EdgeInsets.only(
//                                  bottom: (screenSize.height / 100) * 1)),
//                          FlatButton(
//                            onPressed: () {
//                              // do something
//                            },
//                            child: Container(
//                              width: double.infinity,
//                              height: 50,
//                              child: Row(
//                                mainAxisSize: MainAxisSize.max,
//                                children: <Widget>[
//                                  Container(
//                                    margin: EdgeInsets.only(
//                                      left: (screenSize.width / 100) * 2,
//                                      right: (screenSize.width / 100) * 2,
//                                    ),
//                                    width: (screenSize.width / 100) * 12,
//                                    alignment: Alignment.center,
//                                    decoration: BoxDecoration(
//                                      color: Constant.MAIN_BASE_COLOR,
//                                      shape: BoxShape.circle,
//                                      boxShadow: [
//                                        BoxShadow(
//                                          color: Colors.black38,
//                                          offset: const Offset(0.0, 1.0),
//                                          blurRadius: 2.0,
//                                          spreadRadius: 1.0,
//                                        ),
//                                      ],
//                                    ),
//                                    child: Icon(
//                                      Icons.business_center,
//                                      color: Colors.white,
//                                    ),
//                                  ),
//                                  Padding(
//                                    padding: EdgeInsets.only(right: 10),
//                                  ),
//                                  Text(
//                                    '(+66) 2-002-4505',
//                                    style: TextStyle(
//                                      fontSize: (screenSize.width / 100) * 4,
//                                    ),
//                                  )
//                                ],
//                              ),
//                            ),
//                          ),
//                          Padding(
//                              padding: EdgeInsets.only(
//                                  bottom: (screenSize.height / 100) * 1)),
//                          FlatButton(
//                            onPressed: () {
//                              launch('mailto:info@alphadeal54.com');
//                            },
//                            child: Container(
//                              width: double.infinity,
//                              height: 50,
//                              child: Row(
//                                mainAxisSize: MainAxisSize.max,
//                                children: <Widget>[
//                                  Container(
//                                    margin: EdgeInsets.only(
//                                      left: (screenSize.width / 100) * 2,
//                                      right: (screenSize.width / 100) * 2,
//                                    ),
//                                    width: (screenSize.width / 100) * 12,
//                                    alignment: Alignment.center,
//                                    decoration: BoxDecoration(
//                                      color: Constant.MAIN_BASE_COLOR,
//                                      shape: BoxShape.circle,
//                                      boxShadow: [
//                                        BoxShadow(
//                                          color: Colors.black38,
//                                          offset: const Offset(0.0, 1.0),
//                                          blurRadius: 2.0,
//                                          spreadRadius: 1.0,
//                                        ),
//                                      ],
//                                    ),
//                                    child: Icon(
//                                      Icons.email,
//                                      color: Colors.white,
//                                    ),
//                                  ),
//                                  Padding(
//                                    padding: EdgeInsets.only(right: 10),
//                                  ),
//                                  Text(
//                                    'info@alphadeal54.com',
//                                    style: TextStyle(
//                                      fontSize: (screenSize.width / 100) * 4,
//                                    ),
//                                  )
//                                ],
//                              ),
//                            ),
//                          ),
//                          Padding(
//                              padding: EdgeInsets.only(
//                                  bottom: (screenSize.height / 100) * 1)),
//                          FlatButton(
//                            onPressed: () {
//                              launch('http:www.alphadeal54.com/');
//                            },
//                            child: Container(
//                              width: double.infinity,
//                              height: 50,
//                              child: Row(
//                                mainAxisSize: MainAxisSize.max,
//                                children: <Widget>[
//                                  Container(
//                                    margin: EdgeInsets.only(
//                                      left: (screenSize.width / 100) * 2,
//                                      right: (screenSize.width / 100) * 2,
//                                    ),
//                                    width: (screenSize.width / 100) * 12,
//                                    alignment: Alignment.center,
//                                    decoration: BoxDecoration(
//                                      color: Constant.MAIN_BASE_COLOR,
//                                      shape: BoxShape.circle,
//                                      boxShadow: [
//                                        BoxShadow(
//                                          color: Colors.black38,
//                                          offset: const Offset(0.0, 1.0),
//                                          blurRadius: 2.0,
//                                          spreadRadius: 1.0,
//                                        ),
//                                      ],
//                                    ),
//                                    child: Icon(
//                                      Icons.language,
//                                      color: Colors.white,
//                                    ),
//                                  ),
//                                  Padding(
//                                    padding: EdgeInsets.only(right: 10),
//                                  ),
//                                  Text(
//                                    'www.alphadeal54.com',
//                                    style: TextStyle(
//                                      fontSize: (screenSize.width / 100) * 4,
//                                    ),
//                                  )
//                                ],
//                              ),
//                            ),
//                          ),
//                          Padding(
//                              padding: EdgeInsets.only(
//                                  bottom: (screenSize.height / 100) * 1)),
//                          FlatButton(
//                            onPressed: () {
//                              launch('https://line.me/R/ti/p/@linedevelopers');
//                            },
//                            child: Container(
//                              width: double.infinity,
//                              height: 50,
//                              child: Row(
//                                mainAxisSize: MainAxisSize.max,
//                                children: <Widget>[
//                                  Container(
//                                    margin: EdgeInsets.only(
//                                      left: (screenSize.width / 100) * 2,
//                                      right: (screenSize.width / 100) * 2,
//                                    ),
//                                    width: (screenSize.width / 100) * 12,
//                                    alignment: Alignment.center,
//                                    decoration: BoxDecoration(
//                                      shape: BoxShape.rectangle,
//                                      image: DecorationImage(
//                                        image: ExactAssetImage(
//                                          'assets/images/LINE_APP.png',
//                                        ),
//                                      ),
//                                      boxShadow: [
//                                        BoxShadow(
//                                          color: Colors.black38,
//                                          offset: const Offset(2.0, 2.0),
//                                          blurRadius: 5.0,
//                                          spreadRadius: -4.0,
//                                        ),
//                                      ],
//                                    ),
//                                  ),
//                                  Padding(
//                                    padding: EdgeInsets.only(right: 10),
//                                  ),
//                                  Text(
//                                    '@alphadeal54',
//                                    style: TextStyle(
//                                      fontSize: (screenSize.width / 100) * 4,
//                                    ),
//                                  )
//                                ],
//                              ),
//                            ),
//                          ),
//                          Padding(padding: EdgeInsets.only(bottom: 75)),
//                        ],
//                      ),
//                    ),
//                  ]),
//                ),
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
  }

  Padding _buildBottomBanner1() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 32, left: 32, right: 32),
      child: Image.asset(
        'assets/images/banner1_image.png',
      ),
    );
  }

//  _launchMaps() async {
//    // Set Google Maps URL Scheme for iOS in info.plist (comgooglemaps)
//    double lat = _center.latitude;
//    double lng = _center.longitude;
//    const googleMapSchemeIOS = 'comgooglemaps://';
//    const googleMapURL = 'https://maps.google.com/';
//    const appleMapURL = 'https://maps.apple.com/';
//    final parameter = '?z=16&q=$lat,$lng';
//
//    if (await canLaunch(googleMapSchemeIOS)) {
//      return await launch(googleMapSchemeIOS + parameter);
//    }
//
//    if (await canLaunch(appleMapURL)) {
//      return await launch(appleMapURL + parameter);
//    }
//
//    if (await canLaunch(googleMapURL)) {
//      return await launch(googleMapURL + parameter);
//    }
//
//    throw 'Could not launch url';
//  }
}
