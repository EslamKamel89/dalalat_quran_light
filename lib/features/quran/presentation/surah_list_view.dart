import 'package:dalalat_quran_light/features/quran/controllers/surah_list_controller.dart';
import 'package:dalalat_quran_light/features/quran/presentation/widgets/surah_item.dart';
import 'package:dalalat_quran_light/ui/chat/widgets/default_screen_padding.dart';
import 'package:dalalat_quran_light/widgets/quran_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SurahListView extends StatefulWidget {
  const SurahListView({super.key});

  @override
  State<SurahListView> createState() => _SurahListViewState();
}

class _SurahListViewState extends State<SurahListView> {
  late final SurahListController controller;

  @override
  void initState() {
    controller = Get.find<SurahListController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SurahListController>(
      builder: (_) {
        return Scaffold(
          appBar: QuranBar('قراءة القرآن'),
          body: DefaultScreenPadding(
            child: Column(
              children: [
                TextField(
                  controller: controller.searchInput,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: 'ابحث عن سورة',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                Expanded(
                  child: controller.filteredSurahs.isEmpty
                      ? const Center(
                          child: Text(
                            'لا توجد نتائج',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListView.builder(
                          itemCount: controller.filteredSurahs.length,
                          itemBuilder: (context, index) {
                            final surah = controller.filteredSurahs[index];
                            return SurahItem(surah: surah);
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
