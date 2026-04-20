import 'dart:convert';

import 'package:dalalat_quran_light/models/article_model.dart';
import 'package:dalalat_quran_light/utils/api_service/dio_consumer.dart';
import 'package:dalalat_quran_light/utils/constants.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/servicle_locator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetArticleController extends GetxController {
  ResponseEnum responseState = ResponseEnum.initial;

  final getArticleEndpoint = "get-article";

  Future<ArticleModel?> getArticle({required int id}) async {
    update();
    return await getArticleApi(id: id);
  }

  Future<ArticleModel?> getArticleApi({required int id}) async {
    const t = 'getArticleApi - GetArticleController';
    DioConsumer dioConsumer = serviceLocator();
    String path = baseUrl() + getArticleEndpoint;
    String deviceLocale = Get.locale?.languageCode ?? 'ar';
    responseState = ResponseEnum.loading;
    update();
    try {
      final response = await dioConsumer.get("$path/$id/$deviceLocale");
      Map<String, dynamic> data = jsonDecode(response);
      pr(data, '$t - raw response');
      ArticleModel article = ArticleModel.fromJson(data);
      pr(article, '$t - parsed response');
      responseState = ResponseEnum.success;
      await cacheArticle(articleModel: article);
      update();
      return article;
    } on Exception catch (e) {
      pr('Exception occured: $e', t);
      final cached = await getCachedArticle(id: id.toString());
      if (cached != null) {
        responseState = ResponseEnum.success;
        update();
        return cached;
      }
      responseState = ResponseEnum.failed;
      update();
      return null;
    }
  }

  Future<void> cacheArticle({required ArticleModel articleModel}) async {
    SharedPreferences sharedPreferences = serviceLocator<SharedPreferences>();
    sharedPreferences.setString(
      articleDetailsKey + articleModel.id.toString(),
      jsonEncode(articleModel.toJson()),
    );
  }

  Future<ArticleModel?> getCachedArticle({required String id}) async {
    SharedPreferences sharedPreferences = serviceLocator<SharedPreferences>();
    final String? cached = sharedPreferences.getString(articleDetailsKey + id);
    if (cached == null || cached.isEmpty) return null;
    return ArticleModel.fromJson(jsonDecode(cached));
  }
}
