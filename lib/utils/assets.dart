import 'package:dalalat_quran_light/utils/current_locales.dart';

class AssetsData {
  static const String _relativePath = 'assets/images';
  static const String loading = "$_relativePath/loading.json";
  static const String logoSmall = "$_relativePath/logo_small.png";
  static const String researchLogo = "$_relativePath/research.png";
  static const String questionLogo = "$_relativePath/questions.png";
  static const String researchLogoB = "$_relativePath/research_b.png";
  static const String search = "$_relativePath/search.png";
  static const String researchIcon3 = "$_relativePath/research_3.png";
  // static const String inheritanceIcon = "$_relativePath/inheritance.png";
  static const String centerViewMain = "$_relativePath/center_view_3.png";
  static const String centerViewMainEn = "$_relativePath/center_view_3_en.png";
  static String centerViewCenterA() =>
      isArabic() ? "$_relativePath/center_view_4.png" : "$_relativePath/center_view_4_en.png";
  static String centerViewCenterB() =>
      isArabic() ? "$_relativePath/center_view_5.png" : "$_relativePath/center_view_5_en.png";
  static const String chatBackground = "$_relativePath/chat_background.png";
  static const String thinking = "$_relativePath/answer_icon.png";
  static const String grammar = "$_relativePath/grammer_new_3.png";
  static const String islamicCalender1 = "$_relativePath/islamic_calender_1.png";
  static const String islamicCalender2 = "$_relativePath/islamic_calender_2.png";
  static const String islamicCalender3 = "$_relativePath/islamic_calender_3.png";
  static const String islamicCalender4 = "$_relativePath/islamic_calender_4.png";
  static const String inheritanceIcon = "$_relativePath/inheritance_icon.png";
  static const String inheritance1 = "$_relativePath/inheritance_1.png";
  static const String inheritance2 = "$_relativePath/inheritance_2.png";
  static const String inheritance3 = "$_relativePath/inheritance_3.png";
  static const String inheritance4 = "$_relativePath/inheritance_4.png";
  static const String inheritance5 = "$_relativePath/inheritance_5.png";
  static const String inheritance6 = "$_relativePath/inheritance_6.png";
  static const String logoNav = "$_relativePath/logo_nav.png";
  static const String islamicCalenderLogo = "$_relativePath/islamic_calender_logo.png";
}
