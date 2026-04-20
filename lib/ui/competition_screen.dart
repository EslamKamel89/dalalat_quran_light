import 'package:dalalat_quran_light/controllers/competitions_controller.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/servicle_locator.dart';
import 'package:dalalat_quran_light/widgets/competition_card_widget.dart';
import 'package:dalalat_quran_light/widgets/quran_toolbar.dart';
import 'package:dalalat_quran_light/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompetitionsScreen extends StatefulWidget {
  static String id = '/competitionsScreen';
  const CompetitionsScreen({super.key});

  @override
  State<CompetitionsScreen> createState() => _CompetitionsScreenState();
}

class _CompetitionsScreenState extends State<CompetitionsScreen> {
  final CompetitionsController _competitionsController = Get.put(
    CompetitionsController(dioConsumer: serviceLocator()),
  );
  @override
  void initState() {
    _competitionsController.getAllQuestions();
    super.initState();
  }

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _searchController.addListener(() {
      _competitionsController.search(_searchController.text.toString().toLowerCase());
    });
    return Scaffold(
      appBar: const QuranBar("اسئلة تبحث عن اجوبه"),
      body: Column(
        children: [
          SearchWidget(_searchController, null, () {
            // _competitionsController.search(_searchController.text.toString().toLowerCase());
          }),
          GetBuilder<CompetitionsController>(
            builder: (_) {
              pr(CompetitionsData.filteredList, 'Competition list data');
              return CompetitionsData.filteredList.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return CompetitionCardWidget(CompetitionsData.filteredList[index], index);
                        },
                        itemCount: CompetitionsData.filteredList.length,
                      ),
                    )
                  : _competitionsController.getAllQuestionsResponseState == ResponseEnum.loading
                  ? SizedBox(
                      width: double.infinity,
                      height: context.height * 0.6,
                      child: const Center(child: CircularProgressIndicator()),
                    )
                  : Expanded(
                      child: Center(
                        child: Text('لا يوجد أي مسابقات حاليا'.tr, textAlign: TextAlign.center),
                      ),
                    );
            },
          ),

          // Obx(
          //   () => _competitionsController.filteredList.isNotEmpty
          //       ? Expanded(
          //           child: ListView.builder(
          //             itemBuilder: (context, index) {
          //               return competitionsWidget(_competitionsController.filteredList[index]);
          //             },
          //             itemCount: _competitionsController.filteredList.length,
          //           ),
          //         )
          //       : Expanded(
          //           child: Center(
          //             child: Text(
          //               'no_competitions_found'.tr,
          //               textAlign: TextAlign.center,
          //             ),
          //           ),
          //         ),
          // )
        ],
      ),
    );
  }
}
