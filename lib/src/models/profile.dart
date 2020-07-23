class Country {
  final String XVCouCode;
  final String XVCouName;

  Country({
    this.XVCouCode,
    this.XVCouName,
  });

  factory Country.fromJson(Map<String, dynamic> parsedJson) {
    return Country(
      XVCouCode: parsedJson['XVCouCode'],
      XVCouName: parsedJson['XVCouName'],
    );
  }
}

class Province {
  final String XVPvnCode;
  final String XVPvnName;

  Province({
    this.XVPvnCode,
    this.XVPvnName,
  });

  factory Province.fromJson(Map<String, dynamic> parsedJson) {
    return Province(
      XVPvnCode: parsedJson['XVPvnCode'],
      XVPvnName: parsedJson['XVPvnName'],
    );
  }
}

class RegisterAccountValidate {
  final String status;

  RegisterAccountValidate(
    this.status,
  );

  factory RegisterAccountValidate.fromJson(dynamic parsedJson) {
    return RegisterAccountValidate(
      parsedJson['status'] as String,
    );
  }
}

class PostLoginRegister {
  final String uname;
  final String email;
  final String status;

  PostLoginRegister(
    this.uname,
    this.email,
    this.status,
  );

  factory PostLoginRegister.fromJson(dynamic parsedJson) {
    return PostLoginRegister(
      parsedJson['uname'] as String,
      parsedJson['email'] as String,
      parsedJson['status'] as String,
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["uname"] = uname;
    map["email"] = email;

    return map;
  }
}

class PostRegister {
  final String XVPnrType;
  final String XVCstName;
  final String XVAdsName;
  final String XVAdsPhone1;
  final String XVAdsEmail;
  final String XVAdsCountry;
  final String XVAdsProvince;
  final String TWUser;
  final String status;

  PostRegister(
      this.XVPnrType,
      this.XVCstName,
      this.XVAdsName,
      this.XVAdsPhone1,
      this.XVAdsEmail,
      this.XVAdsCountry,
      this.XVAdsProvince,
      this.TWUser,
      this.status
      );

  factory PostRegister.fromJson(dynamic parsedJson) {
    return PostRegister(
      parsedJson['XVPnrType'] as String,
      parsedJson['XVCstName'] as String,
      parsedJson['XVAdsName'] as String,
      parsedJson['XVAdsPhone1'] as String,
      parsedJson['XVAdsEmail'] as String,
      parsedJson['XVAdsCountry'] as String,
      parsedJson['XVAdsProvince'] as String,
      parsedJson['TWUser'] as String,
      parsedJson['status'] as String,
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["XVPnrType"] = XVPnrType;
    map["XVCstName"] = XVCstName;
    map["XVAdsName"] = XVAdsName;
    map["XVAdsPhone1"] = XVAdsPhone1;
    map["XVAdsEmail"] = XVAdsEmail;
    map["XVAdsCountry"] = XVAdsCountry;
    map["XVAdsProvince"] = XVAdsProvince;
    map["TWUser"] = TWUser;

    return map;
  }
}
