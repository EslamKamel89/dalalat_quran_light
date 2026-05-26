// lib/features/holiday/presentation/controllers/holiday_controller.dart

import 'package:get/get.dart';

import '../../models/islamic_holiday.dart';
import '../../services/holiday_service.dart';

class HolidayController extends GetxController {
  IslamicHoliday? currentHoliday;

  bool get hasHoliday => currentHoliday != null;

  @override
  Future<void> onInit() async {
    await HolidayService.initialize();

    currentHoliday = HolidayService.currentHoliday();

    super.onInit();
  }
}
