import 'dart:convert';

import 'package:dalalat_quran_light/features/discussions/models/discussion_model/discussion_model.dart';
import 'package:dalalat_quran_light/features/discussions/models/discussion_model/thoughtful_model.dart';
import 'package:dalalat_quran_light/models/api_response_model.dart';
import 'package:dalalat_quran_light/utils/api_service/dio_consumer.dart';
import 'package:dalalat_quran_light/utils/constants.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/servicle_locator.dart';
import 'package:dalalat_quran_light/utils/shared_prefrences_key.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DiscussionController extends GetxController {
  final localStorage = serviceLocator<SharedPreferences>();
  final api = serviceLocator<DioConsumer>();
  final loginRes = ApiResponseModel<bool>().obs;
  final registerRes = ApiResponseModel<bool>().obs;
  final discussionsRes = ApiResponseModel<List<DiscussionModel>>().obs;
  Future<ApiResponseModel<bool>> login(String? email, String? password) async {
    const t = 'login - DiscussionController';
    try {
      String path = baseUrl() + 'login';
      loginRes.value = ApiResponseModel(response: ResponseEnum.loading);
      final response = await api.post(path, data: {'email': email, 'password': password});
      if (response is Map && response['access_token'] != null && response['user'] is Map) {
        localStorage.setString(ShPrefKey.token, response['access_token'] as String);
        localStorage.setString(ShPrefKey.user, jsonEncode(response['user']));
        loginRes.value = ApiResponseModel(response: ResponseEnum.success, data: true);
      } else {
        loginRes.value = ApiResponseModel(
          response: ResponseEnum.failed,
          errorMessage: "couldn't parse the server response",
        );
      }
    } catch (e) {
      loginRes.value = ApiResponseModel(response: ResponseEnum.failed, errorMessage: e.toString());
    }
    return pr(loginRes.value, t);
  }

  Future<ApiResponseModel<bool>> register({
    required String? name,
    required String? email,
    required String? password,
    required String? description,
    required String? mobile,
  }) async {
    const t = 'register - DiscussionController';
    try {
      String path = baseUrl() + 'register';
      registerRes.value = ApiResponseModel(response: ResponseEnum.loading);
      final response = await api.post(
        path,
        data: {
          "name": name,
          "email": email,
          "password": password,
          "description": description,
          "mobile": mobile,
        },
      );
      if (response is Map && response['access_token'] != null) {
        localStorage.setString(ShPrefKey.token, response['access_token'] as String);
        registerRes.value = ApiResponseModel(response: ResponseEnum.success, data: true);
      } else {
        registerRes.value = ApiResponseModel(
          response: ResponseEnum.failed,
          errorMessage: "couldn't parse the server response",
        );
      }
    } catch (e) {
      registerRes.value = ApiResponseModel(
        response: ResponseEnum.failed,
        errorMessage: e.toString(),
      );
    }
    return pr(registerRes.value, t);
  }

  Future<ApiResponseModel<List<DiscussionModel>>> discussions() async {
    const t = 'register - DiscussionController';
    _setAuthorizationHeader();
    try {
      String path = baseUrl() + 'discussions';
      discussionsRes.value = discussionsRes.value.copyWith(response: ResponseEnum.loading);
      final response = await api.get(path);
      final List<DiscussionModel> models = (response as List)
          .map((json) => DiscussionModel.fromJson(json))
          .toList();
      discussionsRes.value = ApiResponseModel(response: ResponseEnum.success, data: models);
    } catch (e) {
      discussionsRes.value = ApiResponseModel(
        response: ResponseEnum.failed,
        errorMessage: e.toString(),
      );
    }
    return pr(discussionsRes.value, t);
  }

  Future<ApiResponseModel<bool>> addComment(int? discussionId, String? comment) async {
    const t = 'addComment - DiscussionController';
    _setAuthorizationHeader();
    try {
      String path = baseUrl() + 'discussion-comment';
      final response = await api.post(
        path,
        data: {'comment': comment, 'discussion_id': discussionId},
      );
      pr(response, t);
      return ApiResponseModel(response: ResponseEnum.success, data: true);
    } catch (e) {
      pr(e.toString(), t);
      return ApiResponseModel(response: ResponseEnum.failed, errorMessage: e.toString());
    }
  }

  Future<ApiResponseModel<bool>> updateComment(
    int? discussionId,
    int? commentId,
    String? comment,
  ) async {
    const t = 'updateComment - DiscussionController';
    _setAuthorizationHeader();
    try {
      String path = baseUrl() + 'discussion-comment/$commentId';
      final response = await api.put(
        path,
        data: {'comment': comment, 'discussion_id': discussionId},
      );
      pr(response, t);
      return ApiResponseModel(response: ResponseEnum.success, data: true);
    } catch (e) {
      pr(e.toString(), t);
      return ApiResponseModel(response: ResponseEnum.failed, errorMessage: e.toString());
    }
  }

  Future<ApiResponseModel<bool>> deleteComment(int? commentId) async {
    const t = 'deleteComment - DiscussionController';
    _setAuthorizationHeader();
    try {
      String path = baseUrl() + 'discussion-comment/$commentId';
      final response = await api.delete(path);
      pr(response, t);
      return ApiResponseModel(response: ResponseEnum.success, data: true);
    } catch (e) {
      pr(e.toString(), t);
      return ApiResponseModel(response: ResponseEnum.failed, errorMessage: e.toString());
    }
  }

  Future<ApiResponseModel<bool>> addLike(int? commentId) async {
    const t = 'addLike - DiscussionController';
    _setAuthorizationHeader();
    try {
      String path = baseUrl() + 'discussion-comment-react';
      final response = await api.post(path, data: {"comment_id": commentId});
      pr(response, t);
      return ApiResponseModel(response: ResponseEnum.success, data: true);
    } catch (e) {
      pr(e.toString(), t);
      return ApiResponseModel(response: ResponseEnum.failed, errorMessage: e.toString());
    }
  }

  Future<ApiResponseModel<bool>> removeLike(int? commentId) async {
    const t = 'removeLike - DiscussionController';
    _setAuthorizationHeader();
    try {
      String path = baseUrl() + 'discussion-comment-react/$commentId';
      final response = await api.delete(path);
      pr(response, t);
      return ApiResponseModel(response: ResponseEnum.success, data: true);
    } catch (e) {
      pr(e.toString(), t);
      return ApiResponseModel(response: ResponseEnum.failed, errorMessage: e.toString());
    }
  }

  void _setAuthorizationHeader() {
    final String? token = localStorage.getString(ShPrefKey.token);
    if (token == null) {
      api.dio.options.headers.remove('Authorization');
    } else {
      api.dio.options.headers.addAll({"Authorization": 'Bearer $token'});
    }
  }
}

bool isSignedIn() {
  final localStorage = serviceLocator<SharedPreferences>();
  return localStorage.getString(ShPrefKey.token) != null;
}

ThoughtfulModel? getCurrentUser() {
  final localStorage = serviceLocator<SharedPreferences>();
  final userStr = localStorage.getString(ShPrefKey.user);
  if (userStr == null) return null;
  return ThoughtfulModel.fromJson(jsonDecode(userStr));
}

void logout() {
  final localStorage = serviceLocator<SharedPreferences>();
  localStorage.remove(ShPrefKey.token);
  localStorage.remove(ShPrefKey.user);
}
