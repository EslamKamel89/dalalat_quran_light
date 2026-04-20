import 'dart:developer';

import 'package:dalalat_quran_light/ui/search_by_ayah/search_by_ayah_screen.dart';
import 'package:dalalat_quran_light/ui/search_screen.dart';
import 'package:dalalat_quran_light/ui/short_explanation_index.dart';
import 'package:dalalat_quran_light/utils/colors.dart';
import 'package:dalalat_quran_light/utils/text_styles.dart';
import 'package:dalalat_quran_light/widgets/quran_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class HomeSuraScreen extends StatefulWidget {
  const HomeSuraScreen({super.key});
  static var id = '/HomeSuraScreen';

  @override
  State<HomeSuraScreen> createState() => _HomeSuraScreenState();
}

class _HomeSuraScreenState extends State<HomeSuraScreen> with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    // _tabController!.addListener(() {
    //   setState(() {
    //     currentIndex = _tabController!.index;
    //   });
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // initScreenUtil(context);
    return Scaffold(
      backgroundColor: lightGray,
      appBar: QuranBar('short_explanation'.tr),
      body: Column(
        children: [
          const SizedBox(height: 5),
          TabBar(
            indicatorColor: Colors.transparent,
            tabs: [
              TabButton(title: 'brief_tafsir'.tr, selected: currentIndex == 0),
              TabButton(title: 'search_by_words'.tr, selected: currentIndex == 1),
              TabButton(title: "search_by_ayah".tr, selected: currentIndex == 2),
            ],
            controller: _tabController!,
            onTap: (value) {
              log('New Value = $value');
              currentIndex = value;
              setState(() {});
            },
          ),
          const SizedBox(height: 5),
          Expanded(
            child: currentIndex == 0
                ? ShortExplanationIndex()
                : currentIndex == 1
                ? SearchScreen()
                : const SearchAyahcreen(),
          ),
        ],
      ),
    );
  }
}

class TabButton extends StatelessWidget {
  String title;
  bool selected;
  double? fontSize;
  TabButton({super.key, required this.title, required this.selected, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 45,
      padding: EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: selected ? primaryColor2 : Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: ArabicTextGF(
          title,
          color: selected ? Colors.white : Colors.blueGrey,
          fontSize: fontSize ?? 17,
          textAlign: TextAlign.center,
          maxLines: 1,
        ),
      ),
    );
  }
}
