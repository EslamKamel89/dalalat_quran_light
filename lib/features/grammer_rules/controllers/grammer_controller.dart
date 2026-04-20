import 'package:dalalat_quran_light/features/grammer_rules/models/grammer_rule_model.dart';
import 'package:dalalat_quran_light/utils/api_service/dio_consumer.dart';
import 'package:dalalat_quran_light/utils/constants.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/servicle_locator.dart';
import 'package:get/get.dart';

abstract class GrammerRulesState {
  static List<GrammarRuleModel> rules = [];
}

class GrammerRulesController extends GetxController {
  String getRulesEndpoint = 'rules-api?lang_code=AR';
  ResponseEnum responseState = ResponseEnum.initial;

  Future<void> getAllRules() async {
    await getAllRulesApi();
    update();
  }

  // void search(String key) {
  //   VideoControllerData.filteredVideosList =
  //       VideoControllerData.allVideos
  //           .where((x) => x.toString().toLowerCase().trim().contains(key.toLowerCase()))
  //           .toList();
  //   update();
  // }

  Future getAllRulesApi() async {
    const t = 'getAllRulesApi - GrammerRuleController';
    GrammerRulesState.rules = [];
    DioConsumer dioConsumer = serviceLocator();
    String path = baseUrl() + getRulesEndpoint;
    responseState = ResponseEnum.loading;
    update();
    try {
      final data = await dioConsumer.get(path);
      // List data = jsonDecode(response);
      pr(data, '$t - raw response');

      List<GrammarRuleModel> rules = data['rules']
          .map<GrammarRuleModel>((json) => GrammarRuleModel.fromJson(json))
          .toList();
      pr(rules, '$t - parsed response');
      responseState = ResponseEnum.success;
      GrammerRulesState.rules = rules;
      update();
      return;
    } on Exception catch (e) {
      pr('Exception occured: $e', t);
      responseState = ResponseEnum.failed;
      GrammerRulesState.rules = [];
      update();
      return;
    }
  }
}
