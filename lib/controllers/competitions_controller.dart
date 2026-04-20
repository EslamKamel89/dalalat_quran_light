import 'dart:convert';

import 'package:dalalat_quran_light/dialogs/custom_snack_bar.dart';
import 'package:dalalat_quran_light/models/competition_model.dart';
import 'package:dalalat_quran_light/utils/api_service/dio_consumer.dart';
import 'package:dalalat_quran_light/utils/constants.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:get/get.dart';

abstract class CompetitionsData {
  static List<CompetitionModel> competitionsList = [];
  static List<CompetitionModel> filteredList = [];
}

class CompetitionsController extends GetxController {
  static final String _domainLink = baseUrl();
  static const String _getAllQuestions = "allquestions";

  ResponseEnum getAllQuestionsResponseState = ResponseEnum.initial;
  ResponseEnum joinCompetitionResponseState = ResponseEnum.initial;

  final DioConsumer dioConsumer;
  CompetitionsController({required this.dioConsumer});

  Future<bool> getAllQuestions() async {
    const t = 'allQuestions - CompetitionsController ';
    pr('fetching data started', t);
    final path = _domainLink + _getAllQuestions;
    getAllQuestionsResponseState = ResponseEnum.loading;
    try {
      final response = await dioConsumer.get(path);
      pr(response, t);
      CompetitionsData.competitionsList = jsonDecode(
        response,
      ).map<CompetitionModel>((json) => CompetitionModel.fromJson(json)).toList();

      // CompetitionsData.competitionsList[1].active = 0;
      CompetitionsData.filteredList = CompetitionsData.competitionsList;
      getAllQuestionsResponseState = ResponseEnum.success;
      update();
      return true;
    } on Exception catch (e) {
      pr('Exception occurred: $e', t);
      getAllQuestionsResponseState = ResponseEnum.failed;
      showCustomSnackBar(
        title: "خطأ",
        body: "نأسف لحدوث خطا و برجاء المحاولة مرة أخري",
        isSuccess: false,
      );
      update();
      return false;
    }
  }

  void search(String key) {
    if (key == "") {
      CompetitionsData.filteredList = CompetitionsData.competitionsList;
      update();
      return;
    }
    List<dynamic> filteredData = CompetitionsData.competitionsList
        .where(((x) => x.toString().contains(key)))
        .toList();
    CompetitionsData.filteredList = filteredData as List<CompetitionModel>;
    update();
  }

  @override
  void onClose() {
    CompetitionsData.filteredList.clear();
    CompetitionsData.competitionsList.clear();
    update();
    super.onClose();
  }
}
