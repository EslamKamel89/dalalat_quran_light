import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WordModel {
  WordModel({this.word_id, this.ayaId, this.word_ar});
  String? word_id;
  String? word_ar;
  String? word_en;
  Color? color;
  int? ayaNo;
  int? page;
  String? sura;
  String? suraName;
  String? text_indopak;
  String? ayaId;
  String? juz;
  String? char_type;
  String? verse_key;
  Color? selectedAyaColor;
  int? line;
  int? position;
  String? tagId;
  String? videoId;
  String? wordVideo;

  bool lastAya() {
    var split = verse_key!.split(':');
    return int.parse(split[split.length]) == ayaNo!;
  }

  bool firstAya() {
    return ayaNo == 1 && position == 1;
  }

  @override
  String toString() {
    return 'WordModel('
        'word_id: $word_id, '
        'word_ar: $word_ar, '
        'word_en: $word_en, '
        'ayaId: $ayaId, '
        'ayaNo: $ayaNo, '
        'position: $position, '
        'line: $line, '
        'page: $page, '
        'suraName: $suraName'
        ')';
  }

  factory WordModel.fromJson(Map<String, dynamic> json) {
    return WordModel(
      ayaId: json['ayaId']?.toString(),
      word_id: json['word_id']?.toString(),
      word_ar: json['word_ar']?.toString(),
    );
  }
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'ayaId': ayaId, 'word_id': word_id, 'word_ar': word_ar};
  }
}
