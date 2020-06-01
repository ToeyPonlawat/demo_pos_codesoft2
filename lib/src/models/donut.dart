class DonutGroup {
  final String XVGrpCode;
  final String XVGrpName_th;
  final String XVGrpName_en;
  final String XNGrpSeq;
  final List<DonutSubGroup> SubGrp;

  DonutGroup(
      {this.XVGrpCode,
      this.XVGrpName_th,
      this.XVGrpName_en,
      this.XNGrpSeq,
      this.SubGrp});

  factory DonutGroup.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['SubGrp'] as List;
    List<DonutSubGroup> subGroupList =
        list.map((i) => DonutSubGroup.fromJson(i)).toList();

    return DonutGroup(
      XVGrpCode: parsedJson['XVGrpCode'],
      XVGrpName_th: parsedJson['XVGrpName_th'],
      XVGrpName_en: parsedJson['XVGrpName_en'],
      XNGrpSeq: parsedJson['XNGrpSeq'],
      SubGrp: subGroupList,
    );
  }
}

class DonutSubGroup {
  final String XVSubCode;
  final String XVSubName_th;
  final String XVSubName_en;
  final List<DonutCat> Cats;

  DonutSubGroup(
      {this.XVSubCode,
        this.XVSubName_th,
        this.XVSubName_en,
        this.Cats});

  factory DonutSubGroup.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['Cats'] as List;
    List<DonutCat> catsList =
    list.map((i) => DonutCat.fromJson(i)).toList();

    return DonutSubGroup(
      XVSubCode: parsedJson['XVSubCode'],
      XVSubName_th: parsedJson['XVSubName_th'],
      XVSubName_en: parsedJson['XVSubName_en'],
      Cats: catsList,
    );
  }
}


class DonutCat {
  final String XVCatCode;
  final String XVCatName_th;
  final String XVCatName_en;

  DonutCat(
      {this.XVCatCode,
        this.XVCatName_th,
        this.XVCatName_en});

  factory DonutCat.fromJson(Map<String, dynamic> parsedJson) {

    return DonutCat(
      XVCatCode: parsedJson['XVCatCode'],
      XVCatName_th: parsedJson['XVCatName_th'],
      XVCatName_en: parsedJson['XVCatName_en'],
    );
  }
}

