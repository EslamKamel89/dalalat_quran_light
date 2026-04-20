import 'package:dalalat_quran_light/features/quran/entities/surah_entity.dart';
import 'package:dalalat_quran_light/features/quran/presentation/quran_reader_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SurahItem extends StatelessWidget {
  final SurahEntity surah;

  const SurahItem({super.key, required this.surah});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => QuranReaderView(surah: surah));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(surah.name, textAlign: TextAlign.right, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
