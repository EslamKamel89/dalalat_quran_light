import 'dart:convert';

import 'package:dalalat_quran_light/models/tag_model.dart';
import 'package:dalalat_quran_light/utils/api_service/dio_consumer.dart';
import 'package:dalalat_quran_light/utils/constants.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/servicle_locator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetTagController extends GetxController {
  ResponseEnum responseState = ResponseEnum.initial;

  final getTagEndpoint = "get-tag";

  Future<TagModel?> getTag({required int id, String locale = 'ar'}) async {
    return await getTagApi(id: id, locale: locale);
  }

  Future<TagModel?> getTagApi({required int id, String locale = 'ar'}) async {
    const t = 'getTagApi - GetTagController';
    DioConsumer dioConsumer = serviceLocator();
    String path = baseUrl() + getTagEndpoint;

    responseState = ResponseEnum.loading;
    update();

    try {
      final response = await dioConsumer.get("$path/$id/$locale");

      Map<String, dynamic> data = jsonDecode(response);
      pr(data, '$t - raw response');

      TagModel tag = TagModel.fromJson(data);
      pr(tag, '$t - parsed response');

      await cacheTag(tagModel: tag);

      responseState = ResponseEnum.success;
      update();

      return tag;
    } on Exception catch (e) {
      pr('Exception occured: $e', t);

      final cached = await getCachedTag(id: id.toString());

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

  Future<void> cacheTag({required TagModel tagModel}) async {
    SharedPreferences sharedPreferences = serviceLocator<SharedPreferences>();

    sharedPreferences.setString(
      tagDetailsKey + tagModel.id.toString(),
      jsonEncode(tagModel.toJson()),
    );
  }

  Future<TagModel?> getCachedTag({required String id}) async {
    SharedPreferences sharedPreferences = serviceLocator<SharedPreferences>();
    final String? cached = sharedPreferences.getString(tagDetailsKey + id);
    if (cached == null || cached.isEmpty) return null;
    return TagModel.fromJson(jsonDecode(cached));
  }
}
