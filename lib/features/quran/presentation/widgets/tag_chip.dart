import 'package:dalalat_quran_light/utils/colors.dart';
import 'package:dalalat_quran_light/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TagChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const TagChip({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: onTap,
        child:
            Chip(
                  backgroundColor: lightGray,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  label: ArabicText(
                    label,
                    // style: const TextStyle(color: primaryColor, fontWeight: FontWeight.w500),
                  ),
                )
                .animate()
                .fadeIn(duration: 300.ms)
                .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
      ),
    );
  }
}
