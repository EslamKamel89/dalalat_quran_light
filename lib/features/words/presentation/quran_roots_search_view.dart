import 'package:dalalat_quran_light/features/words/controllers/quran_roots_search_controller.dart';
import 'package:dalalat_quran_light/features/words/presentation/widgets/quran_ayah_card.dart';
import 'package:dalalat_quran_light/features/words/presentation/widgets/quran_roots_search_bar.dart';
import 'package:dalalat_quran_light/features/words/presentation/widgets/token_chips_row.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuranRootsSearchView extends StatefulWidget {
  const QuranRootsSearchView({super.key});

  @override
  State<QuranRootsSearchView> createState() => _QuranRootsSearchViewState();
}

class _QuranRootsSearchViewState extends State<QuranRootsSearchView> {
  late final QuranRootsSearchController controller;

  @override
  void initState() {
    controller = Get.find();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuranRootsSearchController>(
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              QuranRootsSearchBar(controller: controller.searchInput, onSearch: controller.search),
              const SizedBox(height: 20),

              if (controller.words.response == ResponseEnum.loading)
                const CircularProgressIndicator(),

              if (controller.words.response == ResponseEnum.success &&
                  controller.groupedTokens.isNotEmpty)
                TokenChipsRow(
                  groupedTokens: controller.groupedTokens,
                  selectedToken: controller.selectedToken,
                  onTap: controller.selectToken,
                ),

              const SizedBox(height: 10),

              if (controller.words.response == ResponseEnum.success &&
                  controller.words.data != null &&
                  controller.words.data!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'root_results'.trParams({"root": controller.words.data!.first.root ?? ""}),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              if (controller.words.response == ResponseEnum.success &&
                  controller.filteredAyahs.isEmpty)
                Text("no_results".tr),

              if (controller.words.response == ResponseEnum.success)
                Expanded(
                  child: ListView(
                    children: controller.filteredAyahs.values
                        .map(
                          (e) => QuranAyahCard(words: e, selectedToken: controller.selectedToken),
                        )
                        .toList(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
