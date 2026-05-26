// lib/features/holiday/services/holiday_service.dart

import '../models/islamic_holiday.dart';
import '../repositories/holiday_repository.dart';

class HolidayService {
  static List<IslamicHoliday> _holidays = [];

  static Future<void> initialize() async {
    _holidays = await HolidayRepository.getHolidays();
  }

  static List<IslamicHoliday> holidays() {
    return _holidays;
  }

  static IslamicHoliday? currentHoliday() {
    final now = DateTime.now();

    for (final holiday in _holidays) {
      if (holiday.isActive(now)) {
        return holiday;
      }
    }

    return null;
  }

  static bool isHolidayToday() {
    return currentHoliday() != null;
  }
}
