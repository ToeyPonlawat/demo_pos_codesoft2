class ProductDetail {
  String XVPdtCode;
  String XVPdtName_th;
  String XVPdtName_en;
  String XFPdtStdPrice;
  String XFPdtFactor;
  String XNPdtWShipDay;
  String XVUntName_th;
  String XVUntName_en;
  String XVPdtWPdf;
  String XVMdlCodeSpl;
  String XVPdtWDesc_th;
  String XVPdtWDesc_en;
  String pdtImg;
  String bndImg;

  ProductDetail(
    this.XVPdtCode,
    this.XVPdtName_th,
    this.XVPdtName_en,
    this.XFPdtStdPrice,
    this.XFPdtFactor,
    this.XNPdtWShipDay,
    this.XVUntName_th,
    this.XVUntName_en,
    this.XVPdtWPdf,
    this.XVMdlCodeSpl,
    this.XVPdtWDesc_th,
    this.XVPdtWDesc_en,
    this.pdtImg,
    this.bndImg,
  );

  factory ProductDetail.fromJson(dynamic parsedJson) {
    return ProductDetail(
      parsedJson['XVPdtCode'] as String,
      parsedJson['XVPdtName_th'] as String,
      parsedJson['XVPdtName_en'] as String,
      parsedJson['XFPdtStdPrice'] as String,
      parsedJson['XFPdtFactor'] as String,
      parsedJson['XNPdtWShipDay'] as String,
      parsedJson['XVUntName_th'] as String,
      parsedJson['XVUntName_en'] as String,
      parsedJson['XVPdtWPdf'] as String,
      parsedJson['XVMdlCodeSpl'] as String,
      parsedJson['XVPdtWDesc_th'] as String,
      parsedJson['XVPdtWDesc_en'] as String,
      parsedJson['pdtImg'] as String,
      parsedJson['bndImg'] as String,
    );
  }
}

class ProductImage {
  final String XVBarCode;
  final String XIBarSeqNo;
  final String XVBarImgFile;

  ProductImage(
      {this.XVBarCode, this.XIBarSeqNo, this.XVBarImgFile});

  factory ProductImage.fromJson(Map<String, dynamic> parsedJson) {
    return ProductImage(
      XVBarCode: parsedJson['XVBarCode'],
      XIBarSeqNo: parsedJson['XIBarSeqNo'],
      XVBarImgFile: parsedJson['XVBarImgFile'],
    );
  }
}

class ModelList {
  final String XVPdtCode;
  final String XVSkuCode;
  final String XVPdtSpec;
  final String XFPdtStdPrice;

  ModelList(
      {this.XVPdtCode, this.XVSkuCode, this.XVPdtSpec, this.XFPdtStdPrice});

  factory ModelList.fromJson(Map<String, dynamic> parsedJson) {
    return ModelList(
      XVPdtCode: parsedJson['XVPdtCode'],
      XVSkuCode: parsedJson['XVSkuCode'],
      XVPdtSpec: parsedJson['XVPdtSpec'],
      XFPdtStdPrice: parsedJson['XFPdtStdPrice'],
    );
  }
}

