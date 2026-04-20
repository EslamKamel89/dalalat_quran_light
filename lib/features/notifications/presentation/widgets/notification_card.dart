import 'package:dalalat_quran_light/features/notifications/models/notification_model.dart';
import 'package:dalalat_quran_light/features/notifications/on_notification_click.dart';
import 'package:dalalat_quran_light/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_time_ago/get_time_ago.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const NotificationCard({super.key, required this.notification});

  IconData _getIcon() {
    switch (notification.path) {
      case "articles":
        return Icons.article;

      case "ayats":
        return Icons.menu_book;

      case "tags_equal":
      case "tags_meaning":
      case "tags_rules":
        return Icons.label;

      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    final createdAt = DateTime.parse(notification.createdAt!);

    final timeAgo = GetTimeAgo.parse(createdAt, locale: 'ar');

    return InkWell(
      onTap: () => onNotificationClick(notification),

      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),

        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: primaryColor,
              child: Icon(_getIcon(), color: Colors.white),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    notification.type ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),

                  const SizedBox(height: 4),

                  Text(notification.content ?? "", style: const TextStyle(color: Colors.black)),

                  const SizedBox(height: 6),

                  Text(timeAgo, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2);
  }
}
