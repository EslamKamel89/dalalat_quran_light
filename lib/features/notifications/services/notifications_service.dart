import 'package:dalalat_quran_light/features/notifications/models/notification_model.dart';
import 'package:dalalat_quran_light/models/api_response_model.dart';
import 'package:dalalat_quran_light/utils/api_service/dio_consumer.dart';
import 'package:dalalat_quran_light/utils/api_service/end_points.dart';
import 'package:dalalat_quran_light/utils/constants.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/servicle_locator.dart';

class NotificationsService {
  final DioConsumer api = serviceLocator<DioConsumer>();

  Future<ApiResponseModel<List<NotificationModel>>> fetchNotifications() async {
    final t = 'NotificationsService - fetchNotifications';
    final List response = await api.get(baseUrl() + EndPoint.notificationsIndex);
    pr(response.runtimeType, t);
    // try {
    final notifications = response.map((e) => NotificationModel.fromJson(e)).toList();

    return pr(ApiResponseModel(response: ResponseEnum.success, data: notifications), t);
    // } catch (e) {
    //   return pr(ApiResponseModel(response: ResponseEnum.failed, errorMessage: e.toString()), t);
    // }
  }
}
