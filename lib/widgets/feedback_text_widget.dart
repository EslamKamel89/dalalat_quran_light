import 'package:dalalat_quran_light/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FeedbackTextWidget extends StatelessWidget {
  final VoidCallback onTap;
  final double horizontalPadding;
  const FeedbackTextWidget({super.key, required this.onTap, this.horizontalPadding = 5});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: horizontalPadding),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 16, color: Colors.black),
              children: [
                const TextSpan(
                  text:
                      "هذا جهدنا في التدبر، فإن كان لديكم ما هو أدق أو أفضل، فنسعد باستلامه منكم عند ",
                ),
                TextSpan(
                  text: "الضغط هنا ",
                  style: const TextStyle(
                    color: Colors.black,
                    // decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 1000.ms);
  }
}
