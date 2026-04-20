import 'package:dalalat_quran_light/models/competition_model.dart';
import 'package:dalalat_quran_light/ui/join_competition_screen.dart';
import 'package:dalalat_quran_light/utils/colors.dart';
import 'package:dalalat_quran_light/utils/format_currency.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class CompetitionCardWidget extends StatefulWidget {
  final CompetitionModel competitionModel;
  final int index;
  const CompetitionCardWidget(this.competitionModel, this.index, {super.key});

  @override
  State<CompetitionCardWidget> createState() => _CompetitionCardWidgetState();
}

class _CompetitionCardWidgetState extends State<CompetitionCardWidget> {
  int? maxLines = 1;

  @override
  Widget build(BuildContext context) {
    pr(widget.competitionModel.active);
    final bool isActive = widget.competitionModel.active == 1;

    // colors for active vs answered/disabled
    final Color borderColor = isActive ? Colors.grey : Colors.green;
    final Color shadowColor = isActive ? Colors.transparent : Colors.green.withOpacity(0.2);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(color: Colors.transparent, height: 170, width: double.infinity),
        // Main card
        Container(
          margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 30),
          child: Material(
            borderRadius: BorderRadius.circular(20),
            shadowColor: shadowColor,
            elevation: isActive ? 10 : 12,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              decoration: BoxDecoration(
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: isActive ? 6 : 12,
                    spreadRadius: isActive ? 0 : 1,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.competitionModel.nameAr ?? '',
                    overflow: maxLines == null ? null : TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: primaryColor,
                      fontSize: 18,
                      fontFamily: 'Almarai',
                    ),
                    maxLines: maxLines,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Show answer button only when competition is active (==1) AND the card is expanded
                      (isActive && maxLines == null)
                          ? TextButton(
                              onPressed: () {
                                Get.toNamed(
                                  JoinCompetitonView.id,
                                  arguments: {'competitionModel': widget.competitionModel},
                                );
                              },
                              child: const Text('أجب علي هذا السؤال'),
                            )
                          : const SizedBox(),
                      TextButton(
                        onPressed: () {
                          if (maxLines == 1) {
                            maxLines = null;
                            setState(() {});
                            return;
                          }
                          if (maxLines == null) {
                            maxLines = 1;
                            setState(() {});
                            return;
                          }
                        },
                        child: Text(
                          maxLines == null ? 'أخفاء' : 'قراءة المزيد',
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // Prize circle (unchanged)
        Positioned.directional(
          start: 10,
          bottom: -10,
          textDirection: Get.locale?.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
          child:
              Container(
                    padding: const EdgeInsets.only(bottom: 25, top: 0, left: 10, right: 10),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.8),
                      shape: BoxShape.circle,
                      border: Border.all(),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                              "assets/images/prize1.png",
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                            .animate(onPlay: (c) => c.repeat())
                            .shimmer(delay: (100 * widget.index).ms, duration: 1000.ms),
                        Text(
                          // guard null prize value
                          usdFormat.format(widget.competitionModel.prizeValue ?? 0),
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                  .animate(onPlay: (c) => c.repeat())
                  // subtle change: reduce shake when the card is not active (answered)
                  .shake(hz: maxLines != null ? 1 : (isActive ? 2 : 0.5), delay: 200.ms),
        ),

        // "تم الحل" badge - shown when NOT active (answered)
        if (!isActive)
          Positioned.directional(
            end: 30,
            top: 18,
            textDirection: Get.locale?.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Text(
                'تم الحل',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Almarai',
                ),
              ),
            ),
          ),
      ],
    );
  }
}
