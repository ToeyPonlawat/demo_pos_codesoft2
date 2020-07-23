import 'dart:convert';

Cart clientFromJson(String str) {
  final jsonData = json.decode(str);
  return Cart.fromMap(jsonData);
}

String clientToJson(Cart data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Cart {
  String XVBarCode;
  String XVBarName;
  String XVBarNameOth;
  String XFBarRetPri1;
  int XIQty;

  Cart({
    this.XVBarCode,
    this.XVBarName,
    this.XVBarNameOth,
    this.XFBarRetPri1,
    this.XIQty,
  });

  factory Cart.fromMap(Map<String, dynamic> json) => new Cart(
    XVBarCode: json["XVBarCode"],
    XVBarName: json["XVBarName"],
    XVBarNameOth: json["XVBarNameOth"],
    XFBarRetPri1: json["XFBarRetPri1"],
    XIQty: json["XIQty"],
  );

  Map<String, dynamic> toMap() => {
    "XVBarCode": XVBarCode,
    "XVBarName": XVBarName,
    "XVBarNameOth": XVBarNameOth,
    "XFBarRetPri1": XFBarRetPri1,
    "XIQty": XIQty,
  };
}

class CartQuery {
  String XVPdtCode;
  String XVPdtName_th;
  String XVPdtName_en;
  String XFPdtStdPrice;
  String XFPdtFactor;
  String XNPdtWShipDay;
  String XVUntName_th;
  String XVUntName_en;
  String pdtImg;
  String bndImg;

  CartQuery({
    this.XVPdtCode,
    this.XVPdtName_th,
    this.XVPdtName_en,
    this.XFPdtStdPrice,
    this.XFPdtFactor,
    this.XNPdtWShipDay,
    this.XVUntName_th,
    this.XVUntName_en,
    this.pdtImg,
    this.bndImg,
  });

  factory CartQuery.fromJson(Map<String, dynamic> parsedJson) {
    return CartQuery(
      XVPdtCode: parsedJson['XVPdtCode'],
      XVPdtName_th: parsedJson['XVPdtName_th'],
      XVPdtName_en: parsedJson['XVPdtName_en'],
      XFPdtStdPrice: parsedJson['XFPdtStdPrice'],
      XFPdtFactor: parsedJson['XFPdtFactor'],
      XNPdtWShipDay: parsedJson['XNPdtWShipDay'],
      XVUntName_th: parsedJson['XVUntName_th'],
      XVUntName_en: parsedJson['XVUntName_en'],
      pdtImg: parsedJson['pdtImg'],
      bndImg: parsedJson['bndImg'],
    );
  }
}


class CartNoti {
  int XIQty;

  CartNoti({
    this.XIQty,
  });

  factory CartNoti.fromMap(Map<String, dynamic> json) => new CartNoti(
    XIQty: json["XIQty"],
  );

  Map<String, dynamic> toMap() => {
    "XIQty": XIQty,
  };
}