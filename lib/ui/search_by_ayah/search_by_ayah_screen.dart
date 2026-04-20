import 'package:dalalat_quran_light/controllers/search_ayah_controller.dart';
import 'package:dalalat_quran_light/ui/new_single_sura_screen.dart';
import 'package:dalalat_quran_light/ui/search_by_ayah/widgets/aya_searchable_dropdown.dart';
import 'package:dalalat_quran_light/ui/search_by_ayah/widgets/sura_searchable_dropdown.dart';
import 'package:dalalat_quran_light/ui/search_by_ayah/widgets/view_ayah_widget.dart';
import 'package:dalalat_quran_light/ui/sura_screen.dart';
import 'package:dalalat_quran_light/utils/colors.dart';
import 'package:dalalat_quran_light/utils/text_styles.dart';
import 'package:dalalat_quran_light/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchAyahcreen extends StatefulWidget {
  const SearchAyahcreen({super.key});

  @override
  State<SearchAyahcreen> createState() => _SearchAyahcreenState();
}

class _SearchAyahcreenState extends State<SearchAyahcreen> {
  final focusNode = FocusNode();

  SearchAyahController searchAyahController = Get.put(SearchAyahController());
  @override
  void initState() {
    searchAyahController.clearData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // _editController.text = searchController.searchKey;
    return GetBuilder<SearchAyahController>(
      builder: (_) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Visibility(
                visible:
                    searchAyahController.selectedSuraModel != null &&
                    searchAyahController.selectedAyaModel != null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: PrimaryButton(
                    onPressed: () {
                      searchAyahController.clearData();
                    },
                    borderRadius: 10,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      child: const DefaultText('بحث أخر', color: Colors.white),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible:
                    searchAyahController.selectedSuraModel == null ||
                    searchAyahController.selectedAyaModel == null,
                child: Column(
                  children: [
                    const SuraSearchableDropdown(),
                    Visibility(
                      visible: searchAyahController.selectedSuraModel != null,
                      child: const AyaSearchableDropdown(),
                    ),
                  ],
                ),
              ),
              searchAyahController.selectedAyaModel != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: DefaultText('نتيجة البحث', fontSize: 20, color: primaryColor),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ViewAyahWidget(ayaModel: searchAyahController.selectedAyaModel),
                        ),
                        const SizedBox(height: 25),
                        SizedBox(
                          width: double.infinity,
                          // height: context.height * 0.7,
                          child: NewSingleSuraScreen(
                            searchAyahController.selectedAyaModel?.page ?? 1,
                          ),
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.center,
                          child: PrimaryButton(
                            onPressed: () {
                              Get.to(
                                const SuraScreen(),
                                arguments: {
                                  'page': '${searchAyahController.selectedAyaModel?.page ?? 1}',
                                },
                              );
                            },
                            borderRadius: 10,
                            child: const DefaultText('الذهاب ألي ألاية', color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        );
      },
    );
  }
}
