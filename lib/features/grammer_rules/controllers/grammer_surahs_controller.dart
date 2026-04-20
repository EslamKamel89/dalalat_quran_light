import 'package:dalalat_quran_light/features/grammer_rules/models/grammer_surah_model.dart';
import 'package:dalalat_quran_light/utils/api_service/dio_consumer.dart';
import 'package:dalalat_quran_light/utils/constants.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/servicle_locator.dart';
import 'package:get/get.dart';

abstract class GrammerSurahsState {
  static List<GrammerSurahModel> surahs = [];
}

class GrammerSurahsController extends GetxController {
  String getSurahsEndpoint(int id) => "rules-api/$id?lang_code=AR";
  ResponseEnum responseState = ResponseEnum.initial;

  Future<void> getAllSurahs(int id) async {
    await getAllSurahsApi(id);
    update();
  }

  // void search(String key) {
  //   VideoControllerData.filteredVideosList =
  //       VideoControllerData.allVideos
  //           .where((x) => x.toString().toLowerCase().trim().contains(key.toLowerCase()))
  //           .toList();
  //   update();
  // }

  Future getAllSurahsApi(int id) async {
    const t = 'getAllSurahsApi - GrammerSurahsController';
    GrammerSurahsState.surahs = [];
    DioConsumer dioConsumer = serviceLocator();
    String path = baseUrl() + getSurahsEndpoint(id);
    responseState = ResponseEnum.loading;
    update();
    try {
      final data = await dioConsumer.get(path);
      // List data = jsonDecode(response);
      pr(data, '$t - raw response');

      List<GrammerSurahModel> surahs = data['suras']
          .map<GrammerSurahModel>((json) => GrammerSurahModel.fromJson(json))
          .toList();
      pr(surahs, '$t - parsed response');
      responseState = ResponseEnum.success;
      GrammerSurahsState.surahs = surahs;
      update();
      return;
    } on Exception catch (e) {
      pr('Exception occured: $e', t);
      responseState = ResponseEnum.failed;
      GrammerSurahsState.surahs = [];
      update();
      return;
    }
  }
}
