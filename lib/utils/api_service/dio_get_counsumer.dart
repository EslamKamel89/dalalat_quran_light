// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dio/dio.dart';
import 'package:dalalat_quran_light/utils/api_service/api_interceptors.dart';
import 'package:dalalat_quran_light/utils/constants.dart';

class DioGetConsumer {
  final Dio dio;
  CancelToken? cancelToken;
  DioGetConsumer({required this.dio}) {
    dio.options.baseUrl = baseUrl();
    dio.interceptors.add(DioInterceptor()); // i use the interceptor to add the header
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  @override
  Future get(String path, {Map<String, dynamic>? queryParameter}) async {
    try {
      if (cancelToken != null) {
        cancelToken?.cancel();
      }
      cancelToken = CancelToken();
      final response = await dio.get(
        path,
        queryParameters: queryParameter,
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
