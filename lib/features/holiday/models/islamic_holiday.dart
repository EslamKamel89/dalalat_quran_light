// lib/features/holiday/models/islamic_holiday.dart

import '../enums/holiday_type.dart';

class IslamicHoliday {
  final int id;

  final HolidayType type;

  final String arabicTitle;
  final String englishTitle;

  final DateTime startDate;
  final DateTime endDate;

  final String greetingArabic;
  final String greetingEnglish;

  const IslamicHoliday({
    required this.id,
    required this.type,
    required this.arabicTitle,
    required this.englishTitle,
    required this.startDate,
    required this.endDate,
    required this.greetingArabic,
    required this.greetingEnglish,
  });

  factory IslamicHoliday.fromJson(Map<String, dynamic> json) {
    return IslamicHoliday(
      id: json['id'],

      type: HolidayType.values.firstWhere((e) => e.name == json['type']),

      arabicTitle: json['arabic_title'],

      englishTitle: json['english_title'],

      startDate: DateTime.parse(json['start_date']),

      endDate: DateTime.parse(json['end_date']),

      greetingArabic: json['greeting_arabic'],

      greetingEnglish: json['greeting_english'],
    );
  }

  bool isActive(DateTime now) {
    final date = DateTime(now.year, now.month, now.day);

    final start = DateTime(startDate.year, startDate.month, startDate.day);

    final end = DateTime(endDate.year, endDate.month, endDate.day);

    return !date.isBefore(start) && !date.isAfter(end);
  }
}
