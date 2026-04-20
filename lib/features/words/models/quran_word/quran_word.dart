import 'package:dalalat_quran_light/features/words/models/quran_word/quran_ayah.dart';

class QuranWordModel {
  int? id;
  int? quranAyahId;
  String? oldAyahId;
  String? tokenUthmani;
  String? root;
  QuranAyahModel? ayah;

  QuranWordModel({
    this.id,
    this.quranAyahId,
    this.oldAyahId,
    this.tokenUthmani,
    this.root,
    this.ayah,
  });

  @override
  String toString() {
    return 'QuranWord(id: $id, quranAyahId: $quranAyahId, oldAyahId: $oldAyahId, tokenUthmani: $tokenUthmani, root: $root, ayah: $ayah)';
  }

  factory QuranWordModel.fromJson(Map<String, dynamic> json) => QuranWordModel(
    id: json['id'] as int?,
    quranAyahId: json['quran_ayah_id'] as int?,
    oldAyahId: json['old_ayah_id'] as String?,
    tokenUthmani: json['token_uthmani'] as String?,
    root: json['root'] as String?,
    ayah: json['ayah'] == null
        ? null
        : QuranAyahModel.fromJson(json['ayah'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'quran_ayah_id': quranAyahId,
    'old_ayah_id': oldAyahId,
    'token_uthmani': tokenUthmani,
    'root': root,
    'ayah': ayah?.toJson(),
  };
}
