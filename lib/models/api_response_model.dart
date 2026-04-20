// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dalalat_quran_light/utils/response_state_enum.dart';

class ApiResponseModel<T> {
  T? data;
  String? errorMessage;
  ResponseEnum? response;
  ApiResponseModel({this.data, this.errorMessage, this.response = ResponseEnum.initial});

  ApiResponseModel<T> copyWith({T? data, String? errorMessage, ResponseEnum? response}) {
    return ApiResponseModel<T>(
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
      response: response ?? this.response,
    );
  }

  ApiResponseModel<T> modify({T? data, String? errorMessage, ResponseEnum? response}) {
    return ApiResponseModel<T>(
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
      response: response ?? this.response,
    );
  }

  @override
  String toString() =>
      'ApiResponseModel(data: $data, errorMessage: $errorMessage, response: $response)';
}
