import 'package:dio/dio.dart';
import 'package:dalalat_quran_light/features/words/models/quran_word/quran_word.dart';
import 'package:dalalat_quran_light/models/api_response_model.dart';
import 'package:dalalat_quran_light/utils/api_service/dio_get_counsumer.dart';
import 'package:dalalat_quran_light/utils/api_service/end_points.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';

class QuranRootsSearchService {
  DioGetConsumer api = DioGetConsumer(dio: Dio());
  Future<ApiResponseModel<List<QuranWordModel>>> fetchRoots(String search) async {
    final t = 'fetchRoots - QuranRootsSearchService';
    try {
      final response = await api.get(
        EndPoint.quranRootsSearch + (search.trim() == '' ? '' : '?q=$search'),
      );
      pr(response, '$t - response');

      final List<QuranWordModel> models = (response as List)
          .map((json) => QuranWordModel.fromJson(json))
          .toList();
      return pr(ApiResponseModel(response: ResponseEnum.success, data: models), t);
    } catch (e) {
      String errorMessage = e.toString();
      // if (e is DioException) {
      //   errorMessage = jsonEncode(e.response?.data ?? 'Unknown error occured');
      // }
      return pr(ApiResponseModel(errorMessage: errorMessage, response: ResponseEnum.failed), t);
    }
  }
}
