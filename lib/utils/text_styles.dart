import 'package:dalalat_quran_light/controllers/settings_controller.dart';
import 'package:dalalat_quran_light/ui/settings_screen/setting_screen.dart';
import 'package:dalalat_quran_light/utils/calc_font_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Map<String, Style> mainHtmlStyle() => {
  '#': Style(
    fontFamily: "Amiri",
    textAlign: TextAlign.justify,
    fontSize: Get.find<SettingsController>().fontTypeEnum == FontType.normal
        ? FontSize(calcFontSize(14))
        : FontSize(calcFontSize(18)),
    padding: HtmlPaddings(left: HtmlPadding(0), right: HtmlPadding(0)),
    margin: Margins(left: Margin(0), right: Margin(0)),
    //   color: primaryColor,
    lineHeight: LineHeight.number(1.2),
  ),
};

class DefaultText extends StatelessWidget {
  const DefaultText(this.txt, {super.key, this.fontSize = 15, this.color = Colors.black});
  final String txt;
  final double fontSize;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: TextStyle(fontSize: fontSize, fontFamily: "Almarai", color: color),
    );
  }
}

class ArabicText extends StatelessWidget {
  const ArabicText(
    this.txt, {
    super.key,
    this.fontSize = 17,
    this.color = Colors.black,
    this.maxLines,
    this.textAlign,
    this.height,
    this.fontWeight,
  });
  final String txt;
  final double fontSize;
  final Color color;
  final int? maxLines;
  final TextAlign? textAlign;
  final double? height;
  final FontWeight? fontWeight;
  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      maxLines: maxLines,
      textAlign: textAlign,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontFamily: "Amiri",
        color: color,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
        height: height,
      ),
    );
  }
}

class ArabicTextGF extends StatelessWidget {
  const ArabicTextGF(
    this.txt, {
    super.key,
    this.fontSize = 17,
    this.color = Colors.black,
    this.maxLines,
    this.textAlign,
    this.height,
    this.fontWeight,
  });

  final String txt;
  final double fontSize;
  final Color color;
  final int? maxLines;
  final TextAlign? textAlign;
  final double? height;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      maxLines: maxLines,
      textAlign: textAlign,
      // style: GoogleFonts.amiri(
      style: GoogleFonts.cairo(
        // style: GoogleFonts.tajawal(
        // style: GoogleFonts.scheherazadeNew(
        // style: GoogleFonts.elMessiri(
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: color,
        height: height,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
      ),
    );
  }
}
