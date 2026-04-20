import 'package:dalalat_quran_light/features/words/models/quran_word/quran_word.dart';
import 'package:dalalat_quran_light/features/words/utils/highlight_helper.dart';
import 'package:dalalat_quran_light/features/words/utils/surah_names.dart';
import 'package:dalalat_quran_light/utils/colors.dart';
import 'package:dalalat_quran_light/utils/share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuranAyahCard extends StatelessWidget {
  final List<QuranWordModel> words;
  final String? selectedToken;

  const QuranAyahCard({super.key, required this.words, this.selectedToken});

  @override
  Widget build(BuildContext context) {
    final ayah = words.first.ayah!;

    final highlightToken = selectedToken ?? words.first.tokenUthmani!;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: lightGray, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                "سورة ${SurahNames.map[ayah.surahNo] ?? ''} - آية ${ayah.ayahNo}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

              Row(
                children: [
                  /// COPY BUTTON
                  IconButton(
                    icon: const Icon(Icons.copy, color: primaryColor),
                    onPressed: () async {
                      final text =
                          "سورة ${SurahNames.map[ayah.surahNo] ?? ''} - آية ${ayah.ayahNo}\n${ayah.textUthmani ?? ''}";

                      await Clipboard.setData(ClipboardData(text: text));

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("تم نسخ الآية", style: TextStyle(color: Colors.white)),
                          duration: Duration(seconds: 2),
                          backgroundColor: primaryColor,
                        ),
                      );
                    },
                  ),

                  /// SHARE BUTTON (existing)
                  IconButton(
                    icon: const Icon(Icons.share, color: primaryColor),
                    onPressed: () {
                      ShareUtil.share(
                        header: "سورة ${SurahNames.map[ayah.surahNo] ?? ''} - آية ${ayah.ayahNo}",
                        content: ayah.textUthmani ?? '',
                        subject: "سورة ${SurahNames.map[ayah.surahNo] ?? ''} - آية ${ayah.ayahNo}",
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: RichText(
              textAlign: TextAlign.right,
              text: TextSpan(
                children: HighlightHelper.buildHighlightedText(
                  ayah.textUthmani!,
                  highlightToken,
                  const TextStyle(color: Colors.black, fontSize: 22),
                  const TextStyle(color: Colors.blue, fontSize: 22),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
