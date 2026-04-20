import 'package:collection/collection.dart';
import 'package:dalalat_quran_light/controllers/similar_word_controller.dart';
import 'package:dalalat_quran_light/models/aya_model.dart';
import 'package:dalalat_quran_light/models/db_word_model.dart';
import 'package:dalalat_quran_light/models/page_ayat_sura_model.dart';
import 'package:dalalat_quran_light/models/similar_word_model.dart';
import 'package:dalalat_quran_light/models/sura_model.dart';
import 'package:dalalat_quran_light/models/sura_search_model.dart';
import 'package:dalalat_quran_light/models/sura_search_result_model.dart';
import 'package:dalalat_quran_light/models/word_model.dart';
import 'package:dalalat_quran_light/utils/api_service/dio_consumer.dart';
import 'package:dalalat_quran_light/utils/constants.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:dalalat_quran_light/utils/servicle_locator.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';

final _t = "DataBaseHelper";

class DataBaseHelper {
  final DioConsumer api = serviceLocator<DioConsumer>();
  final String _baseUrl = "${domainUrl()}api/quran";
  // final String _baseUrl = "http://127.0.0.1:8000/api/quran";
  // final String _baseUrl = "http://10.0.2.2:8000/api/quran";
  static DataBaseHelper? _baseHelper;
  static DataBaseHelper dataBaseInstance() {
    _baseHelper ??= DataBaseHelper();
    return _baseHelper!;
  }

  Future<List<SuraModel>> suraIndex() async {
    final t = "suraIndex - $_t";

    try {
      final response = await api.get("$_baseUrl/sura-index");
      pr(response, t);
      final List<dynamic> list = response["data"];
      return list.map<SuraModel>((json) => SuraModel.fromJson(json)).toList();
    } catch (e) {
      pr(e, t);
      return [];
    }
  }

  Future<String> getSuraById(String id) async {
    final t = "getSuraById - $_t";
    try {
      final response = await api.get("$_baseUrl/sura/$id");
      pr(response, t);
      return response["data"]["sura_ar"] as String;
    } catch (e) {
      pr(e, t);
      return '';
    }
  }

  Future<List<List<WordModel>>> getFull(int page) async {
    final t = "getFull - $_t";
    try {
      final response = await api.get("$_baseUrl/page/$page/full");
      pr(response, t);

      final List list = response["data"];

      final grouped = groupBy(list, (e) => e['line']);
      final List<List<WordModel>> lines = [];

      final sortedKeys = grouped.keys.toList()..sort();

      for (final key in sortedKeys) {
        final List<WordModel> words = [];

        for (final item in grouped[key]!) {
          final wordText = item['word_ar']?.toString() ?? item['ayaNo'].toString();

          words.add(
            WordModel()
              ..word_id = item['word_id']?.toString()
              ..sura = item['sura_id']?.toString()
              ..ayaId = item['ayaId']?.toString()
              ..ayaNo = item['ayaNo']
              ..line = item['line']
              ..position = item['position']
              ..char_type = item['char_type']
              ..word_ar = wordText
              ..tagId = item['tag_id']?.toString()
              ..videoId = item['aya_video_url']?.toString()
              ..wordVideo = item['word_video_url']?.toString()
              ..suraName = item['sura_name']?.toString()
              ..color = item['has_tag'] != null ? Colors.red : Colors.black,
          );
        }

        if (words.isNotEmpty) {
          lines.add(words);
        }
      }

      return lines;
    } catch (e) {
      pr(e, t);
      return [];
    }
  }

  Future<String> getSuraByPage(int suraId) async {
    final t = "getSuraByPage - $_t";
    try {
      final response = await api.get("$_baseUrl/sura/page/$suraId");
      pr(response, t);
      return response["data"]["sura_ar"] as String;
    } catch (e) {
      pr(e, t);
      return "";
    }
  }

  Future<List<PageAyatSuraModel>> pageAyatSura(int page) async {
    final t = "pageAyatSura - $_t";
    try {
      final response = await api.get("$_baseUrl/page/$page/ayat-sura");
      pr(response, t);

      final List list = response["data"];
      return list
          .map<PageAyatSuraModel>(
            (e) => PageAyatSuraModel(e['ayah'].toString(), e['sura_id'].toString()),
          )
          .toList();
    } catch (e) {
      pr(e, t);
      return [];
    }
  }

  Future<String> getJuz(int aya, int sura) async {
    final t = "getJuz - $_t";
    try {
      final response = await api.get("$_baseUrl/juz/$sura/$aya");
      pr(response, t);
      return response["data"]["juz"].toString();
    } catch (e) {
      pr(e, t);
      return "";
    }
  }

  Future<int> getColor(String id) async {
    final t = "getColor - $_t";
    switch (id) {
      case "pageBg":
        return 0;
      case "normalFontColor":
        return 1;
      case "tagWordsColor":
        return 4;
      case "readWordsColor":
        return 3;
      default:
        return 0;
    }
  }

