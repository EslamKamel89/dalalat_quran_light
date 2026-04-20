import 'dart:convert';

import 'package:dalalat_quran_light/models/word_model.dart';
import 'package:dalalat_quran_light/utils/api_service/dio_consumer.dart';
import 'package:dalalat_quran_light/utils/constants.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:dalalat_quran_light/utils/servicle_locator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WordTagController extends GetxController {
  final wordTagEndpoint = "pagetags";
  Future<Map<int, List>> geWordTagsMap({required List<int?> wordsId}) async {
    const t = 'geWordTagsMap - WordTagController';
    pr(wordsId, t);

    final cacheKey = _buildCacheKey(wordsId);

    DioConsumer dioConsumer = serviceLocator();
    String path = baseUrl() + wordTagEndpoint;

    try {
      final response = await dioConsumer.post(path, data: {"words": wordsId});

      Map<String, dynamic>? wordTag = jsonDecode(response);

      if (wordTag == null || wordTag.isEmpty) {
        update();
        return {};
      }

      Map<int, List> data = wordTag.map((key, value) => MapEntry(int.parse(key), value as List));

      pr(data, '$t - raw response');

      await cacheWordTag(key: cacheKey, wordTagMap: data);

      update();
      return data;
    } on Exception catch (e) {
      pr('Exception occured: $e', t);

      final cached = await getCachedWordTag(key: cacheKey);

      update();
      return cached;
    }
  }

  List<int?> getWordIds({required List<List<WordModel>> pageLines}) {
    List<int> wordsId = [];
    for (List<WordModel> pageLine in pageLines) {
      for (WordModel word in pageLine) {
        int id;
        try {
          id = int.parse(word.word_id!);
          wordsId.add(id);
        } catch (_) {}
      }
    }
    // pr(wordsId, 'getWordsId - WordTagController');
    return wordsId;
  }

  Future<void> cacheWordTag({required String key, required Map<int, List> wordTagMap}) async {
    final jsonMap = wordTagMap.map((k, v) => MapEntry(k.toString(), v));

    SharedPreferences sharedPreferences = serviceLocator<SharedPreferences>();

    await sharedPreferences.setString(key, jsonEncode(jsonMap));
  }

  Future<Map<int, List>> getCachedWordTag({required String key}) async {
    try {
      SharedPreferences sharedPreferences = serviceLocator<SharedPreferences>();

      final String? jsonMap = sharedPreferences.getString(key);

      if (jsonMap == null || jsonMap.isEmpty) return {};

      return (jsonDecode(jsonMap) as Map<String, dynamic>).map(
        (k, v) => MapEntry(int.parse(k), v as List),
      );
    } catch (_) {
      return {};
    }
  }

  void updateWordColor() {
    update();
  }

  String _buildCacheKey(List<int?> wordsId) {
    final ids = wordsId.whereType<int>().toList()..sort();
    return wordTagKey + ids.join('_');
  }
}
