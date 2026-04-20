class QuranAyahModel {
  int? id;
  int? globalAyah;
  int? surahNo;
  int? ayahNo;
  int? page;
  int? juz;
  bool? sajda;
  String? textUthmani;

  QuranAyahModel({
    this.id,
    this.globalAyah,
    this.surahNo,
    this.ayahNo,
    this.page,
    this.juz,
    this.sajda,
    this.textUthmani,
  });

  @override
  String toString() {
    return 'Ayah(id: $id, globalAyah: $globalAyah, surahNo: $surahNo, ayahNo: $ayahNo, page: $page, juz: $juz, sajda: $sajda, textUthmani: $textUthmani)';
  }

  factory QuranAyahModel.fromJson(Map<String, dynamic> json) => QuranAyahModel(
    id: json['id'] as int?,
    globalAyah: json['global_ayah'] as int?,
    surahNo: json['surah_no'] as int?,
    ayahNo: json['ayah_no'] as int?,
    page: json['page'] as int?,
    juz: json['juz'] as int?,
    sajda: json['sajda'] as bool?,
    textUthmani: json['text_uthmani'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'global_ayah': globalAyah,
    'surah_no': surahNo,
    'ayah_no': ayahNo,
    'page': page,
    'juz': juz,
    'sajda': sajda,
    'text_uthmani': textUthmani,
  };
}
