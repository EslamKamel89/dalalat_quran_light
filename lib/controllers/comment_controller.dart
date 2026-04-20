import 'dart:convert';

import 'package:dalalat_quran_light/dialogs/custom_snack_bar.dart';
import 'package:dalalat_quran_light/utils/api_service/dio_consumer.dart';
import 'package:dalalat_quran_light/utils/constants.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:get/get.dart';

enum CommentType { ayah, article, tag }

class CommentController extends GetxController {
  static final String _domainLink = baseUrl();
  static const String _addAyahComment = "addayahcomment";
  static const String _addArticleComment = "addarticlecomment";
  static const String _addTagComment = "addtagcomment";
  ResponseEnum responseState = ResponseEnum.initial;
  final DioConsumer dioConsumer;
  CommentController({required this.dioConsumer});
  Future<bool> addComment({
    required CommentType commentType,
    required int id,
    required String name,
    required String email,
    required String phone,
    required String comment,
  }) async {
    String path = _domainLink;
    switch (commentType) {
      case CommentType.ayah:
        path += _addAyahComment;
      case CommentType.article:
        path += _addArticleComment;
      case CommentType.tag:
        path += _addTagComment;
    }
    final t = 'addComment - CommentController $commentType';
    responseState = ResponseEnum.loading;
    try {
      final response = await dioConsumer.post(
        path,
        data: {
          "id": id,
          "name": name,
          "email": email,
          "phone": phone,
          "comment": comment,
          "devicelocal": Get.locale?.languageCode ?? 'ar',
        },
      );

      if (jsonDecode(response)['status'] == 'true') {
        pr(response, t);
        responseState = ResponseEnum.success;
        showCustomSnackBar(title: "شكرا", body: "تم أضافة تعليقكم بنجاح");
        return true;
      }
      pr('Error occured response: $response', t);
      responseState = ResponseEnum.failed;
      showCustomSnackBar(
        title: "خطأ",
        body: "نأسف لحدوث خطا و برجاء المحاولة مرة أخري",
        isSuccess: false,
      );
      return false;
    } on Exception catch (e) {
      pr('Exeption occured: $e', t);
      responseState = ResponseEnum.failed;
      showCustomSnackBar(
        title: "خطأ",
        body: "نأسف لحدوث خطا و برجاء المحاولة مرة أخري",
        isSuccess: false,
      );
      return false;
    }
  }
}
