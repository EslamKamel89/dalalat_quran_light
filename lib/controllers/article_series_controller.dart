import 'dart:convert';

import 'package:dalalat_quran_light/models/article_series_model.dart';
import 'package:dalalat_quran_light/utils/api_service/dio_consumer.dart';
import 'package:dalalat_quran_light/utils/constants.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/servicle_locator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ArticlesSeriesData {
  static List<ArticleSeriesModel> articleSeries = [];
  static List<ArticleSeriesModel> filteredList = [];
}

class ArticlesSeriesController extends GetxController {
  ResponseEnum responseState = ResponseEnum.initial;
  final articlesSeriesEndpoint = "article-series";
  static const String _cacheKey = 'article_series_cache';
  int page = 0;
  int limit = 5000000;
  bool hasNextPage = true;

  Future<void> getArticleSeries() async {
    try {
      await getArticleSeriesApi();
      await cacheArticleSeries();
    } catch (_) {
      await getCachedArticleSeries();
    }
    update();
  }

  Future<void> getArticleSeriesApi() async {
    const t = "getArticleSeries - ArticlesSeriesController";
    DioConsumer dioConsumer = serviceLocator();
    String deviceLocale = Get.locale?.languageCode ?? 'ar';
    String path = baseUrl() + articlesSeriesEndpoint;

    responseState = ResponseEnum.loading;
    update();

    final response = await dioConsumer.get("$path/0/$limit/$deviceLocale");
    List data = jsonDecode(response);
    pr(data, '$t - raw response');

    if (data.isEmpty) {
      responseState = ResponseEnum.success;
      ArticlesSeriesData.articleSeries = [];
      ArticlesSeriesData.filteredList = [];
      update();
      return;
    }

    List<ArticleSeriesModel> articles = data
        .map<ArticleSeriesModel>((json) => ArticleSeriesModel.fromJson(json))
        .toList();

    pr(articles, '$t - parsed response');

    ArticlesSeriesData.articleSeries = articles;
    ArticlesSeriesData.filteredList = articles;

    responseState = ResponseEnum.success;
    update();
  }

  void search(String key) {
    ArticlesSeriesData.filteredList = ArticlesSeriesData.articleSeries;
    // filteredList.value = articlesList.where(((x) => x.toString().contains(key))).toList();
    ArticlesSeriesData.filteredList = ArticlesSeriesData.articleSeries
        .where(((x) => x.toString().contains(key)))
        .toList();
    update();
  }

  @override
  void onClose() {
    ArticlesSeriesData.filteredList.clear();
    ArticlesSeriesData.articleSeries.clear();
    update();
    super.onClose();
  }

  Future<void> cacheArticleSeries() async {
    final prefs = serviceLocator<SharedPreferences>();

    final List<Map<String, dynamic>> jsonList = ArticlesSeriesData.articleSeries
        .map((e) => e.toJson())
        .toList();

    await prefs.setString(_cacheKey, jsonEncode(jsonList));
  }

  Future<void> getCachedArticleSeries() async {
    final prefs = serviceLocator<SharedPreferences>();

    final String? cached = prefs.getString(_cacheKey);
    if (cached == null) return;

    final List data = jsonDecode(cached);

    final articles = data
        .map<ArticleSeriesModel>((json) => ArticleSeriesModel.fromJson(json))
        .toList();

    ArticlesSeriesData.articleSeries = articles;
    ArticlesSeriesData.filteredList = articles;
  }
}
