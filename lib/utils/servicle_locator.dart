import 'package:dio/dio.dart';
import 'package:dalalat_quran_light/features/chat/services/chat_service.dart';
import 'package:dalalat_quran_light/features/notifications/services/notifications_service.dart';
import 'package:dalalat_quran_light/features/quran/services/ayat_service.dart';
import 'package:dalalat_quran_light/features/quran/services/quran_pages_service.dart';
import 'package:dalalat_quran_light/features/words/services/quran_roots_search_service.dart';
import 'package:dalalat_quran_light/features/words/services/words_service.dart';
import 'package:dalalat_quran_light/utils/api_service/dio_consumer.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt serviceLocator = GetIt.instance;
Future<void> initServiceLocator() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  serviceLocator.registerLazySingleton<Dio>(() => Dio());
  serviceLocator.registerLazySingleton<DioConsumer>(() => DioConsumer(dio: serviceLocator()));
  serviceLocator.registerLazySingleton<ChatService>(() => ChatService());
  serviceLocator.registerLazySingleton<WordsService>(() => WordsService());
  serviceLocator.registerLazySingleton<QuranRootsSearchService>(() => QuranRootsSearchService());
  serviceLocator.registerLazySingleton<NotificationsService>(() => NotificationsService());
  serviceLocator.registerLazySingleton<QuranPagesService>(() => QuranPagesService()..fetchPages());
  serviceLocator.registerLazySingleton<AyatService>(() => AyatService());
}
