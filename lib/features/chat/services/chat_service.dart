// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:dalalat_quran_light/env.dart';
import 'package:dalalat_quran_light/models/api_response_model.dart';
import 'package:dalalat_quran_light/models/ticket_model.dart';
import 'package:dalalat_quran_light/utils/api_service/end_points.dart';
import 'package:dalalat_quran_light/utils/constants.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/servicle_locator.dart';
import 'package:dalalat_quran_light/utils/shared_prefrences_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatService {
  final Dio dio = serviceLocator();
  final addMessageEndpoint = "${baseUrl()}ai";
  final addRatingEndpoint = "${baseUrl()}update";
  final storage = serviceLocator<SharedPreferences>();
  ChatService();

  Future<ChatResponse> ask(String question, String token) async {
    final t = 'ask - ChatService';

    // String ans = await Get.find<ExplanationController>().getCachedExplanation(id: "7");
    // ans = await structureTextToHtml(
    //   pr(cleanReply(ans, removeHtml: true, showComment: false), 'result string'),
    // );
    // return ChatResponse(text: ans);

    final stageOne = await initTicket(question: question, token: token);
    if (stageOne.response != ResponseEnum.success) {
      return ChatResponse(
        text: "عذرًا، حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى لاحقًا.",
        source: 'rag',
      );
      // return ChatResponse(text: stageOne.errorMessage, source: 'rag');
      // final openAiResponse = await openAi(question);
      // return ChatResponse(text: openAiResponse, source: 'openai');
    }
    if (stageOne.data?.status?.toLowerCase() == 'finished') {
      return ChatResponse(text: stageOne.data?.answer, source: 'log');
    }
    triggerRag(question: question, token: token);
    // int count = 30;
    int count = 1000;
    for (var i = 0; i < count; i++) {
      await Future.delayed(Duration(seconds: 2));
      final stageTwo = await checkTicket(question: question, token: token);
      if (stageTwo.response == ResponseEnum.failed ||
          stageTwo.data?.status?.toLowerCase() == 'failed') {
        return ChatResponse(
          text: "عذرًا، حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى لاحقًا.",
          source: 'rag',
        );
        // return ChatResponse(text: stageTwo.errorMessage, source: 'rag');
        // final openAiResponse = await openAi(question);
        // return ChatResponse(text: openAiResponse, source: 'openai');
      }
      if (stageTwo.data?.status?.toLowerCase() == 'finished') {
        return ChatResponse(text: stageTwo.data?.answer, source: 'rag');
      }
    }
    return ChatResponse(
      text: "عذرًا، حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى لاحقًا.",
      source: 'rag',
    );
    // return ChatResponse(text: "Something went wrong", source: 'rag');
    // final openAiResponse = await openAi(question);
    // return ChatResponse(text: openAiResponse, source: 'openai');
  }

  Future<ApiResponseModel<int>> initSession() async {
    final t = 'initSession - ChatService';
    try {
      final response = (await dio.get(EndPoint.initSession)).data;
      pr(response, '$t - response');
      return pr(ApiResponseModel(response: ResponseEnum.success, data: response?['userid']), t);
    } catch (e) {
      String errorMessage = e.toString();
      return pr(ApiResponseModel(errorMessage: errorMessage, response: ResponseEnum.failed), t);
    }
  }

  Future<ApiResponseModel<TicketModel>> initTicket({
    required String question,
    required String token,
  }) async {
    final t = 'initTicket - ChatService';
    try {
      final response = (await dio.post(
        EndPoint.initTicket,
        data: {
          "userid": storage.getInt(ShPrefKey.serverUserSession),
          "question": question,
          'token': token,
        },
      )).data;
      pr(response, '$t - response');
      final model = TicketModel.fromJson(response);
      return pr(ApiResponseModel(response: ResponseEnum.success, data: model), t);
    } catch (e) {
      String errorMessage = e.toString();
      return pr(ApiResponseModel(errorMessage: errorMessage, response: ResponseEnum.failed), t);
    }
  }

  Future triggerRag({required String question, required String token}) async {
    final t = 'triggerRag - ChatService';
    try {
      final response = (await dio.post(
        EndPoint.generate,
        data: {
          "userid": storage.getInt(ShPrefKey.serverUserSession),
          "question": question,
          'token': token,
        },
      )).data;
      pr(response, '$t - response');
    } catch (e) {
      String errorMessage = e.toString();
      pr(ApiResponseModel(errorMessage: errorMessage, response: ResponseEnum.failed), t);
    }
  }

  Future<ApiResponseModel<TicketModel>> checkTicket({
    required String question,
    required String token,
  }) async {
    final t = 'checkTicket - ChatService';
    try {
      final response = (await dio.post(
        EndPoint.checkTicket,
        data: {
          "userid": storage.getInt(ShPrefKey.serverUserSession),
          "question": question,
          'token': token,
        },
      )).data;
      pr(response, '$t - response');
      final model = TicketModel.fromJson(response);
      return pr(ApiResponseModel(response: ResponseEnum.success, data: model), t);
    } catch (e) {
      String errorMessage = e.toString();
      return pr(ApiResponseModel(errorMessage: errorMessage, response: ResponseEnum.failed), t);
    }
  }

  Future<String> openAi(String question) async {
    // return '';
    try {
      dio.options.headers = {
        'Authorization': 'Bearer ${Env.apiKey}',
        'OpenAI-Beta': 'assistants=v2',
        'Content-Type': 'application/json',
      };
      // Step 1: Create thread
      final threadResponse = await dio.post('https://api.openai.com/v1/threads');
      final threadId = threadResponse.data['id'];
      // Step 2: Add user message
      await dio.post(
        'https://api.openai.com/v1/threads/$threadId/messages',
        data: {'role': 'user', 'content': question},
      );

      // Step 3: Start assistant run
      final runResponse = await dio.post(
        'https://api.openai.com/v1/threads/$threadId/runs',
        data: {'assistant_id': Env.assistantId},
      );
      final runId = runResponse.data['id'];

      // Step 4: Poll until completed
      String status = '';
      int attempt = 0;
      const int maxAttempts = 60;

      do {
        await Future.delayed(Duration(seconds: 1));
        final statusResponse = await dio.get(
          'https://api.openai.com/v1/threads/$threadId/runs/$runId',
        );
        status = statusResponse.data['status'];
        attempt++;
      } while (status != 'completed' && attempt < maxAttempts);

      if (status != 'completed') {
        throw Exception('Assistant did not respond in time.');
      }

      // Step 5: Fetch messages
      final messagesResponse = await dio.get(
        'https://api.openai.com/v1/threads/$threadId/messages',
      );
      final List messages = messagesResponse.data['data'];

      for (var message in messages) {
        if (message['role'] == 'assistant') {
          return message['content'][0]['text']['value'] ?? 'No reply found.';
        }
      }

      return 'No assistant reply found.';
    } on Exception catch (e) {
      return 'Dio error: $e';
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<String?> getId(String question, String answer, String source) async {
    dio.options.headers = {'Content-Type': 'application/json'};
    final t = "ChatService - getId";
    try {
      final response = await dio.post(
        addMessageEndpoint,
        data: {"question": question, "answer": answer, 'type': source},
      );
      return pr(response.data['id'], t);
    } catch (e) {
      pr(e, t);
    }

    return null;
  }

  Future<String?> addRating(int rate, String comment, String id) async {
    dio.options.headers = {'Content-Type': 'application/json'};
    final t = "ChatService - addRating";
    try {
      final response = await dio.put(
        "$addRatingEndpoint/$id",
        data: {"rate": rate, "comment": comment},
      );
      return pr(response.data['id'], t);
    } catch (e) {
      pr(e, t);
    }

    return null;
  }
}

class ChatResponse {
  String? text;
  String? source; // log , rag , openai
  ChatResponse({this.text, this.source});
}
