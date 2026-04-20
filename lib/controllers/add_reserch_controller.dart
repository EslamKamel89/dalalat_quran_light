import 'dart:io';

import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/api_service/dio_consumer.dart';
import 'package:dalalat_quran_light/utils/api_service/upload_file_to_api.dart';
import 'package:dalalat_quran_light/utils/constants.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:get/get.dart';

abstract class AddResearchData {
  static File? uploadFile;
}

class AddResearchController extends GetxController {
  static final String _domainLink = baseUrl();
  static const String _addResearch = "addresearch";

  ResponseEnum addResearchResponseState = ResponseEnum.initial;

  final DioConsumer dioConsumer;
  AddResearchController({required this.dioConsumer});

  Future<bool> addResearch({
    required String email,
    required String name,
    required String phone,
    required String comment,
  }) async {
    var t = 'addResearch - AddResearchController';
    pr('posting data started', t);

    final path = _domainLink + _addResearch;
    addResearchResponseState = ResponseEnum.loading;
    try {
      final response = await dioConsumer.post(
        path,
        data: {
          "email": email,
          "name": name,
          "phone": phone,
          "comment": comment,
          "devicelocal": Get.locale?.toLanguageTag() ?? 'ar',
          "file": await uploadFileToApi(AddResearchData.uploadFile!),
        },
        isFormData: true,
      );
      pr(response, t);
      addResearchResponseState = ResponseEnum.success;
      update();
      return true;
    } on Exception catch (e) {
      pr('Exeption occured: $e', t);
      addResearchResponseState = ResponseEnum.failed;
      update();
      return false;
    }
  }

  @override
  void onClose() {
    AddResearchData.uploadFile = null;
    update();
    super.onClose();
  }
}
