import 'package:dalalat_quran_light/features/words/models/root_model/root_model.dart';
import 'package:dalalat_quran_light/features/words/services/words_service.dart';
import 'package:dalalat_quran_light/models/api_response_model.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/servicle_locator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RootsController extends GetxController {
  ApiResponseModel<List<RootModel>> rootsList = ApiResponseModel(response: ResponseEnum.initial);
  final WordsService service = serviceLocator<WordsService>();
  String searchQuery = '';
  final searchInput = TextEditingController();
  Future search(String query) async {
    final t = 'search - RootsController';

    if (query.isNotEmpty && searchQuery == query) {
      return;
    }
    searchQuery = query;
    pr(query, '$t - query');
    rootsList = rootsList.copyWith(errorMessage: null, response: ResponseEnum.loading);
    update();
    final ApiResponseModel<List<RootModel>> response = await service.fetchRoots(query);

    pr(response, t);
    rootsList = response;
    update();
  }
}
