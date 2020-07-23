import 'dart:convert';

import 'package:alphadealdemo/src/models/profile.dart';
import 'package:alphadealdemo/src/pages/account_page.dart';
import 'package:alphadealdemo/src/utils/constant.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String globalCouCode;
String globalCouName;
String globalPvnCode;
String globalPvnName;

// fetch Group Icon data
Future<List<Country>> fetchCountry() async {
  final url = Constant.URL_FRONT + '?app=country';
  final response = await http.get(url);
  return parseCountry(response.body);
}

List<Country> parseCountry(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Country>((json) => Country.fromJson(json)).toList();
}

// fetch Group Icon data
Future<List<Province>> fetchProvince() async {
  final url = Constant.MAIN_URL_API + 'get_province/?app=true';
  final response = await http.get(url);
  return parseProvince(response.body);
}

List<Province> parseProvince(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Province>((json) => Province.fromJson(json)).toList();
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final comnameController = new TextEditingController();
  final addressController = new TextEditingController();
  final phoneController = new TextEditingController();
  final emailController = new TextEditingController();
  final countryController = new TextEditingController();
  final provinceController = new TextEditingController();

  String comnameError;
  String addressError;
  String phoneError;
  String emailError;
  String countryError;
  String provinceError;
  bool isCompany = true;
  int selectedValue;

  showCountryPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Color(0xffffffff),
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xff999999),
                    width: 0.0,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CupertinoButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 5.0,
                    ),
                  ),
                  CupertinoButton(
                    child: Text('Confirm'),
                    onPressed: () {
                      setState(() {
                        countryController.text = globalCouName;
                      });
                      Navigator.pop(context);
                    },
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 5.0,
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 320.0,
              color: Color(0xfff7f7f7),
              child: FutureBuilder(
                future: fetchCountry(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);

                  return snapshot.hasData
                      ? CountryPicker(countryList: snapshot.data)
                      : Center(child: CircularProgressIndicator());
                },
              ),
            )
          ],
        );
      },
    );
  }

  showProvincePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Color(0xffffffff),
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xff999999),
                    width: 0.0,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CupertinoButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 5.0,
                    ),
                  ),
                  CupertinoButton(
                    child: Text('Confirm'),
                    onPressed: () {
                      setState(() {
                        provinceController.text = globalPvnName;
                      });
                      Navigator.pop(context);
                    },
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 5.0,
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 320.0,
              color: Color(0xfff7f7f7),
              child: FutureBuilder(
                future: fetchProvince(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);

                  return snapshot.hasData
                      ? ProvincePicker(provinceList: snapshot.data)
                      : Center(child: CircularProgressIndicator());
                },
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('สมัครสมาชิก'),
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Card(
                      shadowColor: Colors.black,
                      elevation: 4,
                      margin:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      color: Color.fromRGBO(60, 8, 87, 1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 2),
                        child: Text(
                          'เลือกประเภทผู้ใช้บริการ',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isCompany = true;
                          });
                        },
                        child: Container(
                          decoration: (isCompany)
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
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 2),
                              child: Text('นามบริษัท'),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isCompany = false;
                          });
                        },
                        child: Container(
                          decoration: (!isCompany)
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
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 2),
                              child: Text('นามบุคคล'),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Card(
                      shadowColor: Colors.black,
                      elevation: 4,
                      margin: EdgeInsets.only(top: 12, left: 12),
                      color: Color.fromRGBO(60, 8, 87, 1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 2),
                        child: Text(
                          'ข้อมูลส่วนตัว',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: comnameController,
                      decoration: InputDecoration(
                        errorText: comnameError,
                        labelText:
                            (isCompany) ? 'ชื่อบริษัท' : 'ชื่อ - นามสกุล',
                      ),
                      onChanged: (value) {
                        if (value.length > 1) {
                          comnameError = null;
                          setState(() {});
                        }
                      },
                      style: _inputTextStyle(screenSize),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: addressController,
                      decoration: InputDecoration(
                        errorText: addressError,
                        labelText: 'ที่อยู่',
                      ),
                      style: _inputTextStyle(screenSize),
                      onChanged: (value) {
                        if (value.length > 1) {
                          addressError = null;
                          setState(() {});
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Card(
                      shadowColor: Colors.black,
                      elevation: 4,
                      margin: EdgeInsets.only(top: 12, left: 12),
                      color: Color.fromRGBO(60, 8, 87, 1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 2),
                        child: Text(
                          'การติดต่อ',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        errorText: phoneError,
                        labelText: 'เบอร์โทรศัพท์',
                      ),
                      style: _inputTextStyle(screenSize),
                      onChanged: (value) {
                        if (value.length > 1) {
                          phoneError = null;
                          setState(() {});
                        }
                      },
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Card(
                      shadowColor: Colors.black,
                      elevation: 4,
                      margin: EdgeInsets.only(top: 12, left: 12),
                      color: Color.fromRGBO(60, 8, 87, 1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 2),
                        child: Text(
                          'ที่ตั้งและภูมิประเทศ',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      onTap: () {
                        showCountryPicker();
                        countryError = null;
                        setState(() {});
                      },
                      controller: countryController,
                      decoration: InputDecoration(
                        errorText: countryError,
                        labelText: 'ประเทศ',
                      ),
                      style: _inputTextStyle(screenSize),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      onTap: () {
                        showProvincePicker();
                        provinceError = null;
                        setState(() {});
                      },
                      controller: provinceController,
                      decoration: InputDecoration(
                        errorText: provinceError,
                        labelText: 'จังหวัด',
                      ),
                      style: _inputTextStyle(screenSize),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: FlatButton(
                      onPressed: () {
                        bool isPass = true;
                        var comName = comnameController.text;
                        var address = addressController.text;
                        var phone = phoneController.text;
                        var email = emailController.text;
                        var country = globalCouCode;
                        var province = globalPvnCode;

                        if (comName.length < 1 || comName == null) {
                          comnameError = 'กรุณากรอกชื่อ';
                          isPass = false;
                        }
                        if (address.length < 1 || address == null) {
                          addressError = 'กรุณากรอกที่อยู่';
                          isPass = false;
                        }
                        if (phone.length != 10 || phone == null) {
                          phoneError = 'เบอร์โทรศัทพ์ไม่ถูกต้อง';
                          isPass = false;
                        }
                        final bool isValid = EmailValidator.validate(email);

                        if (!isValid) {
                          emailError = 'กรุณากรอกอีเมลให้ถูกต้อง';
                          isPass = false;
                        }
                        if (country == null) {
                          countryError = 'กรุณาเลือกประเทศ';
                          isPass = false;
                        }
                        if (province == null) {
                          provinceError = 'กรุณาเลือกจังหวัด';
                          isPass = false;
                        }

                        setState(() {});

                        if (isPass) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AccountPage(isCompany,comName,address,phone,email,country,province),
                            ),
                          );
                        }
                      },
                      color: Color.fromRGBO(224, 199, 233, 1),
                      child: Text(
                        'ต่อไป',
                        style: TextStyle(
                          color: Color.fromRGBO(60, 8, 87, 1),
                        ),
                      ),
                    ),
                  )
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
}

class CountryPicker extends StatefulWidget {
  final List<Country> countryList;

  CountryPicker({Key key, this.countryList}) : super(key: key);

  @override
  _CountryPickerState createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  int selectedValue = 0;

  @override
  Widget build(BuildContext context) {
    int row = widget.countryList.length;
    // TODO: implement build
    return CupertinoPicker(
      /* the rest of the picker */
      scrollController: FixedExtentScrollController(initialItem: selectedValue),
      backgroundColor: Colors.white,
      onSelectedItemChanged: (value) {
        setState(() {
          selectedValue = value;
          globalCouCode = widget.countryList[value].XVCouCode;
          globalCouName = widget.countryList[value].XVCouName;
        });
      },
      itemExtent: 32.0,
      children: [
        for (var index = 0; index < row; index++)
          Text((widget.countryList[index].XVCouName != null)
              ? widget.countryList[index].XVCouName
              : '')
      ],
    );
  }
}

class ProvincePicker extends StatefulWidget {
  final List<Province> provinceList;

  ProvincePicker({Key key, this.provinceList}) : super(key: key);

  @override
  _ProvincePickerState createState() => _ProvincePickerState();
}

class _ProvincePickerState extends State<ProvincePicker> {
  int selectedValue = 0;

  @override
  Widget build(BuildContext context) {
    int row = widget.provinceList.length;
    // TODO: implement build
    return CupertinoPicker(
      /* the rest of the picker */
      scrollController: FixedExtentScrollController(initialItem: selectedValue),
      backgroundColor: Colors.white,
      onSelectedItemChanged: (value) {
        setState(() {
          selectedValue = value;
          globalPvnCode = widget.provinceList[value].XVPvnCode;
          globalPvnName = widget.provinceList[value].XVPvnName;
        });
      },
      itemExtent: 32.0,
      children: [
        for (var index = 0; index < row; index++)
          Text((widget.provinceList[index].XVPvnName != null)
              ? widget.provinceList[index].XVPvnName
              : '')
      ],
    );
  }
}
