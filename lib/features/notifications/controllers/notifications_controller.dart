import 'package:dalalat_quran_light/features/notifications/models/notification_model.dart';
import 'package:dalalat_quran_light/features/notifications/services/notifications_service.dart';
import 'package:dalalat_quran_light/models/api_response_model.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/servicle_locator.dart';
import 'package:get/get.dart';

class NotificationsController extends GetxController {
  final NotificationsService service = serviceLocator<NotificationsService>();

  ApiResponseModel<List<NotificationModel>> notifications = ApiResponseModel(
    response: ResponseEnum.initial,
  );

  Future fetchNotifications() async {
    notifications = notifications.copyWith(response: ResponseEnum.loading, errorMessage: null);

    update();

    final response = await service.fetchNotifications();

    notifications = response;

    update();
  }
}
