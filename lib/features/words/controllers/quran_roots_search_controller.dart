import 'package:dalalat_quran_light/features/words/domain/quran_roots_aggregator.dart';
import 'package:dalalat_quran_light/features/words/models/quran_word/quran_word.dart';
import 'package:dalalat_quran_light/features/words/services/quran_roots_search_service.dart';
import 'package:dalalat_quran_light/models/api_response_model.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/servicle_locator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuranRootsSearchController extends GetxController {
  final QuranRootsSearchService service = serviceLocator<QuranRootsSearchService>();

  ApiResponseModel<List<QuranWordModel>> words = ApiResponseModel(response: ResponseEnum.initial);

  final searchInput = TextEditingController();
  String searchQuery = '';

  String? selectedToken;

  Map<int, List<QuranWordModel>> groupedAyahs = {};
  Map<String, List<QuranWordModel>> groupedTokens = {};

  int ayahCount = 0;

  Future search() async {
    final query = searchInput.text.trim();
    if (query.isEmpty) return;

    words = words.copyWith(response: ResponseEnum.loading, errorMessage: null);
    update();

    final response = await service.fetchRoots(query);
    words = response;

    if (response.response == ResponseEnum.success && response.data != null) {
      final aggregator = QuranRootsAggregator(response.data!);

      groupedAyahs = aggregator.groupByAyah();
      groupedTokens = aggregator.groupByToken();
      ayahCount = aggregator.uniqueAyahCount();

      selectedToken = null;
    }

    update();
  }

  void selectToken(String? token) {
    if (selectedToken == token) {
      selectedToken = null;
    } else {
      selectedToken = token;
    }
    update();
  }

  Map<int, List<QuranWordModel>> get filteredAyahs {
    if (selectedToken == null) return groupedAyahs;

    final filtered = <int, List<QuranWordModel>>{};

    groupedAyahs.forEach((ayahId, list) {
      final matches = list.where((e) => e.tokenUthmani == selectedToken).toList();
      if (matches.isNotEmpty) {
        filtered[ayahId] = matches;
      }
    });

    return filtered;
  }
}
