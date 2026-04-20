import 'package:dalalat_quran_light/features/quran/entities/surah_entity.dart';
import 'package:dalalat_quran_light/features/quran/models/ayah_model.dart';
import 'package:dalalat_quran_light/features/quran/models/quran_page_model.dart';
import 'package:dalalat_quran_light/features/quran/services/ayat_service.dart';
import 'package:dalalat_quran_light/features/quran/services/quran_pages_service.dart';
import 'package:dalalat_quran_light/features/quran/static/surah_data.dart';
import 'package:dalalat_quran_light/models/api_response_model.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/servicle_locator.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class QuranReaderController extends GetxController {
  final QuranPagesService service = serviceLocator<QuranPagesService>();
  final AyatService ayatService = serviceLocator<AyatService>();
  ApiResponseModel<List<QuranPageModel>> pages = ApiResponseModel(response: ResponseEnum.initial);
  ApiResponseModel<List<AyahModel>> ayat = ApiResponseModel(response: ResponseEnum.initial);
  late int initialPage;
  int currentPageIndex = 0;
  SurahEntity? surah;

  late PageController pageController;

  void init(SurahEntity surah) {
    this.surah = surah;

    initialPage = surah.startPage - 1;
    currentPageIndex = initialPage;

    pageController = PageController(initialPage: initialPage);

    if (pages.data == null) {
      fetchPages();
    } else {
      update();
    }
  }

  Future<void> fetchPages() async {
    pages = pages.copyWith(response: ResponseEnum.loading, errorMessage: null);
    update();

    final response = await service.fetchPages();

    pages = response;
    update();
  }

  void onPageChanged(int index) {
    currentPageIndex = index;
    update();
  }

  SurahEntity get currentSurah {
    final pageNumber = currentPageIndex + 1;

    return surahs.lastWhere((s) => s.startPage <= pageNumber);
  }

  Future<void> fetchAyatForCurrentPage() async {
    if (ayat.response == ResponseEnum.loading) return;
    final pageNumber = currentPageIndex + 1;
    ayat = ayat.copyWith(response: ResponseEnum.loading, errorMessage: null);
    update();
    final response = await ayatService.fetchAyat(pageNumber);
    ayat = response;
    update();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
