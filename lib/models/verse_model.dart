class VerseModel {
  int? id;
  int? tagId;
  int? wordId;
  String? wordAr;
  int? suraId;
  int? ayatId;
  String? suraAr;
  int? ayah;
  String? ayahText;
  String? tagText;

  VerseModel({
    this.id,
    this.tagId,
    this.wordId,
    this.wordAr,
    this.suraId,
    this.ayatId,
    this.suraAr,
    this.ayah,
    this.ayahText,
    this.tagText,
  });

  @override
  String toString() {
    return 'VerseModel(id: $id, tagId: $tagId, wordId: $wordId, wordAr: $wordAr, suraId: $suraId, ayatId: $ayatId, suraAr: $suraAr, ayah: $ayah, ayahText: $ayahText, tagText: $tagText)';
  }

  factory VerseModel.fromJson(Map<String, dynamic> json) => VerseModel(
    id: json['id'] as int?,
    tagId: json['tag_id'] as int?,
    wordId: json['word_id'] as int?,
    wordAr: json['word_ar'] as String?,
    suraId: json['sura_id'] as int?,
    ayatId: json['ayat_id'] as int?,
    suraAr: json['sura_ar'] as String?,
    ayah: json['ayah'] as int?,
    ayahText: json['ayah_text'] as String?,
    tagText: json['tag_text'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'tag_id': tagId,
    'word_id': wordId,
    'word_ar': wordAr,
    'sura_id': suraId,
    'ayat_id': ayatId,
    'sura_ar': suraAr,
    'ayah': ayah,
    'ayah_text': ayahText,
    'tag_text': tagText,
  };

  VerseModel copyWith({
    int? id,
    int? tagId,
    int? wordId,
    String? wordAr,
    int? suraId,
    int? ayatId,
    String? suraAr,
    int? ayah,
    String? ayahText,
    String? tagText,
  }) {
    return VerseModel(
      id: id ?? this.id,
      tagId: tagId ?? this.tagId,
      wordId: wordId ?? this.wordId,
      wordAr: wordAr ?? this.wordAr,
      suraId: suraId ?? this.suraId,
      ayatId: ayatId ?? this.ayatId,
      suraAr: suraAr ?? this.suraAr,
      ayah: ayah ?? this.ayah,
      ayahText: ayahText ?? this.ayahText,
      tagText: tagText ?? this.tagText,
    );
  }
}
