import 'dart:convert';

import 'package:dalalat_quran_light/utils/api_service/dio_consumer.dart';
import 'package:dalalat_quran_light/utils/constants.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

enum DownloadLinkType { ayah, tag, article }

class GetDownloadLinkController extends GetxController {
  static final String _domainLink = baseUrl();
  static const String _ayahDownloadLink = "ayahfile";
  static const String _tagDownloadLink = "tagfile";
  static const String _articleDownloadLink = "articlefile";
  ResponseEnum responseState = ResponseEnum.initial;
  final DioConsumer dioConsumer;
  GetDownloadLinkController({required this.dioConsumer});
  Future<String?> getDownloadlink({
    required DownloadLinkType downloadLinkType,
    required String id,
  }) async {
    final t = 'getDownloadlink - CommentController $downloadLinkType';
    String path = _domainLink;
    switch (downloadLinkType) {
      case DownloadLinkType.ayah:
        path += _ayahDownloadLink;
      case DownloadLinkType.tag:
        path += _tagDownloadLink;
      case DownloadLinkType.article:
        path += _articleDownloadLink;
    }
    path += '/$id';
    responseState = ResponseEnum.loading;
    try {
      final response = await dioConsumer.get(path);
      String? downloadLink = jsonDecode(response)['link'];
      if (downloadLink != null) {
        pr(response, t);
        responseState = ResponseEnum.success;
        update();
        return downloadLink;
      }
      pr('no download link for this: $downloadLinkType', t);
      responseState = ResponseEnum.success;
      update();
      return null;
    } on Exception catch (e) {
      pr('Exeption occured: $e', t);
      responseState = ResponseEnum.failed;
      update();
      return null;
    }
  }
}
