import 'package:dalalat_quran_light/features/quran/static/surah_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../entities/surah_entity.dart';

class SurahListController extends GetxController {
  final TextEditingController searchInput = TextEditingController();

  final List<SurahEntity> allSurahs = surahs;
  List<SurahEntity> filteredSurahs = surahs;
  void search() {
    final query = searchInput.text.trim();
    if (query.isEmpty) {
      filteredSurahs = allSurahs;
    } else {
      filteredSurahs = allSurahs.where((surah) => surah.name.contains(query)).toList();
    }
    update();
  }

  @override
  void onInit() {
    searchInput.addListener(search);
    super.onInit();
  }

  @override
  void onClose() {
    searchInput.dispose();
    super.onClose();
  }
}
