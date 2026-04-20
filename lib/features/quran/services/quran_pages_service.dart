import 'package:dalalat_quran_light/features/quran/models/quran_page_model.dart';
import 'package:dalalat_quran_light/models/api_response_model.dart';
import 'package:dalalat_quran_light/utils/api_service/dio_consumer.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/servicle_locator.dart';

class QuranPagesService {
  List<QuranPageModel>? _cachedPages;

  Future<ApiResponseModel<List<QuranPageModel>>> fetchPages() async {
    final t = 'QuranPagesService - fetchPages';
    if (_cachedPages != null) {
      return pr(
        ApiResponseModel(response: ResponseEnum.success, data: _cachedPages),
        "$t - From app memory",
      );
    }
    DioConsumer dioConsumer = serviceLocator();
    try {
      final response = await dioConsumer.get('https://quran.yousefheiba.com/api/quranPagesImage');
      final List pagesJson = response['pages'] as List;

      final pages = pagesJson.map((e) => QuranPageModel.fromJson(e)).toList();
      _cachedPages = pr(pages, "$t - parsed response");
      return ApiResponseModel(response: ResponseEnum.success, data: pages);
    } catch (e) {
      return pr(
        ApiResponseModel(response: ResponseEnum.failed, errorMessage: e.toString()),
        "$t - Error",
      );
    }
  }
}
