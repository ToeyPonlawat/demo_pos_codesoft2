import 'dart:async';
import 'dart:convert';

import 'package:alphadealdemo/src/locale/app_localization.dart';
import 'package:alphadealdemo/src/pages/language_page.dart';
import 'package:alphadealdemo/src/pages/register_page.dart';
import 'package:alphadealdemo/src/pages/reset_password_page.dart';
import 'package:alphadealdemo/src/services/app_language.dart';
import 'package:alphadealdemo/src/services/databases.dart';
import 'package:alphadealdemo/src/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:alphadealdemo/src/bloc/database_bloc.dart';
import 'package:alphadealdemo/src/models/client.dart';

var globalScreen;

class Post {
  final String username;
  final String password;
  final String app;
  final String success;
  final String XVConCode;
  final String XVUser;
  final String XVName;
  final String XVEmail;

  Post(
      {this.username,
      this.password,
      this.app,
      this.success,
      this.XVConCode,
      this.XVUser,
      this.XVName,
      this.XVEmail});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      username: json['username'],
      password: json['password'],
      app: json['app'],
      success: json['success'],
      XVConCode: json['XVConCode'],
      XVUser: json['XVUser'],
      XVName: json['XVName'],
      XVEmail: json['XVEmail'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = username;
    map["password"] = password;
    map["app"] = app;

    return map;
  }
}

Future<Post> createPost(String url, {Map body}) async {
  //print(url);
  return http.post(url, body: body).then((http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }

    return Post.fromJson(json.decode(response.body));
  });
}

class MePage extends StatefulWidget {
  @override
  _MePageState createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  final usernameController = new TextEditingController();

  final passwordController = new TextEditingController();

  String usernameError;

  String passwordError;

  final bloc = ClientsBloc();

  final cartBloc = CartBloc();

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    globalScreen = screenSize;
    return FutureBuilder(
      future: checkIsLogin(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == true) {
            return _buildProfilePage(context, screenSize);
          }
          return _buildLoginPage(screenSize, context);
        }
        return SizedBox();
      },
    );

