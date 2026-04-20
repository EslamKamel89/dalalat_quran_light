import 'dart:convert';

import 'package:dalalat_quran_light/db/database_helper.dart';
import 'package:dalalat_quran_light/models/video_model.dart';
import 'package:dalalat_quran_light/utils/api_service/dio_consumer.dart';
import 'package:dalalat_quran_light/utils/constants.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/servicle_locator.dart';
import 'package:get/get.dart';

abstract class VideoControllerData {
  static List<VideoModel> allVideos = [];
  static List<VideoModel> filteredVideosList = [];
}

class VideoController extends GetxController {
  final DataBaseHelper databaseHelper = DataBaseHelper.dataBaseInstance();
  String getVidoesEndPoint = 'videos';
  ResponseEnum responseState = ResponseEnum.initial;

  Future<void> getAllVideos() async {
    VideoControllerData.allVideos = [];
    // VideoControllerData.allVideos = await databaseHelper.getAllVideosRaw();
    VideoControllerData.allVideos = await getAllVideosApi();
    VideoControllerData.filteredVideosList = VideoControllerData.allVideos;
    update();
  }

  void search(String key) {
    VideoControllerData.filteredVideosList =
        VideoControllerData.allVideos
            .where(
              (x) =>
                  x.toString().toLowerCase().trim().contains(key.toLowerCase()),
            )
            .toList();
    update();
  }

  Future getAllVideosApi() async {
    const t = 'getAllVideosApi - VideoController';
    DioConsumer dioConsumer = serviceLocator();
    String path = baseUrl() + getVidoesEndPoint;
    String deviceLocale = Get.locale?.languageCode ?? 'ar';
    responseState = ResponseEnum.loading;
    update();
    try {
      final response = await dioConsumer.get("$path/0/999999999/$deviceLocale");
      List data = jsonDecode(response);
      pr(data, '$t - raw response');
      if (data.isEmpty) {
        responseState = ResponseEnum.success;
        pr('No tags found', t);
        VideoControllerData.allVideos = [];
        VideoControllerData.filteredVideosList = [];
        update();
        return;
      }
      // await cacheExplanation(id: id, explanation: explanation);
      List<VideoModel> videos =
          data.map<VideoModel>((json) => VideoModel.fromJson(json)).toList();
      pr(videos, '$t - parsed response');
      responseState = ResponseEnum.success;
      VideoControllerData.allVideos = videos;
      VideoControllerData.filteredVideosList = videos;
      update();
      return;
    } on Exception catch (e) {
      pr('Exception occured: $e', t);
      responseState = ResponseEnum.failed;
      VideoControllerData.allVideos = [];
      VideoControllerData.filteredVideosList = [];
      update();
      return;
    }
  }
}
