import 'package:dio/dio.dart';
import 'package:dalalat_quran_light/features/words/models/root_model/root_model.dart';
import 'package:dalalat_quran_light/features/words/models/root_model/verse.dart';
import 'package:dalalat_quran_light/models/api_response_model.dart';
import 'package:dalalat_quran_light/utils/api_service/dio_get_counsumer.dart';
import 'package:dalalat_quran_light/utils/api_service/end_points.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';

class WordsService {
  DioGetConsumer api = DioGetConsumer(dio: Dio());
  Future<ApiResponseModel<List<RootModel>>> fetchRoots(String search) async {
    final t = 'fetchRoots - HomeController';
    try {
      final response = await api.get(
        EndPoint.roots + (search.trim() == '' ? '' : '?search=$search'),
      );
      pr(response, '$t - response');

      final List<RootModel> models = (response as List)
          .map((json) => RootModel.fromJson(json))
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

  Future<ApiResponseModel<List<VerseModel>>> fetchVerses(int rootId) async {
    final t = 'fetchVerses - WordsService';
    try {
      final response = await api.get(EndPoint.verses, queryParameter: {'rootId': rootId});
      pr(response, '$t - response');

      final List<VerseModel> models = (response as List)
          .map((json) => VerseModel.fromJson(json))
          .toList();
      return pr(ApiResponseModel(response: ResponseEnum.success, data: models), t);
    } catch (e) {
      String errorMessage = e.toString();
      // if (e is DioException) {
      //   errorMessage = jsonEncode(e.response?.data ?? 'Unknown error occured');
      // }
      // showSnackbar('Error', errorMessage, true);
      return pr(ApiResponseModel(errorMessage: errorMessage, response: ResponseEnum.failed), t);
    }
  }
}
