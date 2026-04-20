import 'package:dalalat_quran_light/features/grammer_rules/controllers/grammer_controller.dart';
import 'package:dalalat_quran_light/features/grammer_rules/presentation/views/quran_surahs_view.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/text_styles.dart';
import 'package:dalalat_quran_light/widgets/quran_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class GrammarRulesView extends StatefulWidget {
  const GrammarRulesView({super.key, this.addScaffold = true});
  static const id = '/GrammerRulesView';
  final bool addScaffold;
  @override
  State<GrammarRulesView> createState() => _GrammarRulesViewState();
}

class _GrammarRulesViewState extends State<GrammarRulesView> {
  final GrammerRulesController controller = Get.find<GrammerRulesController>();
  @override
  void initState() {
    if (GrammerRulesState.rules.isEmpty) {
      controller.getAllRules();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final content = SizedBox(
      child: GetBuilder<GrammerRulesController>(
        builder: (_) {
          if (controller.responseState == ResponseEnum.loading) {
            return Center(child: CircularProgressIndicator());
          }
          final rules = GrammerRulesState.rules;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: rules.length,
            itemBuilder: (context, index) {
              final rule = rules[index];
              return Container(
                margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.grey,
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => QuranSurahsScreen(id: rule.id ?? 0)),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                    // height: ,
                    child: Row(
                      children: [
                        Expanded(
                          child: ArabicText(rule.nameAr ?? '', fontSize: 15, color: Colors.black),
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                  ).animate().fade(duration: 300.ms).move(begin: const Offset(-12, 0)),
                ).animate().scale(delay: (index * 50).ms),
              );
            },
          );
        },
      ),
    );
    if (widget.addScaffold) {
      return Scaffold(appBar: QuranBar("قواعد لسانية".tr), body: content);
    }
    return content;
  }
}
