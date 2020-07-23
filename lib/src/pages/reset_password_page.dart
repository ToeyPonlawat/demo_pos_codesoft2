import 'dart:async';
import 'dart:convert';

import 'package:alphadealdemo/src/utils/constant.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResetPassword {
  final String XVEmail;
  final String msg;

  ResetPassword({this.XVEmail, this.msg});

  factory ResetPassword.fromJson(Map<String, dynamic> json) {
    return ResetPassword(
      XVEmail: json['XVEmail'],
      msg: json['msg'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["XVEmail"] = XVEmail;

    return map;
  }
}

Future<ResetPassword> createPost(String url, {Map body}) async {
  return http.post(url, body: body).then((http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }

    return ResetPassword.fromJson(json.decode(response.body));
  });
}

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final emailController = new TextEditingController();
  String emailError;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('รีเซ็ตรหัสผ่าน'),
        backgroundColor: Constant.MAIN_BASE_COLOR,
      ),
      body: Center(
        child: Stack(
          overflow: Overflow.visible,
          alignment: Alignment.center,
          children: <Widget>[
            Card(
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 240),
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
                          "รีเซ็ต",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: (screenSize.width / 100) * 4,
                          ),
                        ),
                        onPressed: () async {
                          final email = emailController.text;
                          final bool isValid = EmailValidator.validate(email);

                          if (!isValid) {
                            emailError = "กรุณากรอกอีเมลให้ถูกต้อง";
                            setState(() {});
                          } else {
                            emailError = null;
                            setState(() {});

                            showDialogLoading(email);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildUsername() {
    return TextField(
      controller: emailController,
      decoration: InputDecoration(
        errorText: emailError,
        hintText: "",
        icon: Icon(Icons.person_outline),
        labelText: "อีเมล",
        border: InputBorder.none,
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }

  void showDialogLoading(String email) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      builder: (context) {
        Future.delayed(Duration(seconds: 1), () async {
          ResetPassword newPost = new ResetPassword(
            XVEmail: email,
          );

          ResetPassword p = await createPost(
              Constant.MAIN_URL_API + "auth/forget_password",
              body: newPost.toMap());

          if (p.msg == 'ok') {
            Navigator.of(context).pop(true);
            showDialogSuccess();
          } else {
            Navigator.of(context).pop(true);
            emailController.text = '';
            showDialogInvalid();
          }
        });

        return AlertDialog(
          title: Text('กรุณารอสักครู่..'),
        );
      },
    );
  }

  void showDialogInvalid() {
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
          content: Text('อีเมลไม่ถูกต้อง​'),
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
          content: Text(
              'ระบบทำการส่งอีเมลที่ใช้ในการรีเซ็ตรหัสผ่านให้คุณเรียบร้อยแล้ว​'),
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
