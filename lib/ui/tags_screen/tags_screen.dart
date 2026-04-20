import 'package:dalalat_quran_light/ui/home_sura_screen.dart';
import 'package:dalalat_quran_light/ui/tags_screen/widgets/difference_tag_widget.dart';
import 'package:dalalat_quran_light/ui/tags_screen/widgets/equals_tag_widget.dart';
import 'package:dalalat_quran_light/ui/tags_screen/widgets/meaning_tag_widget.dart';
import 'package:dalalat_quran_light/widgets/quran_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TagsScreen extends StatefulWidget {
  const TagsScreen({super.key, this.currentIndex = 0});

  static String id = '/TagsScreen';
  final int currentIndex;
  @override
  State<TagsScreen> createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {
  int currentIndex = 0;
  @override
  void initState() {
    currentIndex = widget.currentIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: QuranBar('semantics'.tr),
        body: Column(
          children: [
            const SizedBox(height: 5),
            TabBar(
              indicatorColor: Colors.transparent,
              tabs: [
                TabButton(title: "identities".tr, selected: currentIndex == 0, fontSize: 17),
                TabButton(title: "concepts".tr, selected: currentIndex == 1, fontSize: 17),
                TabButton(
                  title: "reflection_principles".tr,
                  selected: currentIndex == 2,
                  fontSize: 17,
                ),
              ],
              onTap: (value) {
                currentIndex = value;
                setState(() {});
              },
            ),
            Expanded(
              child: currentIndex == 0
                  ? EqualsTagsWidget()
                  : currentIndex == 1
                  ? MeaningTagsWidget()
                  // : currentIndex == 2
                  : DifferenceTagsWidget(),
              // : GrammarRulesView(addScaffold: false),
            ),
          ],
        ),
      ),
    );
  }
}
