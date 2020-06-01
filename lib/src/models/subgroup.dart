class GroupBanner {
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
  final String XNGrpSeq;
  final String XVSubName_th;
  final String XVSubName_en;
  final String XVImgFile;

  GroupBanner(
      this.XVGrpCode,
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
      this.XNGrpSeq,
      this.XVSubName_th,
      this.XVSubName_en,
      this.XVImgFile);

  factory GroupBanner.fromJson(dynamic parsedJson) {
    return GroupBanner(
      parsedJson['XVGrpCode'] as String,
      parsedJson['XVGrpIconFile'] as String,
      parsedJson['XVGrpBannerFile'] as String,
      parsedJson['XVGrpBoxFile'] as String,
      parsedJson['XVGrpColor1'] as String,
      parsedJson['XVGrpColor2'] as String,
      parsedJson['XVGrpColor3'] as String,
      parsedJson['XVGrpColor4'] as String,
      parsedJson['XVGrpColor5'] as String,
      parsedJson['XVGrpName_th'] as String,
      parsedJson['XVGrpName_en'] as String,
      parsedJson['XNGrpSeq'] as String,
      parsedJson['XVSubName_th'] as String,
      parsedJson['XVSubName_en'] as String,
      parsedJson['XVImgFile'] as String,
    );
  }
}

class Category {
  final String XVCatCode;
  final String XVCatName_th;
  final String XVCatName_en;
  final String XVImgFile;

  Category(
      {this.XVCatCode, this.XVCatName_th, this.XVCatName_en, this.XVImgFile});

  factory Category.fromJson(Map<String, dynamic> parsedJson) {
    return Category(
      XVCatCode: parsedJson['XVCatCode'],
      XVCatName_th: parsedJson['XVCatName_th'],
      XVCatName_en: parsedJson['XVCatName_en'],
      XVImgFile: parsedJson['XVImgFile'],
    );
  }
}
