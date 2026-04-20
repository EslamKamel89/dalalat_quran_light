// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dalalat_quran_light/utils/api_service/dio_consumer.dart';
import 'package:dalalat_quran_light/utils/constants.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/servicle_locator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExplanationController extends GetxController {
  static final String _domainLink = baseUrl();
  static const String _ayah = "ayah";
  String? explanation;
  ResponseEnum responseState = ResponseEnum.initial;
  final DioConsumer dioConsumer;
  ExplanationController({this.explanation, required this.dioConsumer});
  Future<String?> getExplanation({required String id}) async {
    const t = 'getExplanation - ExplanationController ';
    String path = _domainLink;
    String deviceLocale = 'ar';

    path += "$_ayah/$id/$deviceLocale";

    responseState = ResponseEnum.loading;
    update();

    try {
      final response = await dioConsumer.get(path);

      String? explanation = jsonDecode(response)['explanation'];

      pr(response, t);

      await cacheExplanation(id: id, explanation: explanation ?? '');

      responseState = ResponseEnum.success;
      update();

      return explanation;
    } on Exception catch (e) {
      pr('Exeption occured: $e', t);

      final cached = await getCachedExplanation(id: id);

      if (cached.isNotEmpty) {
        responseState = ResponseEnum.success;
        update();
        return cached;
      }

      responseState = ResponseEnum.failed;
      update();
      return null;
    }
  }

  Future<void> cacheExplanation({required String id, required String explanation}) async {
    SharedPreferences sharedPreferences = serviceLocator<SharedPreferences>();
    sharedPreferences.setString(ayahExplanationKey + id, explanation);
  }

  Future<String> getCachedExplanation({required String id}) async {
    SharedPreferences sharedPreferences = serviceLocator<SharedPreferences>();
    return sharedPreferences.getString(ayahExplanationKey + id) ?? '';
  }
}
