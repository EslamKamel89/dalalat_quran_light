import 'package:dalalat_quran_light/features/grammer_rules/presentation/views/grammer_rules_view.dart';
import 'package:dalalat_quran_light/features/words/presentation/quran_roots_search_view.dart';
import 'package:dalalat_quran_light/features/words/presentation/roots_view.dart';
import 'package:dalalat_quran_light/ui/home_sura_screen.dart';
import 'package:dalalat_quran_light/widgets/quran_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReferenceView extends StatefulWidget {
  const ReferenceView({super.key});

  @override
  State<ReferenceView> createState() => _ReferenceViewState();
}

class _ReferenceViewState extends State<ReferenceView> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QuranBar("reference".tr),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Container(height: 5),
            TabBar(
              indicatorColor: Colors.transparent,
              tabs: [
                TabButton(title: "search_by_word".tr, selected: currentIndex == 0),
                TabButton(title: "search_by_root".tr, selected: currentIndex == 1),
                TabButton(title: "linguistic_rules".tr, selected: currentIndex == 2, fontSize: 17),
              ],
              onTap: (value) {
                currentIndex = value;
                setState(() {});
              },
            ),
            Expanded(
              child: currentIndex == 0
                  ? const RootsView(addScaffold: false)
                  : currentIndex == 1
                  ? const QuranRootsSearchView()
                  : GrammarRulesView(addScaffold: false),
              // : StudiesScreen(),
              // : RootsView(addScaffold: false),
              // : const DiscussionsLoginScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
