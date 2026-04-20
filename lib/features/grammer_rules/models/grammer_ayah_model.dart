class GrammerAyahModel {
  int? id;
  int? suraId;
  String? suraAr;
  int? ayaId;
  String? textAr;
  String? nameAr;
  int? ruleId;
  String? symbol;

  GrammerAyahModel({
    this.id,
    this.suraId,
    this.suraAr,
    this.ayaId,
    this.textAr,
    this.nameAr,
    this.ruleId,
    this.symbol,
  });

  @override
  String toString() {
    return 'GrammerAyahModel(id: $id, suraId: $suraId, suraAr: $suraAr, ayaId: $ayaId, textAr: $textAr, nameAr: $nameAr, ruleId: $ruleId, symbol: $symbol)';
  }

  factory GrammerAyahModel.fromJson(Map<String, dynamic> json) {
    return GrammerAyahModel(
      id: json['id'] as int?,
      suraId: json['sura_id'] as int?,
      suraAr: json['sura_ar'] as String?,
      ayaId: json['aya_id'] as int?,
      textAr: json['text_ar'] as String?,
      nameAr: json['name_ar'] as String?,
      ruleId: json['rule_id'] as int?,
      symbol: json['symbol'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'sura_id': suraId,
    'sura_ar': suraAr,
    'aya_id': ayaId,
    'text_ar': textAr,
    'name_ar': nameAr,
    'rule_id': ruleId,
    'symbol': symbol,
  };
}
