import 'dart:convert';

import 'package:alphadealdemo/src/models/profile.dart';
import 'package:alphadealdemo/src/utils/constant.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String twUser = '';
String twUserBef = '';
int twIndex = 0;
var listUName = [];
var listEmail = [];
var listName = [];
var listPass = [];

Future<PostLoginRegister> createPost(String url, {Map body}) async {
  return http.post(url, body: body).then((http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }

    return PostLoginRegister.fromJson(json.decode(response.body));
  });
}

Future<PostRegister> createPostRegister(
    String url,
    String XVPnrType,
    String XVCstName,
    String XVAdsName,
    String XVAdsPhone1,
    String XVAdsEmail,
    String XVAdsCountry,
    String XVAdsProvince,
    String TWUser) async {
  url += '?XVPnrType=' + XVPnrType;
  url += '&XVCstName=' + XVCstName;
  url += '&XVAdsName=' + XVAdsName;
  url += '&XVAdsPhone1=' + XVAdsPhone1;
  url += '&XVAdsEmail=' + XVAdsEmail;
  url += '&XVAdsCountry=' + XVAdsCountry;
  url += '&XVAdsProvince=' + XVAdsProvince;
  url += TWUser;
  //print(url);

  return http.post(url).then((http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }

    return PostRegister.fromJson(json.decode(response.body));
  });
}

class AccountPage extends StatefulWidget {
  final bool isCompany;
  final String XVCstName;
  final String XVAdsName;
  final String XVAdsPhone1;
  final String XVAdsEmail;
  final String XVAdsCountry;
  final String XVAdsProvince;

  AccountPage(this.isCompany, this.XVCstName, this.XVAdsName, this.XVAdsPhone1,
      this.XVAdsEmail, this.XVAdsCountry, this.XVAdsProvince);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final nameController = new TextEditingController();

  final emailController = new TextEditingController();

  final usernameController = new TextEditingController();

  final passwordController = new TextEditingController();

  final cfPasswordController = new TextEditingController();

  String nameError;

  String emailError;

  String usernameError;

  String passwordError;

  String cfPasswordError;

