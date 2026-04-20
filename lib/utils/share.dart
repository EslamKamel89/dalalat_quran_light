// ignore_for_file: constant_identifier_names

import 'package:dalalat_quran_light/controllers/settings_controller.dart';
import 'package:dalalat_quran_light/db/database_helper.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class ShareUtil {
  static const String APPLE_STORE_URL =
      "https://apps.apple.com/us/app/%D8%AF%D9%84%D8%A7%D9%84%D8%A7%D8%AA-%D8%A7%D9%84%D9%82%D8%B1%D8%A2%D9%86/id6736754081";
  static const String GOOGLE_STORE_URL =
      "https://play.google.com/store/apps/details?id=com.dubdev.dallalat";
  static final SettingsController _controller = Get.find<SettingsController>();
  static Future<void> share({
    required String header,
    required String content,
    required String subject,
  }) async {
    final cleanContent = contentWithNoTags(content);

    final String shareContent = buildShareContent(header: header, content: cleanContent);

    await Share.share(shareContent, subject: subject);
  }

  static String buildShareContent({required String header, required String content}) {
    String appDetails =
        '''
──────────────────
📱 حمِّل تطبيق *دلالات القرآن* الآن:

🍏 لأجهزة iOS:
$APPLE_STORE_URL

🤖 لأجهزة أندرويد:
$GOOGLE_STORE_URL
''';
    return '''
تمت مشاركة هذا المحتوى عبر تطبيق *دلالات القرآن*
${_controller.showAppDetails ? appDetails : ''}
──────────────────
📖 $header
──────────────────
$content
──────────────────
''';
  }

  static String contentWithNoTags(String content) {
    return DataBaseHelper().parseHtmlString(content);
  }
}
