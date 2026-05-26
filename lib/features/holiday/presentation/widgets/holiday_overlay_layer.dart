import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/islamic_holiday.dart';
import '../controllers/holiday_controller.dart';
import 'eid_confetti_layer.dart';

class HolidayOverlayLayer extends StatelessWidget {
  const HolidayOverlayLayer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HolidayController>();

    if (!controller.hasHoliday) {
      return const SizedBox.shrink();
    }

    final IslamicHoliday holiday = controller.currentHoliday!;

    return Stack(
      children: [
        const EidConfettiLayer(),

        // if (holiday.enableGreeting) HolidayHeader(text: holiday.greetingArabic),
      ],
    );
  }
}