  void setList() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลเข้าสู่ระบบ'),
        backgroundColor: Constant.MAIN_BASE_COLOR,
      ),
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  if (widget.isCompany)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: FlatButton(
                            onPressed: () async {
                              if (twIndex == 0 && twUser == '') {
                                showDialogCondition();
                              } else {
                                twUser = '';
                                int a = 0, b = 1, c = 2, d = 3, e = 4, f = 5;
                                for(var i=0;i<twIndex;i++){
                                  twUser += '&TWUser[$i][$a]=' + listUName[i];
                                  twUser += '&TWUser[$i][$b]=' + listPass[i];
                                  twUser += '&TWUser[$i][$c]=' + listEmail[i];
                                  twUser += '&TWUser[$i][$d]=' + listName[i];
                                  twUser += '&TWUser[$i][$e]=' + '';
                                  twUser += '&TWUser[$i][$f]=' + '';
                                  setState(() {});
                                }
                                //print(twUser);
                                String PnrType;
                                (widget.isCompany)
                                    ? PnrType = '1'
                                    : PnrType = '0';

                                PostRegister prResult =
                                    await createPostRegister(
                                  Constant.MAIN_URL_API +
                                      "auth/mobile_register",
                                  PnrType,
                                  widget.XVCstName,
                                  widget.XVAdsName,
                                  widget.XVAdsPhone1,
                                  widget.XVAdsEmail,
                                  widget.XVAdsCountry,
                                  widget.XVAdsProvince,
                                  twUser,
                                );
                                if (prResult.status == 'ok') {
                                  showDialogSuccess();
                                } else {
                                  showDialogInvalid('พบข้อผิดพลาด');
                                }
                              }
                            },
                            color: Color.fromRGBO(224, 199, 233, 1),
                            child: Text(
                              'ยืนยัน',
                              style: TextStyle(
                                color: Color.fromRGBO(60, 8, 87, 1),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: FlatButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (_) {
                                    return MyDialog(setList);
                                  });
                            },
                            color: Color.fromRGBO(224, 199, 233, 1),
                            child: Text(
                              'เพิ่มผู้ใช้',
                              style: TextStyle(
                                color: Color.fromRGBO(60, 8, 87, 1),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  Column(
                    children: <Widget>[
                      if (!widget.isCompany)
                        Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                          shadowColor: Constant.MAIN_BASE_COLOR,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 18),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: TextField(
                                    controller: nameController,
                                    decoration: InputDecoration(
                                      errorText: nameError,
                                      labelText: 'ชื่อ',
                                    ),
                                    onChanged: (value) {
                                      if (value.length > 1) {
                                        nameError = null;
                                        setState(() {});
                                      }
                                    },
                                    style: _inputTextStyle(screenSize),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: TextField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      errorText: emailError,
                                      labelText: 'อีเมล',
                                    ),
                                    style: _inputTextStyle(screenSize),
                                    onChanged: (value) {
                                      if (value.length > 1) {
                                        emailError = null;
                                        setState(() {});
                                      }
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: TextField(
                                    controller: usernameController,
                                    decoration: InputDecoration(
                                      errorText: usernameError,
                                      labelText: 'Username',
                                    ),
                                    onChanged: (value) {
                                      if (value.length > 1) {
                                        usernameError = null;
                                        setState(() {});
                                      }
                                    },
                                    style: _inputTextStyle(screenSize),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: TextField(
                                    controller: passwordController,
                                    decoration: InputDecoration(
                                      errorText: passwordError,
                                      labelText: 'Password',
                                    ),
                                    obscureText: true,
                                    onChanged: (value) {
                                      if (value.length > 1) {
                                        passwordError = null;
                                        setState(() {});
                                      }
                                    },
                                    style: _inputTextStyle(screenSize),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: TextField(
                                    controller: cfPasswordController,
                                    decoration: InputDecoration(
                                      errorText: cfPasswordError,
                                      labelText: 'Confirm password',
                                    ),
                                    onChanged: (value) {
                                      if (value.length > 1) {
                                        cfPasswordError = null;
                                        setState(() {});
                                      }
                                    },
                                    style: _inputTextStyle(screenSize),
                                    obscureText: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (!widget.isCompany)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: FlatButton(
                                onPressed: () async {
                                  int a = 0, b = 1, c = 2, d = 3, e = 4, f = 5;
                                  bool isPass = true;
                                  var name = nameController.text;
                                  var email = emailController.text;
                                  var username = usernameController.text;
                                  var password = passwordController.text;
                                  var cfPassword = cfPasswordController.text;

                                  if (name.length < 1 || name == null) {
                                    nameError = 'กรุณากรอกชื่อ';
                                    isPass = false;
                                  }
                                  final bool isValid =
                                      EmailValidator.validate(email);

                                  if (!isValid) {
                                    emailError = 'กรุณากรอกอีเมลให้ถูกต้อง';
                                    isPass = false;
                                  }
                                  if (username.length < 1 || username == null) {
                                    usernameError = 'กรุณากรอก Username';
                                    isPass = false;
                                  }
                                  if (password.length < 1 || password == null) {
                                    passwordError = 'กรุณากรอก Password';
                                    isPass = false;
                                  }
                                  if (cfPassword != password) {
                                    cfPasswordError =
                                        'กรุณายืนยัน Password ให้ตรงกัน';
                                    isPass = false;
                                  }
                                  if (cfPassword.length < 1 ||
                                      cfPassword == null) {
                                    cfPasswordError = 'กรุณากรอก Password';
                                    isPass = false;
                                  }

                                  setState(() {});

                                  if (isPass) {
                                    PostLoginRegister post =
                                        new PostLoginRegister(
                                            username, email, '');

                                    PostLoginRegister p = await createPost(
                                        Constant.MAIN_URL_API +
                                            "auth/mobile_register_validate",
                                        body: post.toMap());

                                    if (p.status == 'ok') {
                                      twUser += '&TWUser[0][$a]=' + username;
                                      twUser += '&TWUser[0][$b]=' + password;
                                      twUser += '&TWUser[0][$c]=' + email;
                                      twUser += '&TWUser[0][$d]=' + name;
                                      twUser += '&TWUser[0][$e]=' + '';
                                      twUser += '&TWUser[0][$f]=' + '';
                                      setState(() {});

                                      // ignore: non_constant_identifier_names
                                      String PnrType;
                                      (widget.isCompany)
                                          ? PnrType = '1'
                                          : PnrType = '0';

                                      PostRegister prResult =
                                          await createPostRegister(
                                        Constant.MAIN_URL_API +
                                            "auth/mobile_register",
                                        PnrType,
                                        widget.XVCstName,
                                        widget.XVAdsName,
                                        widget.XVAdsPhone1,
                                        widget.XVAdsEmail,
                                        widget.XVAdsCountry,
                                        widget.XVAdsProvince,
                                        twUser,
                                      );
                                      if (prResult.status == 'ok') {
                                        showDialogSuccess();
                                      }
                                    } else {
                                      print(p.status);
                                      twUser = '';
                                      setState(() {});
                                      showDialogInvalid(p.status);
                                    }
                                  }
                                },
                                color: Color.fromRGBO(224, 199, 233, 1),
                                child: Text(
                                  'ยืนยัน',
                                  style: TextStyle(
                                    color: Color.fromRGBO(60, 8, 87, 1),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (widget.isCompany)
                        _buildHeaderCard(listName, listEmail)
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle _inputTextStyle(Size screenSize) {
    return TextStyle(
      fontSize: (screenSize.width / 100) * 4,
    );
  }

  _buildHeaderCard(List name, List email) {
    if (twIndex > 0) {
      return Column(
        children: <Widget>[
          for (var i = 0; i < twIndex; i++)
            ListTile(
              leading: Icon(Icons.person_pin),
              title: Text(
                name[i] + '$i' ?? "No title",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                email[i] ?? "No subtitle",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete_outline),
                onPressed: () {
                  listName.removeAt(i);
                  listUName.removeAt(i);
                  listEmail.removeAt(i);
                  listPass.removeAt(i);
                  print(twUser);
                  twIndex--;
                  setState(() {});
                },
              ),
            ),
        ],
      );
    } else {
      return SizedBox();
    }
  }

  void showDialogSuccess() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'สำเร็จ',
            style: TextStyle(color: Colors.green),
          ),
          content: Text('สมัครสมาชิกเรียบร้อย​'),
          actions: <Widget>[
            FlatButton(
              child: Text('ปิด'),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/profile', (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  void showDialogInvalid(String errorName) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'พบข้อผิดหลาด',
            style: TextStyle(color: Colors.redAccent),
          ),
          content: Text('$errorName นี้ถูกใช้ไปแล้ว'),
          actions: <Widget>[
            FlatButton(
              child: Text('ปิด'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }

  void showDialogCondition() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'พบข้อผิดพลาด',
            style: TextStyle(color: Colors.orangeAccent),
          ),
          content: Text('กรุณาเพิ่มข้อมูลผู้ใช้'),
          actions: <Widget>[
            FlatButton(
              child: Text('ปิด'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }
}

class MyDialog extends StatefulWidget {
  final Function setListParent;

  MyDialog(this.setListParent);

  void goToDonutParent() {
    setListParent();
  }

  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  final nameController2 = new TextEditingController();

  final emailController2 = new TextEditingController();

  final usernameController2 = new TextEditingController();

  final passwordController2 = new TextEditingController();

  final cfPasswordController2 = new TextEditingController();

  String nameError2;

  String emailError2;

  String usernameError2;

  String passwordError2;

  String cfPasswordError2;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shadowColor: Constant.MAIN_BASE_COLOR,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: nameController2,
                decoration: InputDecoration(
                  errorText: nameError2,
                  labelText: 'ชื่อ',
                ),
                onChanged: (value) {
                  if (value.length > 1) {
                    nameError2 = null;
                    setState(() {});
                  }
                },
                style: _inputTextStyle(screenSize),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: emailController2,
                decoration: InputDecoration(
                  errorText: emailError2,
                  labelText: 'อีเมล',
                ),
                style: _inputTextStyle(screenSize),
                onChanged: (value) {
                  if (value.length > 1) {
                    emailError2 = null;
                    setState(() {});
                  }
                },
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: usernameController2,
                decoration: InputDecoration(
                  errorText: usernameError2,
                  labelText: 'Username',
                ),
                onChanged: (value) {
                  if (value.length > 1) {
                    usernameError2 = null;
                    setState(() {});
                  }
                },
                style: _inputTextStyle(screenSize),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: passwordController2,
                decoration: InputDecoration(
                  errorText: passwordError2,
                  labelText: 'Password',
                ),
                obscureText: true,
                onChanged: (value) {
                  if (value.length > 1) {
                    passwordError2 = null;
                    setState(() {});
                  }
                },
                style: _inputTextStyle(screenSize),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: cfPasswordController2,
                decoration: InputDecoration(
                  errorText: cfPasswordError2,
                  labelText: 'Confirm password',
                ),
                onChanged: (value) {
                  if (value.length > 1) {
                    cfPasswordError2 = null;
                    setState(() {});
                  }
                },
                style: _inputTextStyle(screenSize),
                obscureText: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: FlatButton(
                onPressed: () async {
                  //print('case');
                  int a = 0, b = 1, c = 2, d = 3, e = 4, f = 5;
                  bool isPass = true;
                  var name = nameController2.text;
                  var email = emailController2.text;
                  var username = usernameController2.text;
                  var password = passwordController2.text;
                  var cfPassword = cfPasswordController2.text;

                  if (name.length < 1 || name == null) {
                    nameError2 = 'กรุณากรอกชื่อ';
                    isPass = false;
                  }
                  final bool isValid = EmailValidator.validate(email);

                  if (!isValid) {
                    emailError2 = 'กรุณากรอกอีเมลให้ถูกต้อง';
                    isPass = false;
                  }
                  if (username.length < 1 || username == null) {
                    usernameError2 = 'กรุณากรอก Username';
                    isPass = false;
                  }
                  if (password.length < 1 || password == null) {
                    passwordError2 = 'กรุณากรอก Password';
                    isPass = false;
                  }
                  if (cfPassword != password) {
                    cfPasswordError2 = 'กรุณายืนยัน Password ให้ตรงกัน';
                    isPass = false;
                  }
                  if (cfPassword.length < 1 || cfPassword == null) {
                    cfPasswordError2 = 'กรุณากรอก Password';
                    isPass = false;
                  }

                  setState(() {});

                  print(twUser);

                  if (isPass) {
                    PostLoginRegister post =
                        new PostLoginRegister(username, email, '');

                    PostLoginRegister p = await createPost(
                        Constant.MAIN_URL_API + "auth/mobile_register_validate",
                        body: post.toMap());

                    if (p.status == 'ok') {
                      int isFoundUser = listUName.indexOf(username);
                      int isFoundEmail = listEmail.indexOf(email);
                      if (isFoundUser == -1 && isFoundEmail == -1) {
                        twUser += '&TWUser[$twIndex][$a]=' + username;
                        twUser += '&TWUser[$twIndex][$b]=' + password;
                        twUser += '&TWUser[$twIndex][$c]=' + email;
                        twUser += '&TWUser[$twIndex][$d]=' + name;
                        twUser += '&TWUser[$twIndex][$e]=' + '';
                        twUser += '&TWUser[$twIndex][$f]=' + '';
                        twIndex++;
                        listUName.add(username);
                        listEmail.add(email);
                        listName.add(name);
                        listPass.add(password);
                        setState(() {});
                        widget.goToDonutParent();
                        print(twIndex);
                        Navigator.pop(context);
                      } else {
                        if (isFoundUser != -1) {
                          showDialogInvalid('Username');
                        } else if (isFoundEmail != -1) {
                          showDialogInvalid('Email');
                        } else {
                          showDialogInvalid('N/A');
                        }
                      }
                    } else {
                      print(p.status);
                      twUser = '';
                      setState(() {});
                      showDialogInvalid(p.status);
                    }
                  }
                },
                color: Color.fromRGBO(224, 199, 233, 1),
                child: Text(
                  'เพิ่ม',
                  style: TextStyle(
                    color: Color.fromRGBO(60, 8, 87, 1),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  TextStyle _inputTextStyle(Size screenSize) {
    return TextStyle(
      fontSize: (screenSize.width / 100) * 4,
    );
  }

  void showDialogInvalid(String errorName) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'พบข้อผิดหลาด',
            style: TextStyle(color: Colors.redAccent),
          ),
          content: Text('$errorName นี้ถูกใช้ไปแล้ว'),
          actions: <Widget>[
            FlatButton(
              child: Text('ปิด'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }
}
