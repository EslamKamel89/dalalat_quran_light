// lib/features/holiday/repositories/holiday_repository.dart

import 'package:dalalat_quran_light/utils/api_service/dio_consumer.dart';
import 'package:dalalat_quran_light/utils/constants.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:dalalat_quran_light/utils/servicle_locator.dart';

import '../models/islamic_holiday.dart';

class HolidayRepository {
  static DioConsumer dioConsumer = serviceLocator();

  static Future<List<IslamicHoliday>> getHolidays() async {
    const t = 'HolidayRepository - getHolidays ';
    String path = baseUrl() + 'events';
    try {
      final response = await dioConsumer.get(path);
      response[response.length - 1]["start_date"] = "2026-05-26";
      pr(response, '$t - raw response');
      List<IslamicHoliday> articles =
          response.map<IslamicHoliday>((json) => IslamicHoliday.fromJson(json)).toList();
      return pr(articles, '$t - parsed response');
    } on Exception catch (e) {
      pr('Exception occurred: $e', t);
      return [];
    }
  }
}

var _staticData = [
  {
    "id": 1,
    "type": "ramadanStart",
    "arabic_title": "رمضان مبارك",
    "english_title": "Ramadan Mubarak",
    "start_date": "2026-02-18",
    "end_date": "2026-02-18",
    "greeting_arabic": "رمضان مبارك 🌙",
    "greeting_english": "Ramadan Mubarak 🌙",
  },

  {
    "id": 2,
    "type": "laylatAlQadr",
    "arabic_title": "ليلة القدر",
    "english_title": "Laylat Al-Qadr",
    "start_date": "2026-03-16",
    "end_date": "2026-03-16",
    "greeting_arabic": "ليلة مباركة ✨",
    "greeting_english": "Blessed Night ✨",
  },

  {
    "id": 3,
    "type": "eidAlFitr",
    "arabic_title": "عيد الفطر",
    "english_title": "Eid Al-Fitr",
    "start_date": "2026-03-20",
    "end_date": "2026-03-22",
    "greeting_arabic": "عيد فطر مبارك 🌙",
    "greeting_english": "Blessed Eid Al-Fitr 🌙",
  },

  {
    "id": 4,
    "type": "islamicNewYear",
    "arabic_title": "رأس السنة الهجرية",
    "english_title": "Islamic New Year",
    "start_date": "2026-06-16",
    "end_date": "2026-06-16",
    "greeting_arabic": "عام هجري مبارك",
    "greeting_english": "Blessed Hijri Year",
  },

  {
    "id": 5,
    "type": "ashura",
    "arabic_title": "يوم عاشوراء",
    "english_title": "Ashura",
    "start_date": "2026-06-25",
    "end_date": "2026-06-25",
    "greeting_arabic": "",
    "greeting_english": "",
  },

  {
    "id": 6,
    "type": "mawlid",
    "arabic_title": "المولد النبوي",
    "english_title": "Mawlid",
    "start_date": "2026-08-25",
    "end_date": "2026-08-25",
    "greeting_arabic": "ﷺ",
    "greeting_english": "Peace Be Upon Him ﷺ",
  },

  {
    "id": 7,
    "type": "eidAlAdha",
    "arabic_title": "عيد الأضحى",
    "english_title": "Eid Al-Adha",
    "start_date": "2026-05-27",
    "end_date": "2026-05-30",
    "greeting_arabic": "عيد أضحى مبارك 🌙",
    "greeting_english": "Blessed Eid Al-Adha 🌙",
  },
];
