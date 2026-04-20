import 'package:dalalat_quran_light/features/grammer_rules/controllers/grammer_surahs_controller.dart';
import 'package:dalalat_quran_light/features/grammer_rules/presentation/views/quran_ayahs_view.dart';
import 'package:dalalat_quran_light/features/grammer_rules/presentation/widgets/default_card.dart';
import 'package:dalalat_quran_light/utils/colors.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/text_styles.dart';
import 'package:dalalat_quran_light/widgets/quran_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class QuranSurahsScreen extends StatefulWidget {
  const QuranSurahsScreen({super.key, required this.id});
  final int id;
  @override
  State<QuranSurahsScreen> createState() => _QuranSurahsScreenState();
}

class _QuranSurahsScreenState extends State<QuranSurahsScreen> {
  final GrammerSurahsController controller = Get.find<GrammerSurahsController>();
  @override
  void initState() {
    controller.getAllSurahs(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QuranBar('surahs'.tr),
      backgroundColor: lightGray2,
      body: Container(
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.topRight,
          //   end: Alignment.bottomLeft,
          //   // colors: [Color(0xFFE6E6FA), Color(0xFFBBDEFB)],
          // ),
        ),
        child: GetBuilder<GrammerSurahsController>(
          builder: (_) {
            if (controller.responseState == ResponseEnum.loading) {
              return Center(child: CircularProgressIndicator());
            }
            final surahs = GrammerSurahsState.surahs;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: surahs.length,
              itemBuilder: (context, index) {
                final surah = surahs[index];
                return DefaultCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            QuranAyahsScreen(ruleId: widget.id, surahId: surah.suraId ?? 0),
                      ),
                    );
                  },
                  child:
                      Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ArabicText(
                                surah.suraAr ?? '',
                                // color: primaryColor,
                                fontSize: 20,
                              ),
                              // Text(
                              //   surah.suraAr ?? '',
                              //   textAlign: TextAlign.right,
                              //   style: const TextStyle(
                              //     fontSize: 20,
                              //     height: 2.2,
                              //     color: Color(0xFF2E7D32),
                              //     shadows: [
                              //       Shadow(
                              //         offset: Offset(1, 1),
                              //         blurRadius: 2,
                              //         color: Color(0x33000000),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // const SizedBox(height: 8),
                              // Text(
                              //   item['sura']!,
                              //   textAlign: TextAlign.right,
                              //   style: const TextStyle(
                              //     fontSize: 14,
                              //     color: Colors.grey,
                              //     fontStyle: FontStyle.italic,
                              //   ),
                              // ),
                            ],
                          )
                          .animate()
                          .fade(duration: 400.ms)
                          .scale(begin: Offset(0.9, 0.9), end: Offset(1, 1))
                          .move(begin: const Offset(0, 10))
                          .animate()
                          .shimmer(duration: 400.ms, color: Colors.green.withOpacity(0.1))
                          .then()
                          .fadeIn(),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
