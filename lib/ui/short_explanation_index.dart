import 'package:dalalat_quran_light/controllers/short_explanation_index_controller.dart';
import 'package:dalalat_quran_light/models/sura_model.dart';
import 'package:dalalat_quran_light/ui/sura_en_screen.dart';
import 'package:dalalat_quran_light/ui/sura_screen.dart';
import 'package:dalalat_quran_light/utils/constants.dart';
import 'package:dalalat_quran_light/widgets/search_widget.dart';
import 'package:dalalat_quran_light/widgets/single_sura.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

SuraModel? suraModel;
var selectedAyaId = '0'.obs;
var searchResultId = 0.obs;
var selectAyaNo = '0'.obs;
var playerSuraCount = 2.obs;
var playerSuraId = 0.obs;
var currentPage = 1.obs;
var currentReciter = '1'.obs;

class ShortExplanationIndex extends StatelessWidget {
  static String id = '/ShortExplanationIndex';
  final ShortExplainIndexController _controller = Get.put(ShortExplainIndexController());
  final TextEditingController _searchController = TextEditingController();

  ShortExplanationIndex({super.key});

  @override
  Widget build(BuildContext context) {
    final Widget suraScreen = GetStorage().read(language) == "ar" || true
        ? SuraScreen()
        : SuraEnScreen();
    _searchController.addListener(() {
      _controller.search(_searchController.text.toString().toLowerCase());
    });

    return Material(
      child: Column(
        children: [
          SearchWidget(_searchController, null, () {
            _controller.search(_searchController.text.toString().toLowerCase());
          }),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemBuilder: (context, index) {
                  return SingleSura(_controller.filteredList[index], suraScreen);
                },
                itemCount: _controller.filteredList.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
