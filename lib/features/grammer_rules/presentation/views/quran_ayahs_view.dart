import 'package:dalalat_quran_light/features/grammer_rules/controllers/grammer_ayahs_controller.dart';
import 'package:dalalat_quran_light/utils/colors.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/text_styles.dart';
import 'package:dalalat_quran_light/widgets/explain_dialog.dart';
import 'package:dalalat_quran_light/widgets/quran_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class QuranAyahsScreen extends StatefulWidget {
  const QuranAyahsScreen({super.key, required this.ruleId, required this.surahId});
  final int ruleId;
  final int surahId;
  @override
  State<QuranAyahsScreen> createState() => _QuranAyahsScreenState();
}

class _QuranAyahsScreenState extends State<QuranAyahsScreen> {
  final GrammerAyahsController controller = Get.find<GrammerAyahsController>();
  @override
  void initState() {
    controller.getAllAyahs(widget.ruleId, widget.surahId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QuranBar('ayahs'.tr),
      backgroundColor: lightGray2,
      body: Container(
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topRight,
        //     end: Alignment.bottomLeft,
        //     // colors: [Color(0xFFE6E6FA), Color(0xFFBBDEFB)],
        //   ),
        // ),
        child: GetBuilder<GrammerAyahsController>(
          builder: (context) {
            if (controller.responseState == ResponseEnum.loading) {
              return Center(child: CircularProgressIndicator());
            }
            final ayahs = GrammerAyahsState.ayahs;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: ayahs.length,
              itemBuilder: (context, index) {
                final ayah = ayahs[index];
                return InkWell(
                  onTap: () {
                    Get.dialog(
                      ExplainDialog(
                        ayaKey: ayah.ayaId.toString(),
                        videoId: '',
                        suraName: null,
                        ayaNumber: ayah.ayaId,
                      ),
                    );
                  },
                  child:
                      Card(
                            elevation: 2,
                            // shape: RoundedRectangleBorder(
                            //   borderRadius: BorderRadius.circular(16),
                            //   side: const BorderSide(color: primaryColor, width: 1),
                            // ),
                            child:
                                Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: primaryColor.withOpacity(0.02),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ArabicText(
                                            ayah.textAr ?? '',
                                            // color: primaryColor,
                                            fontSize: 20,
                                          ),
                                          // Text(
                                          //   ayah.textAr ?? '',
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
                                          const SizedBox(height: 8),
                                          ArabicText(
                                            ayah.suraAr ?? '',
                                            // color: primaryColor,
                                            fontSize: 18,
                                          ),
                                          // Text(
                                          //   ayah.suraAr ?? '',
                                          //   textAlign: TextAlign.right,
                                          //   style: const TextStyle(
                                          //     fontSize: 14,
                                          //     color: Colors.grey,
                                          //     fontStyle: FontStyle.italic,
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    )
                                    .animate()
                                    .fade(duration: 400.ms)
                                    .scale(begin: Offset(0.9, 0.9), end: Offset(1, 1))
                                    .move(begin: const Offset(0, 10)),
                          )
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
