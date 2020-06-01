class HomeJson {
  final List<ProductGroup> pdt_group;

  HomeJson({this.pdt_group});

  factory HomeJson.fromJson(Map<String, dynamic> parsedJson) {
    return HomeJson(pdt_group: parsedJson['pdt_group']);
  }
}

class ProductGroup {
  final String XVGrpCode;
  final String XVGrpIconFile;
  final String XVGrpBannerFile;
  final String XVGrpBoxFile;
  final String XVGrpColor1;
  final String XVGrpColor2;
  final String XVGrpColor3;
  final String XVGrpColor4;
  final String XVGrpColor5;
  final String XVGrpName_th;
  final String XVGrpName_en;
  final String XBGrpIsActive;
  final String XBGrpIsOnline;
  final String XNGrpSeq;
  final List<SubGroup> subgroup;

  ProductGroup(
      {this.XVGrpCode,
      this.XVGrpIconFile,
      this.XVGrpBannerFile,
      this.XVGrpBoxFile,
      this.XVGrpColor1,
      this.XVGrpColor2,
      this.XVGrpColor3,
      this.XVGrpColor4,
      this.XVGrpColor5,
      this.XVGrpName_th,
      this.XVGrpName_en,
      this.XBGrpIsActive,
      this.XBGrpIsOnline,
      this.XNGrpSeq,
      this.subgroup});

  factory ProductGroup.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['subgroup'] as List;
    List<SubGroup> subGroupList = list.map((i) => SubGroup.fromJson(i)).toList();

    return ProductGroup(
      XVGrpCode: parsedJson['XVGrpCode'],
      XVGrpIconFile: parsedJson['XVGrpIconFile'],
      XVGrpBannerFile: parsedJson['XVGrpBannerFile'],
      XVGrpBoxFile: parsedJson['XVGrpBoxFile'],
      XVGrpColor1: parsedJson['XVGrpColor1'],
      XVGrpColor2: parsedJson['XVGrpColor2'],
      XVGrpColor3: parsedJson['XVGrpColor3'],
      XVGrpColor4: parsedJson['XVGrpColor4'],
      XVGrpColor5: parsedJson['XVGrpColor5'],
      XVGrpName_th: parsedJson['XVGrpName_th'],
      XVGrpName_en: parsedJson['XVGrpName_en'],
      XBGrpIsActive: parsedJson['XBGrpIsActive'],
      XBGrpIsOnline: parsedJson['XBGrpIsOnline'],
      XNGrpSeq: parsedJson['XNGrpSeq'],
      subgroup: subGroupList,
    );
  }
}

class SubGroup {
  final String XVGrpCode;
  final String XVSubCode;
  final String XVSubName_th;
  final String XVSubName_en;
  final String XBSubIsActive;
  final String XBSubIsOnline;
  final String XNSubSeq;
  final String XVImgGroup;
  final String XVImgRefCode;
  final String XNImgSeq;
  final String XVImgFile;

  SubGroup({
    this.XVGrpCode,
    this.XVSubCode,
    this.XVSubName_th,
    this.XVSubName_en,
    this.XBSubIsActive,
    this.XBSubIsOnline,
    this.XNSubSeq,
    this.XVImgGroup,
    this.XVImgRefCode,
    this.XNImgSeq,
    this.XVImgFile,
  });

  factory SubGroup.fromJson(Map<String, dynamic> parsedJson) {
    return SubGroup(
      XVGrpCode: parsedJson['XVGrpCode'],
      XVSubCode: parsedJson['XVSubCode'],
      XVSubName_th: parsedJson['XVSubName_th'],
      XVSubName_en: parsedJson['XVSubName_en'],
      XBSubIsActive: parsedJson['XBSubIsActive'],
      XBSubIsOnline: parsedJson['XBSubIsOnline'],
      XNSubSeq: parsedJson['XNSubSeq'],
      XVImgGroup: parsedJson['XVImgGroup'],
      XVImgRefCode: parsedJson['XVImgRefCode'],
      XNImgSeq: parsedJson['XNImgSeq'],
      XVImgFile: parsedJson['XVImgFile'],
    );
  }
}

class Slide {
  final String XVBanGroup;
  final String XNBanSeq;
  final String XVBanFileName;
  final String XDBanDteStr;
  final String XDBanDteEnd;
  final String XVBanLink;

  Slide({
    this.XVBanGroup,
    this.XNBanSeq,
    this.XVBanFileName,
    this.XDBanDteStr,
    this.XDBanDteEnd,
    this.XVBanLink,
  });

  factory Slide.fromJson(Map<String, dynamic> parsedJson) {
    return Slide(
      XVBanGroup: parsedJson['XVBanGroup'],
      XNBanSeq: parsedJson['XNBanSeq'],
      XVBanFileName: parsedJson['XVBanFileName'],
      XDBanDteStr: parsedJson['XDBanDteStr'],
      XDBanDteEnd: parsedJson['XDBanDteEnd'],
      XVBanLink: parsedJson['XVBanLink'],
    );
  }
}

class NewProduct {
  final String XVPdtCode;
  final String XVPdtName_th;
  final String XVPdtName_en;
  final String XFPdtStdPrice;
  final String XVImgFile;

  NewProduct({
    this.XVPdtCode,
    this.XVPdtName_th,
    this.XVPdtName_en,
    this.XFPdtStdPrice,
    this.XVImgFile,
  });

  factory NewProduct.fromJson(Map<String, dynamic> parsedJson) {
    return NewProduct(
      XVPdtCode: parsedJson['XVPdtCode'],
      XVPdtName_th: parsedJson['XVPdtName_th'],
      XVPdtName_en: parsedJson['XVPdtName_en'],
      XFPdtStdPrice: parsedJson['XFPdtStdPrice'],
      XVImgFile: parsedJson['XVImgFile'],
    );
  }
}

class BestSeller {
  final String XVPdtCode;
  final String XVPdtName_th;
  final String XVPdtName_en;
  final String XFPdtStdPrice;
  final String XVImgFile;

  BestSeller({
    this.XVPdtCode,
    this.XVPdtName_th,
    this.XVPdtName_en,
    this.XFPdtStdPrice,
    this.XVImgFile,
  });

  factory BestSeller.fromJson(Map<String, dynamic> parsedJson) {
    return BestSeller(
      XVPdtCode: parsedJson['XVPdtCode'],
      XVPdtName_th: parsedJson['XVPdtName_th'],
      XVPdtName_en: parsedJson['XVPdtName_en'],
      XFPdtStdPrice: parsedJson['XFPdtStdPrice'],
      XVImgFile: parsedJson['XVImgFile'],
    );
  }
}

class Brand {
  final String XVBndCode;
  final String XVBndName_th;
  final String XVBndName_en;
  final String XVImgFile;

  Brand({
    this.XVBndCode,
    this.XVBndName_th,
    this.XVBndName_en,
    this.XVImgFile
  });

  factory Brand.fromJson(Map<String, dynamic> parsedJson) {
    return Brand(
      XVBndCode: parsedJson['XVBndCode'],
      XVBndName_th: parsedJson['XVBndName_th'],
      XVBndName_en: parsedJson['XVBndName_en'],
      XVImgFile: parsedJson['XVImgFile'],
    );
  }
}

