// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:dalalat_quran_light/controllers/settings_controller.dart';
import 'package:dalalat_quran_light/utils/api_service/dio_consumer.dart';
import 'package:dalalat_quran_light/utils/constants.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:dalalat_quran_light/utils/servicle_locator.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class Version {
  static const String APPLE_STORE_URL =
      "https://apps.apple.com/us/app/%D8%AF%D9%84%D8%A7%D9%84%D8%A7%D8%AA-%D8%A7%D9%84%D9%82%D8%B1%D8%A2%D9%86/id6736754081";
  static const String GOOGLE_STORE_URL =
      "https://play.google.com/store/apps/details?id=com.dubdev.dallalat";

  static const String IOS_VERSION = "1.0.57";
  static const String ANDROID_VERSION = "1.0.30";
  static const DEBUG = false;

  static final DioConsumer _dio = serviceLocator<DioConsumer>();

  static Future<VersionModel?> getLatestVersion() async {
    final t = 'checkVersion - Version';
    try {
      final response = await _dio.get("${baseUrl()}app-version");

      pr(response, '$t - response');
      final VersionModel latestVersion = VersionModel.fromJson(response);
      return pr(latestVersion, t);
    } catch (e) {
      String errorMessage = e.toString();
      pr(errorMessage, t);
      return null;
    }
  }

  static Future<void> checkVersions() async {
    SettingsController settingController = Get.find<SettingsController>();
    if (DEBUG || !settingController.showNotifications) return;
    final VersionModel? latestVersion = await getLatestVersion();
    if (latestVersion == null || latestVersion.active == 0) return;

    if (Platform.isAndroid) {
      if (latestVersion.android != null && latestVersion.android != ANDROID_VERSION) {
        _showUpdateDialog(
          storeUrl: GOOGLE_STORE_URL,
          title: "تحديث جديد متوفر",
          description:
              "يتوفر الآن إصدار جديد من تطبيق دلالات القرآن.\nننصحك بتحديث التطبيق للاستفادة من آخر التحسينات والإصلاحات.",
        );
      }
    } else if (Platform.isIOS) {
      if (latestVersion.ios != null && latestVersion.ios != IOS_VERSION) {
        _showUpdateDialog(
          storeUrl: APPLE_STORE_URL,
          title: "تحديث جديد متوفر",
          description:
              "يتوفر الآن إصدار جديد من تطبيق دلالات القرآن.\nيرجى التحديث للاستفادة من أحدث المزايا والتحسينات.",
        );
      }
    }
  }

  static void _showUpdateDialog({
    required String storeUrl,
    required String title,
    required String description,
  }) {
    Get.defaultDialog(
      title: title,
      middleText: description,
      textConfirm: "تحديث الآن",
      textCancel: "لاحقًا",
      barrierDismissible: false,
      onConfirm: () async {
        final uri = Uri.parse(storeUrl);
        try {
          if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
            pr("Could not launch $uri", "Version._showUpdateDialog");
          }
        } catch (e) {
          pr("Error launching store URL: $e", "Version._showUpdateDialog");
        } finally {
          if (Get.isDialogOpen ?? false) {
            Get.back();
          }
        }
      },
      onCancel: () {},
    );
  }
}

class VersionModel {
  String? android;
  String? ios;
  int? active;

  VersionModel({this.android, this.ios, this.active});

  @override
  String toString() => 'VersionModel(android: $android, ios: $ios , active: $active)';

  factory VersionModel.fromJson(Map<String, dynamic> json) => VersionModel(
    android: json['android'] as String?,
    ios: json['ios'] as String?,
    active: json['active'] as int?,
  );

  Map<String, dynamic> toJson() => {'android': android, 'ios': ios, 'active': active};
}
