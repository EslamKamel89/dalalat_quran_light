import 'package:dalalat_quran_light/utils/colors.dart';
import 'package:dalalat_quran_light/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../models/ayah_model.dart';
import 'tag_chip.dart';

class AyahCard extends StatelessWidget {
  final AyahModel ayah;
  final VoidCallback onTafsirTap;
  final Function(AyahTagModel tag) onTagTap;

  const AyahCard({
    super.key,
    required this.ayah,
    required this.onTafsirTap,
    required this.onTagTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: mediumGray.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Arabic text
            ArabicText(
              ayah.ayahText,
              textAlign: TextAlign.right,
              height: 2,
              // style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 1.8),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),

            const SizedBox(height: 8),

            const SizedBox(height: 10),

            /// Tags
            // if (ayah.tags.isNotEmpty)
            //   Wrap(
            //     spacing: 6,
            //     runSpacing: 6,
            //     children:
            //         ayah.tags
            //             .map((tag) => TagChip(label: tag.name, onTap: () => onTagTap(tag)))
            //             .toList(),
            //   ).animate().fadeIn(delay: 150.ms),
            if (ayah.tags.isNotEmpty)
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: ayah.tags
                      .map((tag) => TagChip(label: tag.name, onTap: () => onTagTap(tag)))
                      .toList(),
                ).animate().fadeIn(delay: 150.ms),
              ),

            const SizedBox(height: 12),

            /// Button
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: onTafsirTap,
                child: ArabicText('اذهب إلى التفسير', color: Colors.white),
              ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.9, 0.9)),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0);
  }
}