//
  }

  Future<bool> checkIsLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool("isLogin") ?? false;
  }

  Container _buildLoginPage(Size screenSize, BuildContext context) {
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      color: Constant.MAIN_BASE_COLOR,
      child: SafeArea(
        child: Container(
          color: Color.fromRGBO(254, 254, 254, 1),
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.bottomCenter,
                      width: double.infinity,
                      height: (screenSize.height / 100) * 50,
                      padding: EdgeInsets.only(
                        bottom: (screenSize.height / 100) * 20,
                      ),
                      decoration: BoxDecoration(
                        color: Constant.MAIN_BASE_COLOR,
                        shape: BoxShape.rectangle,
                      ),
                      child: Container(
                        width: (screenSize.width / 100) * 20,
                        height: (screenSize.width / 100) * 20,
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(254, 254, 254, 1),
                              Color.fromRGBO(91, 1, 126, 1.0),
                            ],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black45,
                              offset: const Offset(2.0, 2.0),
                              blurRadius: 3.0,
                              spreadRadius: 1.0,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/logo-white.png',
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                    Stack(
                      overflow: Overflow.visible,
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 300),
                          child: Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 22, right: 22, top: 22, bottom: 44),
                              child: Column(
                                children: <Widget>[
                                  _buildUsername(),
                                  Divider(
                                    height: 16,
                                    indent: 16,
                                    endIndent: 16,
                                  ),
                                  _buildPassword(),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 152,
                          height: 46,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                              gradient: LinearGradient(
                                colors: [Colors.yellow, Colors.orange],
                              ),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black45,
                                  offset: Offset(1.0, 6.0),
                                  blurRadius: 8.0,
                                ),
                                BoxShadow(
                                  color: Colors.black45,
                                  offset: Offset(1.0, 6.0),
                                  blurRadius: 4.0,
                                ),
                              ]),
                          child: FlatButton(
                            textColor: Colors.white,
                            child: Text(
                              "เข้าสู่ระบบ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: (screenSize.width / 100) * 4,
                              ),
                            ),
                            onPressed: () async {
                              final username = usernameController.text;
                              final password = passwordController.text;

                              Post newPost = new Post(
                                  username: username,
                                  password: password,
                                  app: "true");
                              Post p = await createPost(
                                  Constant.MAIN_URL_API + "login",
                                  body: newPost.toMap());
                              //print(p);
                              if (p.success == 'ok') {
                                showDialogLoading();

                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setString('username', username);
                                await prefs.setBool('isLogin', true);

                                Client test = new Client(
                                    XVConCode: p.XVConCode,
                                    XVUser: p.XVUser,
                                    XVName: p.XVName,
                                    XVEmail: p.XVEmail);

                                bloc.add(test);

                                usernameController.text = '';
                                passwordController.text = '';
                                Timer(Duration(seconds: 1), () async {
                                  setState(() {});
                                });
                              } else {
                                showDialogInvalid();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResetPasswordPage(),
                            ),
                          );
                        },
                        child: Text(
                          'ลืมรหัสผ่าน',
                          style: TextStyle(
                            color: Constant.MAIN_BASE_COLOR,
                          ),
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ),
                          );
                        },
                        child: Text(
                          'สมัครสมาชิก',
                          style: TextStyle(
                            color: Constant.MAIN_BASE_COLOR,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showDialogInvalid() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Login'),
          content: Text('Username or Password Invalid'),
          actions: <Widget>[
            FlatButton(
              child: Text('Dismiss'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }

  void showDialogLoading() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      builder: (context) {
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          title: Text('Please wait..'),
        );
      },
    );
  }

  _buildUsername() {
    return TextField(
      controller: usernameController,
      decoration: InputDecoration(
        errorText: usernameError,
        hintText: "",
        icon: Icon(Icons.person_outline),
        labelText: "ชื่อบัญชี",
        border: InputBorder.none,
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }

  _buildPassword() {
    return TextField(
      controller: passwordController,
      decoration: InputDecoration(
        errorText: passwordError,
        hintText: "",
        icon: Icon(Icons.lock_outline),
        labelText: "รหัสผ่าน",
        border: InputBorder.none,
      ),
      obscureText: true,
    );
  }

  Container _buildProfilePage(BuildContext context, Size screenSize) {
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      color: Constant.MAIN_BASE_COLOR,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Color.fromRGBO(254, 254, 254, 1),
            width: double.infinity,
            child: Column(
              children: <Widget>[
                _buildTopMenu(context, screenSize),
                _buildProfileMenu(screenSize),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Stack _buildTopMenu(BuildContext context, Size screenSize) {
    var scWidth = screenSize.width;
    if (scWidth < 600) {
      return Stack(children: <Widget>[
        Container(
          alignment: Alignment.topCenter,
          width: double.infinity,
          height: 200,
          padding: EdgeInsets.only(bottom: 0, top: 20),
          decoration: BoxDecoration(
            color: Constant.MAIN_BASE_COLOR,
            shape: BoxShape.rectangle,
          ),
          child: Text(
            AppLocalizations.of(context).translate('general_label_profile'),
            style: TextStyle(
                color: Colors.white,
                fontSize: (screenSize.width / 100) * 7.5,
                fontWeight: FontWeight.bold,
                shadows: [
                  BoxShadow(
                    color: Colors.black,
                    offset: const Offset(1.0, 1.0),
                    blurRadius: 5.0,
                    spreadRadius: 5.0,
                  ),
                ]),
          ),
        ),
        Container(
            width: double.infinity,
            height: 200,
            margin: EdgeInsets.only(left: 20, right: 20, top: 80),
            decoration: BoxDecoration(
                color: Color.fromRGBO(254, 254, 254, 1),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    offset: const Offset(3.0, 3.0),
                    blurRadius: 3.0,
                    spreadRadius: 1.0,
                  ),
                ]),
            child: _buildStackProfileCard(screenSize)),
      ]);
    } else {
      return Stack(children: <Widget>[
        Container(
          alignment: Alignment.topCenter,
          width: double.infinity,
          height: 340,
          padding: EdgeInsets.only(bottom: 0, top: 20),
          decoration: BoxDecoration(
            color: Constant.MAIN_BASE_COLOR,
            shape: BoxShape.rectangle,
          ),
          child: Text(
            AppLocalizations.of(context).translate('general_label_profile'),
            style: TextStyle(
                color: Colors.white,
                fontSize: (screenSize.width / 100) * 7.5,
                fontWeight: FontWeight.bold,
                shadows: [
                  BoxShadow(
                    color: Colors.black,
                    offset: const Offset(1.0, 1.0),
                    blurRadius: 5.0,
                    spreadRadius: 5.0,
                  ),
                ]),
          ),
        ),
        Container(
            width: double.infinity,
            height: 340,
            margin: EdgeInsets.only(left: 40, right: 40, top: 100),
            decoration: BoxDecoration(
                color: Color.fromRGBO(254, 254, 254, 1),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    offset: const Offset(3.0, 3.0),
                    blurRadius: 3.0,
                    spreadRadius: 1.0,
                  ),
                ]),
            child: _buildStackProfileCard(screenSize)),
      ]);
    }
  }

  Container _buildProfileMenu(Size screenSize) {
    var appLanguage = Provider.of<AppLanguage>(context);
    var lang = appLanguage.appLocal.toString();
    return Container(
      width: double.infinity,
      color: Colors.white,
      alignment: Alignment.center,
      margin: EdgeInsets.only(
        top: (screenSize.height / screenSize.width) * 5,
      ),
      padding: EdgeInsets.only(
        top: (screenSize.width / 100) * 2,
        left: (screenSize.width / 100) * 2,
        right: (screenSize.width / 100) * 4,
      ),
      child: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(bottom: (screenSize.height / 100) * 3)),
          FlatButton(
            onPressed: () {
              // do something
            },
            child: Container(
              width: double.infinity,
              height: 50,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      left: (screenSize.width / 100) * 2,
                      right: (screenSize.width / 100) * 2,
                    ),
                    width: (screenSize.width / 100) * 12,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Constant.MAIN_BASE_COLOR,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          offset: const Offset(0.0, 1.0),
                          blurRadius: 2.0,
                          spreadRadius: 1.0,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.history,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                  ),
                  Text(
                    'ประวัติการสั่งซื้อ',
                    style: TextStyle(
                      fontSize: (screenSize.width / 100) * 4,
                      fontWeight: FontWeight.normal,
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(bottom: (screenSize.height / 100) * 2)),
          FlatButton(
            onPressed: () {
              // do something
            },
            child: Container(
              width: double.infinity,
              height: 50,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      left: (screenSize.width / 100) * 2,
                      right: (screenSize.width / 100) * 2,
                    ),
                    width: (screenSize.width / 100) * 12,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Constant.MAIN_BASE_COLOR,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          offset: const Offset(0.0, 1.0),
                          blurRadius: 2.0,
                          spreadRadius: 1.0,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.person_outline,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                  ),
                  Text(
                    'ข้อมูลส่วนตัว',
                    style: TextStyle(
                      fontSize: (screenSize.width / 100) * 4,
                      fontWeight: FontWeight.normal,
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(bottom: (screenSize.height / 100) * 2)),
          FlatButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LanguagePage(),
                  ));
            },
            child: Container(
              width: double.infinity,
              height: 50,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      left: (screenSize.width / 100) * 2,
                      right: (screenSize.width / 100) * 2,
                    ),
                    width: (screenSize.width / 100) * 12,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Constant.MAIN_BASE_COLOR,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          offset: const Offset(0.0, 1.0),
                          blurRadius: 2.0,
                          spreadRadius: 1.0,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.flag,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                  ),
                  Text(
                    (lang == 'th') ? 'เปลี่ยนภาษา' : 'Language',
                    style: TextStyle(
                      fontSize: (screenSize.width / 100) * 4,
                      fontWeight: FontWeight.normal,
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(bottom: (screenSize.height / 100) * 2)),
          FlatButton(
            onPressed: () async {
              showDialogLoading();

              Timer(Duration(seconds: 1), () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLogin', false);
                bloc.deleteAll();
                cartBloc.deleteAll();
                setState(() {});
              });
            },
            child: Container(
              width: double.infinity,
              height: 50,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      left: (screenSize.width / 100) * 2,
                      right: (screenSize.width / 100) * 2,
                    ),
                    width: (screenSize.width / 100) * 12,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Constant.MAIN_BASE_COLOR,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          offset: const Offset(0.0, 1.0),
                          blurRadius: 2.0,
                          spreadRadius: 1.0,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.power_settings_new,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                  ),
                  Text(
                    'ออกจากระบบ',
                    style: TextStyle(
                      fontSize: (screenSize.width / 100) * 4,
                      fontWeight: FontWeight.normal,
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: 110)),
        ],
      ),
    );
  }

  Container _buildStackProfileCard(Size screenSize) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            width: (screenSize.width / 100) * 25,
            height: (screenSize.width / 100) * 25,
            margin: EdgeInsets.only(bottom: 14),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: Colors.black45,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    offset: const Offset(1.0, 1.0),
                    blurRadius: 3.0,
                    spreadRadius: 1.0,
                  ),
                ]),
            child: Image.asset(
              'assets/images/logo-mini.png',
              fit: BoxFit.scaleDown,
            ),
          ),
          FutureBuilder<List<Client>>(
            future: DBProvider.db.getAllClients(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Client>> snapshot) {
              if (snapshot.hasData) {
                Client item = snapshot.data[0];
                return Text(
                  item.XVName != null ? item.XVName : '',
                  style: TextStyle(
                    fontSize: (screenSize.width / 100) * 4.5,
                    color: Colors.black,
                    shadows: [
                      Shadow(
                          color: Colors.white,
                          offset: const Offset(1, 1),
                          blurRadius: 3),
                    ],
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          FutureBuilder<List<Client>>(
            future: DBProvider.db.getAllClients(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Client>> snapshot) {
              if (snapshot.hasData) {
                Client item = snapshot.data[0];
                return Text(
                  item.XVEmail != null ? item.XVEmail : '',
                  style: TextStyle(
                    fontSize: (screenSize.width / 100) * 3.5,
                    color: Colors.black,
                    shadows: [
                      Shadow(
                          color: Colors.white,
                          offset: const Offset(1, 1),
                          blurRadius: 3),
                    ],
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}
