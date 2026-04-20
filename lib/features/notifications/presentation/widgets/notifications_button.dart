import 'package:dalalat_quran_light/features/notifications/presentation/notifications_view.dart';
import 'package:dalalat_quran_light/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class NotificationsButton extends StatelessWidget {
  const NotificationsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
          onTap: () {
            Get.to(() => const NotificationsView());
          },
          borderRadius: BorderRadius.circular(30),

          child: Container(
            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),

            child: const Icon(Icons.notifications, color: Colors.white, size: 26),
          ),
        )
        // animation
        .animate()
        .scale(duration: 250.ms)
        .fadeIn(duration: 400.ms)
        .shimmer(duration: 2000.ms, delay: 2000.ms);
  }
}
