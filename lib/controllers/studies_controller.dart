import 'dart:convert';

import 'package:dalalat_quran_light/models/study_model.dart';
import 'package:dalalat_quran_light/utils/api_service/dio_consumer.dart';
import 'package:dalalat_quran_light/utils/constants.dart';
import 'package:dalalat_quran_light/utils/is_internet_available.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/servicle_locator.dart';
import 'package:dalalat_quran_light/utils/shared_prefrences_key.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class StudiesData {
  static List<StudyModel> studiesList = [];
  static List<StudyModel> filteredList = [];
}

class StudiesController extends GetxController {
  ResponseEnum responseState = ResponseEnum.initial;
  final studiesIndexEndpoint = "studies";
  DioConsumer dioConsumer = serviceLocator();
  Future<void> allAStudies() async {
    if (await isInternetAvailable()) {
      await allStudiesApi();
      await cacheStudies(models: StudiesData.studiesList);
    } else {
      List<StudyModel> cachedStudies = await getCachedStudies();
      StudiesData.studiesList = cachedStudies;
      StudiesData.filteredList = cachedStudies;
      responseState = ResponseEnum.success;
      update();
      return;
    }
  }

  void search(String key) async {
    if (key == '') {
      StudiesData.filteredList = StudiesData.studiesList;
      update();
      return;
    }
    StudiesData.filteredList = StudiesData.studiesList
        .where((s) => s.name?.contains(key) == true)
        .toList();
    update();
  }

  Future allStudiesApi() async {
    const t = 'allStudiesApi - StudiesController ';
    String path = baseUrl() + studiesIndexEndpoint;
    responseState = ResponseEnum.loading;
    update();
    try {
      final List response = await dioConsumer.get(path);
      pr(response, '$t - raw response');
      List<StudyModel> studies = response
          .map<StudyModel>((json) => StudyModel.fromJson(json))
          .toList();
      pr(studies, '$t - parsed response');
      responseState = ResponseEnum.success;
      StudiesData.studiesList = studies;
      StudiesData.filteredList = studies;
      update();
    } on Exception catch (e) {
      pr('Exception occurred: $e', t);
      responseState = ResponseEnum.failed;
      update();
    }
  }

  Future<void> cacheStudies({required List<StudyModel> models}) async {
    SharedPreferences sharedPreferences = serviceLocator<SharedPreferences>();
    List<String> modelsStr = models.map((m) => jsonEncode(m.toJson())).toList();
    await sharedPreferences.setStringList(ShPrefKey.studies, modelsStr);
  }

  Future<List<StudyModel>> getCachedStudies() async {
    try {
      SharedPreferences sharedPreferences = serviceLocator<SharedPreferences>();
      List<String> modelsStr = sharedPreferences.getStringList(ShPrefKey.studies) ?? [];

      return modelsStr.map((json) => StudyModel.fromJson(jsonDecode(json))).toList();
    } on Exception catch (_) {
      return [];
    }
  }

  @override
  void onClose() {
    // StudiesData.filteredList.clear();
    // StudiesData.studiesList.clear();
    responseState = ResponseEnum.initial;
    update();
    super.onClose();
  }
}
