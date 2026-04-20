import 'dart:convert';

import 'package:dalalat_quran_light/dialogs/custom_snack_bar.dart';
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

class GetStudyController extends GetxController {
  ResponseEnum responseState = ResponseEnum.initial;

  final getStudyEndpoint = "studies";

  Future<StudyModel?> getStudy({required int id}) async {
    if (!(await isInternetAvailable())) {
      showCustomSnackBarNoInternet();
      return getCachedStudy(id: id.toString());
    }
    update();
    return await getStudyApi(id: id);
  }

  Future<StudyModel?> getStudyApi({required int id}) async {
    const t = 'getStudyApi - GetStudyController';
    DioConsumer dioConsumer = serviceLocator();
    String path = baseUrl() + getStudyEndpoint;
    responseState = ResponseEnum.loading;
    update();
    try {
      final Map<String, dynamic> response = await dioConsumer.get("$path/$id");
      pr(response, '$t - raw response');
      StudyModel model = StudyModel.fromJson(response);
      pr(model, '$t - parsed response');
      responseState = ResponseEnum.success;
      cacheStudy(studyModel: model);
      update();
      return model;
    } on Exception catch (e) {
      pr('Exception occured: $e', t);
      responseState = ResponseEnum.failed;
      update();
      return null;
    }
  }

  Future<void> cacheStudy({required StudyModel studyModel}) async {
    SharedPreferences sharedPreferences = serviceLocator<SharedPreferences>();
    sharedPreferences.setString(
      ShPrefKey.study + studyModel.id.toString(),
      jsonEncode(studyModel.toJson()),
    );
  }

  Future<StudyModel?> getCachedStudy({required String id}) async {
    SharedPreferences sharedPreferences = serviceLocator<SharedPreferences>();
    final key = ShPrefKey.study + id;
    try {
      return StudyModel.fromJson(jsonDecode(sharedPreferences.getString(key) ?? ''));
    } catch (e) {
      return null;
    }
  }
}
