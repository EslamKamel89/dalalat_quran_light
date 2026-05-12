// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dalalat_quran_light/utils/api_service/dio_consumer.dart';
import 'package:dalalat_quran_light/utils/constants.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/safe_string_map.dart';
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
  Future<Map<String, String>> getExplanation({required String id}) async {
    const t = 'getExplanation - ExplanationController ';
    String path = _domainLink;
    String deviceLocale = 'ar';

    path += "$_ayah/$id/$deviceLocale";

    responseState = ResponseEnum.loading;
    update();

    try {
      final response = await dioConsumer.get(path);

      Map<String, String> explanationMap = safeStringMap(
        jsonDecode(response) as Map<String, dynamic>,
      );
      explanation = explanationMap['explanation'];
      pr(response, t);

      await cacheExplanation(id: id, explanation: explanation ?? '');
      await cacheAyah(id: id, ayah: explanationMap['text_ar'] ?? '');

      responseState = ResponseEnum.success;
      update();

      return explanationMap;
    } on Exception catch (e) {
      pr('Exeption occured: $e', t);

      final cachedExplanation = await getCachedExplanation(id: id);
      final cachedAyah = await getCachedAyah(id: id);

      if (cachedExplanation.isNotEmpty) {
        responseState = ResponseEnum.success;
        update();
        return {'explanation': cachedExplanation, 'text_ar': cachedAyah};
      }

      responseState = ResponseEnum.failed;
      update();
      return {'explanation': "", 'text_ar': ""};
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

  Future<void> cacheAyah({required String id, required String ayah}) async {
    SharedPreferences sharedPreferences = serviceLocator<SharedPreferences>();
    sharedPreferences.setString('$ayahExplanationKey.ayah.$id', ayah);
  }

  Future<String> getCachedAyah({required String id}) async {
    SharedPreferences sharedPreferences = serviceLocator<SharedPreferences>();
    return sharedPreferences.getString('$ayahExplanationKey.ayah.$id') ?? '';
  }
}
