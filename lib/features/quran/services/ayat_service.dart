import 'package:dalalat_quran_light/features/quran/models/ayah_model.dart';
import 'package:dalalat_quran_light/models/api_response_model.dart';
import 'package:dalalat_quran_light/utils/api_service/dio_consumer.dart';
import 'package:dalalat_quran_light/utils/constants.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/servicle_locator.dart';

class AyatService {
  final DioConsumer dio = serviceLocator<DioConsumer>();
  Future<ApiResponseModel<List<AyahModel>>> fetchAyat(int pageNumber) async {
    final t = 'AyatService - fetchAyat';
    final url = '${baseUrl()}page-ayat/$pageNumber';
    try {
      final response = await dio.get(url);
      final List data = response as List;
      final ayat = data.map((e) => AyahModel.fromJson(e)).toList();
      return pr(ApiResponseModel(response: ResponseEnum.success, data: ayat), t);
    } catch (e) {
      return pr(ApiResponseModel(response: ResponseEnum.failed, errorMessage: e.toString()));
    }
  }
}