  Future<List<SuraSearchModel>> searchByWord(String key) async {
    final t = "searchByWord - $_t";

    bool isSimilarFound = false;
    SimilarWordModel? similarWordModel;

    for (SimilarWordModel model in SimilarWordData.equalsList) {
      if (key == model.firstWord || key == model.secondWord) {
        isSimilarFound = true;
        similarWordModel = model;
        break;
      }
    }

    try {
      final List<SuraSearchModel> result = [];

      if (isSimilarFound && similarWordModel != null) {
        for (final k in [similarWordModel.firstWord, similarWordModel.secondWord]) {
          final response = await api.get("$_baseUrl/search/$k");
          pr(response, t);

          final List list = response["data"];
          result.addAll(
            list.map((e) {
              e['searchKey'] = key;
              return SuraSearchModel.fromJson(e);
            }),
          );
        }
      } else {
        final response = await api.get("$_baseUrl/search/$key");
        pr(response, t);

        final List list = response["data"];
        result.addAll(
          list.map((e) {
            e['searchKey'] = key;
            return SuraSearchModel.fromJson(e);
          }),
        );
      }

      return result;
    } catch (e) {
      pr(e, t);
      return [];
    }
  }

  Future<List<List<SuraSearchResultModel>>> getDetails(int suraId, String key) async {
    final t = "getDetails - $_t";

    bool isSimilarFound = false;
    SimilarWordModel? similarWordModel;

    for (SimilarWordModel model in SimilarWordData.equalsList) {
      if (key == model.firstWord || key == model.secondWord) {
        isSimilarFound = true;
        similarWordModel = model;
        break;
      }
    }

    try {
      final List<Map<String, dynamic>> merged = [];

      if (isSimilarFound && similarWordModel != null) {
        for (final k in [similarWordModel.firstWord, similarWordModel.secondWord]) {
          final response = await api.get("$_baseUrl/details/$suraId/$k");
          pr(response, t);
          merged.addAll(List<Map<String, dynamic>>.from(response["data"]));
        }
      } else {
        final response = await api.get("$_baseUrl/details/$suraId/$key");
        pr(response, t);
        merged.addAll(List<Map<String, dynamic>>.from(response["data"]));
      }

      final grouped = groupBy(merged, (e) => e['ayat_id']);
      final List<List<SuraSearchResultModel>> result = [];

      final sortedKeys = grouped.keys.toList()..sort();

      for (final ayaKey in sortedKeys) {
        final List<SuraSearchResultModel> singleAya = [];

        for (final item in grouped[ayaKey]!) {
          final model = SuraSearchResultModel.fromJson(item);
          model.ayaId = item['ayaId'];
          model.searchKey = key;
          singleAya.add(model);
        }

        result.add(singleAya);
      }

      return result;
    } catch (e) {
      pr(e, t);
      return [];
    }
  }

  Future<List<AyaModel>> getAyaBySuaId(int suraId) async {
    final t = "getAyaBySuaId - $_t";
    try {
      final response = await api.get("$_baseUrl/ayat/sura/$suraId");
      pr(response, t);

      final List list = response["data"];
      return list.map<AyaModel>((e) => AyaModel.fromJson(e)).toList();
    } catch (e) {
      pr(e, t);
      return <AyaModel>[];
    }
  }

  Future<List<DbWordModel>> getWordByAyahId(int suraId, int ayaId) async {
    final t = "getWordByAyahId - $_t";
    try {
      final response = await api.get("$_baseUrl/words/$suraId/$ayaId");
      pr(response, t);

      final List list = response["data"];
      return list.map<DbWordModel>((e) => DbWordModel.fromJsonOnlyAyaId(e)).toList();
    } catch (e) {
      pr(e, t);
      return <DbWordModel>[];
    }
  }

  Future<String> getAyaTextArByAyaId(int ayaId) async {
    final t = "getAyaTextArByAyaId - $_t";
    try {
      final response = await api.get("$_baseUrl/aya/$ayaId/text-ar");
      pr(response, t);
      return response["data"]["text_ar"].toString();
    } catch (e) {
      pr(e, t);
      return "";
    }
  }

  Future<int> getAyaPage(String ayaId) async {
    final t = "getAyaPage - $_t";
    try {
      final response = await api.get("$_baseUrl/aya/$ayaId/page");
      pr(response, t);
      return response["data"]["page"] as int;
    } catch (e) {
      pr(e, t);
      return 1;
    }
  }

  Future<String> getAyaTextAr(int suraId, int ayaNo, int ayaId) async {
    final t = "getAyaTextAr - $_t";
    try {
      final response = await api.get("$_baseUrl/aya/$ayaId/text-arabic");
      pr(response, t);
      return response["data"]["text_ar"].toString();
    } catch (e) {
      pr(e, t);
      return "";
    }
  }

  Future<int> suraCount(int suraId) async {
    final t = "suraCount - $_t";
    try {
      final response = await api.get("$_baseUrl/sura/$suraId/count");
      pr(response, t);
      return response["data"]["count"] as int;
    } catch (e) {
      pr(e, t);
      return 0;
    }
  }

  String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body!.text).documentElement!.text;
    return parsedString;
  }
}
