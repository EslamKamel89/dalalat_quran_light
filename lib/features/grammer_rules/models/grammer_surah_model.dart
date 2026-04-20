class GrammerSurahModel {
  int? suraId;
  String? suraAr;

  GrammerSurahModel({this.suraId, this.suraAr});

  @override
  String toString() => 'GrammerSurahModel(suraId: $suraId, suraAr: $suraAr)';

  factory GrammerSurahModel.fromJson(Map<String, dynamic> json) {
    return GrammerSurahModel(
      suraId: json['sura_id'] as int?,
      suraAr: json['sura_ar'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'sura_id': suraId, 'sura_ar': suraAr};
}
