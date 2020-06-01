class CategoryDetail {
  final String XVGrpCode;
  final String XVSubCode;
  final String XVGrpName_th;
  final String XVGrpName_en;
  final String XVSubName_th;
  final String XVSubName_en;
  final String XVCatName_th;
  final String XVCatName_en;

  CategoryDetail(
    this.XVGrpCode,
    this.XVSubCode,
    this.XVGrpName_th,
    this.XVGrpName_en,
    this.XVSubName_th,
    this.XVSubName_en,
    this.XVCatName_th,
    this.XVCatName_en,
  );

  factory CategoryDetail.fromJson(dynamic parsedJson) {
    return CategoryDetail(
      parsedJson['XVGrpCode'] as String,
      parsedJson['XVSubCode'] as String,
      parsedJson['XVGrpName_th'] as String,
      parsedJson['XVGrpName_en'] as String,
      parsedJson['XVSubName_th'] as String,
      parsedJson['XVSubName_en'] as String,
      parsedJson['XVCatName_th'] as String,
      parsedJson['XVCatName_en'] as String,
    );
  }
}

class ProductList {
  final String XBPdtIsModel;
  final String XVPdtCode;
  final String XVModCode;
  final String XVModName_th;
  final String XVModName_en;
  final String XVPdtName_th;
  final String XVPdtName_en;
  final String XFPdtStdPrice;
  final String pdtImg;
  final String bndImg;
  final String modImg;

  ProductList({
    this.XBPdtIsModel,
    this.XVPdtCode,
    this.XVModCode,
    this.XVModName_th,
    this.XVModName_en,
    this.XVPdtName_th,
    this.XVPdtName_en,
    this.XFPdtStdPrice,
    this.pdtImg,
    this.bndImg,
    this.modImg,
  });

  factory ProductList.fromJson(dynamic parsedJson) {
    return ProductList(
      XBPdtIsModel: parsedJson['XBPdtIsModel'],
      XVPdtCode: parsedJson['XVPdtCode'],
      XVModCode: parsedJson['XVModCode'],
      XVModName_th: parsedJson['XVModName_th'],
      XVModName_en: parsedJson['XVModName_en'],
      XVPdtName_th: parsedJson['XVPdtName_th'],
      XVPdtName_en: parsedJson['XVPdtName_en'],
      XFPdtStdPrice: parsedJson['XFPdtStdPrice'],
      pdtImg: parsedJson['pdtImg'],
      bndImg: parsedJson['bndImg'],
      modImg: parsedJson['modImg'],
    );
  }
}

class BrandList {
  final String XVBndCode;
  final String XVBndName_th;
  final String XVBndName_en;

  BrandList({
    this.XVBndCode,
    this.XVBndName_th,
    this.XVBndName_en,
  });

  factory BrandList.fromJson(dynamic parsedJson) {
    return BrandList(
      XVBndCode: parsedJson['XVBndCode'],
      XVBndName_th: parsedJson['XVBndName_th'],
      XVBndName_en: parsedJson['XVBndName_en'],
    );
  }
}
