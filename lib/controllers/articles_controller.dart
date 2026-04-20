import 'dart:convert';

import 'package:dalalat_quran_light/models/article_model.dart';
import 'package:dalalat_quran_light/utils/api_service/dio_consumer.dart';
import 'package:dalalat_quran_light/utils/constants.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/servicle_locator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ArticlesData {
  static List articlesList = [];
  static List filteredList = [];
}

class ArticlesController extends GetxController {
  ResponseEnum responseState = ResponseEnum.initial;
  final articlesIndexEndpoint = "articles";
  final articlesSearchEndPoint = "articles-search";
  static const String _articlesCacheKey = 'articles_cache';
  bool isSearching = false;
  DioConsumer dioConsumer = serviceLocator();
  Future<void> allArticles() async {
    await allArticlesApiPaginate();
  }

  void search(String key) async {
    const t = 'search - ArticlesController ';
    String deviceLocale = Get.locale?.languageCode ?? 'ar';
    String path = baseUrl() + articlesSearchEndPoint;
    List tempArticleList = [];
    if (key == '') {
      ArticlesData.filteredList = ArticlesData.articlesList;
      update();
      return;
    }
    if (key.length % 2 == 0 && !isSearching) {
      isSearching = true;
      try {
        responseState = ResponseEnum.loading;
        update();
        final response = await dioConsumer.get("$path/0/1000/$deviceLocale/$key");
        isSearching = false;
        List data = jsonDecode(response);
        pr(data, '$t - raw response');
        if (data.isEmpty) {
          responseState = ResponseEnum.success;
          tempArticleList = [];
        } else {
          List<ArticleModel> articles =
              data.map<ArticleModel>((json) => ArticleModel.fromJson(json)).toList();
          pr(articles, '$t - parsed response');
          responseState = ResponseEnum.success;
          tempArticleList = articles;
        }
        ArticlesData.filteredList = [];
        ArticlesData.filteredList.addAll(tempArticleList);
        update();
      } on Exception catch (e) {
        pr('Exception occured: $e', t);
        isSearching = false;
        responseState = ResponseEnum.failed;
        update();
      }
    }
  }

  Future allArticlesApiPaginate() async {
    const t = 'allArticlesApiPaginate - ArticlesController ';
    String deviceLocale = Get.locale?.languageCode ?? 'ar';
    String path = baseUrl() + articlesIndexEndpoint;
    responseState = ResponseEnum.loading;
    update();
    try {
      responseState = ResponseEnum.loading;
      update();
      final response = await dioConsumer.get("$path/0/999999/$deviceLocale");
      List data = jsonDecode(response);
      pr(data, '$t - raw response');

      List<ArticleModel> articles =
          data.map<ArticleModel>((json) => ArticleModel.fromJson(json)).toList();
      pr(articles, '$t - parsed response');
      responseState = ResponseEnum.success;
      ArticlesData.articlesList = articles;
      ArticlesData.filteredList = articles;
      await _cacheArticles(articles);
      update();
    } on Exception catch (e) {
      pr('Exception occured: $e', t);
      final cachedArticles = _getCachedArticles();
      if (cachedArticles.isNotEmpty) {
        ArticlesData.articlesList = cachedArticles;
        ArticlesData.filteredList = cachedArticles;
        responseState = ResponseEnum.success;
      } else {
        responseState = ResponseEnum.failed;
      }
      update();
    }
  }

  @override
  void onClose() {
    ArticlesData.filteredList.clear();
    ArticlesData.articlesList.clear();
    update();
    super.onClose();
  }

  Future<void> _cacheArticles(List<ArticleModel> articles) async {
    final prefs = serviceLocator<SharedPreferences>();

    final List<Map<String, dynamic>> jsonList = articles.map((e) => e.toJson()).toList();

    await prefs.setString(_articlesCacheKey, jsonEncode(jsonList));
  }

  List<ArticleModel> _getCachedArticles() {
    final prefs = serviceLocator<SharedPreferences>();

    final String? cached = prefs.getString(_articlesCacheKey);
    if (cached == null) return [];

    final List data = jsonDecode(cached);

    return data.map<ArticleModel>((json) => ArticleModel.fromJson(json)).toList();
  }
}
