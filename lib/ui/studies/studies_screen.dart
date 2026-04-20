import 'package:dalalat_quran_light/controllers/studies_controller.dart';
import 'package:dalalat_quran_light/models/study_model.dart';
import 'package:dalalat_quran_light/ui/studies/study_screen.dart';
import 'package:dalalat_quran_light/utils/colors.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/text_styles.dart';
import 'package:dalalat_quran_light/widgets/articles_widgets_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';

class StudiesScreen extends StatefulWidget {
  const StudiesScreen({super.key});

  @override
  State<StudiesScreen> createState() => _StudiesScreenState();
}

class _StudiesScreenState extends State<StudiesScreen> {
  final StudiesController _studiesController = Get.find<StudiesController>();
  @override
  void initState() {
    _studiesController.allAStudies();
    super.initState();
  }

  @override
  void dispose() {
    _studiesController.responseState = ResponseEnum.initial;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StudiesController>(
      builder: (context) {
        return ListView.builder(
          itemBuilder: (context, index) {
            if (index == 0) {
              return Column(
                children: [
                  SearchStudiesWidget((v) {
                    _studiesController.search(v.toString().toLowerCase());
                  }),
                  StudiesData.filteredList.isEmpty &&
                          _studiesController.responseState == ResponseEnum.success
                      ? Center(child: DefaultText("no_data".tr))
                      : const SizedBox(),
                ],
              );
            }
            index = index - 1;
            if (index < StudiesData.filteredList.length) {
              return StudyCardWidget(
                StudiesData.filteredList[index],
              ).animate().scale(delay: (index * 50).ms);
            }
            return _studiesController.responseState == ResponseEnum.loading
                ? const ArticlesWidgetLoadingColumn()
                : const SizedBox();
          },
          itemCount: StudiesData.filteredList.length + 2,
        );
      },
    );
  }
}

class StudyCardWidget extends StatelessWidget {
  final StudyModel studyModel;

  const StudyCardWidget(this.studyModel, {super.key});

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.grey,
          backgroundColor: Colors.white,
          padding: EdgeInsets.zero,
          elevation: 2,
        ),
        onPressed: () {
          Get.to(
            const StudyDetailsScreen(),
            transition: Transition.fadeIn,
            arguments: studyModel.id,
          );
        },
        child: Center(
          child: Container(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ArabicText(studyModel.name!, color: primaryColor, fontSize: 18),
                const SizedBox(height: 5),
                studyModel.description != 'null' && studyModel.description != null
                    ? Container(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          _parseHtmlString(studyModel.description!),
                          style: const TextStyle(fontSize: 15, fontFamily: "Almarai"),
                          maxLines: 1,
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SearchStudiesWidget extends StatelessWidget {
  final void Function(String)? onChange;
  const SearchStudiesWidget(this.onChange, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [BoxShadow(color: mediumGray, blurRadius: 10)],
      ),
      margin: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 15),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: const TextStyle(fontFamily: 'Almarai'),
              decoration: InputDecoration(
                hintText: 'search'.tr,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(0),
              ),
              onChanged: onChange,
            ),
          ),
          // InkWell(onTap: function, child: const Icon(Icons.search)),
        ],
      ),
    );
  }
}
