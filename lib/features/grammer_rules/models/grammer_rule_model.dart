class GrammarRuleModel {
  int? id;
  String? nameAr;

  GrammarRuleModel({this.id, this.nameAr});

  @override
  String toString() => 'GrammerRuleModel(id: $id, nameAr: $nameAr)';

  factory GrammarRuleModel.fromJson(Map<String, dynamic> json) {
    return GrammarRuleModel(
      id: json['id'] as int?,
      nameAr: json['name_ar'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name_ar': nameAr};
}
