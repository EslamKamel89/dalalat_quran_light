import 'dart:io';

import 'package:dalalat_quran_light/utils/api_service/dio_consumer.dart';
import 'package:dalalat_quran_light/utils/api_service/upload_file_to_api.dart';
import 'package:dalalat_quran_light/utils/constants.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:get/get.dart';

abstract class JoinCompetitionData {
  static File? uploadFile;
}

class JoinCompetitionController extends GetxController {
  static final String _domainLink = baseUrl();
  static const String _joinCompetition = "addquestionreply";

  ResponseEnum joinCompetitionResponseState = ResponseEnum.initial;

  final DioConsumer dioConsumer;
  JoinCompetitionController({required this.dioConsumer});

  Future<bool> joinCompetition({
    required int id,
    required String email,
    required String name,
    required String phone,
    required String comment,
  }) async {
    var t = 'joinCompetition - JoinCompetitionController - id: $id ';
    pr('posting data started', t);

    final path = _domainLink + _joinCompetition;
    joinCompetitionResponseState = ResponseEnum.loading;
    try {
      final response = await dioConsumer.post(
        path,
        data: {
          "id": id,
          "email": email,
          "name": name,
          "phone": phone,
          "comment": comment,
          "devicelocal": Get.locale?.toLanguageTag() ?? 'ar',
          "file": JoinCompetitionData.uploadFile != null
              ? await uploadFileToApi(JoinCompetitionData.uploadFile!)
              : null,
        },
        isFormData: true,
      );
      pr(response, t);
      joinCompetitionResponseState = ResponseEnum.success;
      update();
      return true;
    } on Exception catch (e) {
      pr('Exeption occured: $e', t);
      joinCompetitionResponseState = ResponseEnum.failed;
      update();
      return false;
    }
  }

  @override
  void onClose() {
    JoinCompetitionData.uploadFile = null;
    update();
    super.onClose();
  }
}
