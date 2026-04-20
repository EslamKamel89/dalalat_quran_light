import 'package:dalalat_quran_light/features/grammer_rules/models/grammer_ayah_model.dart';
import 'package:dalalat_quran_light/utils/api_service/dio_consumer.dart';
import 'package:dalalat_quran_light/utils/constants.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/servicle_locator.dart';
import 'package:get/get.dart';

abstract class GrammerAyahsState {
  static List<GrammerAyahModel> ayahs = [];
}

class GrammerAyahsController extends GetxController {
  String getAyahsEndpoint(int ruleId, int surahId) => "rules-api/$surahId/$ruleId?lang_code=AR";
  ResponseEnum responseState = ResponseEnum.initial;

  Future<void> getAllAyahs(int ruleId, int surahId) async {
    await getAllAyahsApi(ruleId, surahId);
    update();
  }

  // void search(String key) {
  //   VideoControllerData.filteredVideosList =
  //       VideoControllerData.allVideos
  //           .where((x) => x.toString().toLowerCase().trim().contains(key.toLowerCase()))
  //           .toList();
  //   update();
  // }

  Future getAllAyahsApi(int ruleId, int surahId) async {
    const t = 'getAllAyahsApi - GrammerAyahsController';
    GrammerAyahsState.ayahs = [];
    DioConsumer dioConsumer = serviceLocator();
    String path = baseUrl() + getAyahsEndpoint(ruleId, surahId);
    responseState = ResponseEnum.loading;
    update();
    try {
      final data = await dioConsumer.get(path);
      // List data = jsonDecode(response);
      pr(data, '$t - raw response');

      List<GrammerAyahModel> ayahs = data['ayat']
          .map<GrammerAyahModel>((json) => GrammerAyahModel.fromJson(json))
          .toList();
      pr(ayahs, '$t - parsed response');
      responseState = ResponseEnum.success;
      GrammerAyahsState.ayahs = ayahs;
      update();
      return;
    } on Exception catch (e) {
      pr('Exception occured: $e', t);
      responseState = ResponseEnum.failed;
      GrammerAyahsState.ayahs = [];
      update();
      return;
    }
  }
}
