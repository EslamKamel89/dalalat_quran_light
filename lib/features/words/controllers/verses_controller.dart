import 'package:dalalat_quran_light/features/words/models/root_model/verse.dart';
import 'package:dalalat_quran_light/features/words/services/words_service.dart';
import 'package:dalalat_quran_light/models/api_response_model.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/servicle_locator.dart';
import 'package:get/get.dart';

class VersesController extends GetxController {
  ApiResponseModel<List<VerseModel>> verses = ApiResponseModel();
  final WordsService service = serviceLocator<WordsService>();
  Future search(int rootId) async {
    final t = 'search - VersesController';
    // searchQuery = rootId;
    verses = verses.copyWith(errorMessage: null, response: ResponseEnum.loading, data: []);
    update();
    final ApiResponseModel<List<VerseModel>> response = await service.fetchVerses(rootId);
    pr(response, t);
    verses = response;
    update();
  }
}
