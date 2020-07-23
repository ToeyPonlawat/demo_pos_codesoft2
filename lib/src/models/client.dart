import 'dart:convert';

Client clientFromJson(String str) {
  final jsonData = json.decode(str);
  return Client.fromMap(jsonData);
}

String clientToJson(Client data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Client {
  String XVConCode;
  String XVUser;
  String XVName;
  String XVEmail;

  Client({
    this.XVConCode,
    this.XVUser,
    this.XVName,
    this.XVEmail,
  });

  factory Client.fromMap(Map<String, dynamic> json) => new Client(
    XVConCode: json["XVConCode"],
    XVUser: json["XVUser"],
    XVName: json["XVName"],
    XVEmail: json["XVEmail"],
  );

  Map<String, dynamic> toMap() => {
    "XVConCode": XVConCode,
    "XVUser": XVUser,
    "XVName": XVName,
    "XVEmail": XVEmail,
  };
}

