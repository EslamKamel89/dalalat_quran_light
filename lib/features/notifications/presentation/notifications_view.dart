import 'package:dalalat_quran_light/features/notifications/controllers/notifications_controller.dart';
import 'package:dalalat_quran_light/features/notifications/presentation/widgets/notification_card.dart';
import 'package:dalalat_quran_light/utils/colors.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/widgets/quran_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  late final NotificationsController controller;

  @override
  void initState() {
    controller = Get.find<NotificationsController>();

    controller.fetchNotifications();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGray2,

      appBar: QuranBar("الإشعارات"),

      body: GetBuilder<NotificationsController>(
        builder: (_) {
          final state = controller.notifications;

          if (state.response == ResponseEnum.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.data == null || state.data!.isEmpty) {
            return const Center(child: Text("لا توجد إشعارات"));
          }

          final notifications = state.data!;

          return ListView.builder(
            itemCount: notifications.length,

            itemBuilder: (_, index) {
              return NotificationCard(notification: notifications[index]);
            },
          );
        },
      ),
    );
  }
}
