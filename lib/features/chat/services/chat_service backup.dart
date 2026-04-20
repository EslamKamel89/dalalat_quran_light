// import 'package:dio/dio.dart';
// import 'package:dalalat_quran_light/env.dart';
// import 'package:dalalat_quran_light/utils/constants.dart';
// import 'package:dalalat_quran_light/utils/print_helper.dart';
// import 'package:dalalat_quran_light/utils/servicle_locator.dart';

// class ChatService {
//   final Dio dio = serviceLocator();
//   final addMessageEndpoint = "${baseUrl()}ai";
//   final addRatingEndpoint = "${baseUrl()}update";
//   ChatService();

//   Future<String> ask(String question) async {
//     try {
//       dio.options.headers = {
//         'Authorization': 'Bearer ${Env.apiKey}',
//         'OpenAI-Beta': 'assistants=v2',
//         'Content-Type': 'application/json',
//       };
//       // Step 1: Create thread
//       final threadResponse = await dio.post('https://api.openai.com/v1/threads');
//       final threadId = threadResponse.data['id'];
//       // Step 2: Add user message
//       await dio.post(
//         'https://api.openai.com/v1/threads/$threadId/messages',
//         data: {'role': 'user', 'content': question},
//       );

//       // Step 3: Start assistant run
//       final runResponse = await dio.post(
//         'https://api.openai.com/v1/threads/$threadId/runs',
//         data: {'assistant_id': Env.assistantId},
//       );
//       final runId = runResponse.data['id'];

//       // Step 4: Poll until completed
//       String status = '';
//       int attempt = 0;
//       const int maxAttempts = 60;

//       do {
//         await Future.delayed(Duration(seconds: 1));
//         final statusResponse = await dio.get(
//           'https://api.openai.com/v1/threads/$threadId/runs/$runId',
//         );
//         status = statusResponse.data['status'];
//         attempt++;
//       } while (status != 'completed' && attempt < maxAttempts);

//       if (status != 'completed') {
//         throw Exception('Assistant did not respond in time.');
//       }

//       // Step 5: Fetch messages
//       final messagesResponse = await dio.get(
//         'https://api.openai.com/v1/threads/$threadId/messages',
//       );
//       final List messages = messagesResponse.data['data'];

//       for (var message in messages) {
//         if (message['role'] == 'assistant') {
//           return message['content'][0]['text']['value'] ?? 'No reply found.';
//         }
//       }

//       return 'No assistant reply found.';
//     } on Exception catch (e) {
//       return 'Dio error: $e';
//     } catch (e) {
//       return 'Error: $e';
//     }
//   }

//   Future<String?> getId(String question, String answer) async {
//     dio.options.headers = {'Content-Type': 'application/json'};
//     final t = "ChatService - getId";
//     try {
//       final response = await dio.post(
//         addMessageEndpoint,
//         data: {"question": question, "answer": answer},
//       );
//       return pr(response.data['id'], t);
//     } catch (e) {
//       pr(e, t);
//     }

//     return null;
//   }

//   Future<String?> addRating(int rate, String comment, String id) async {
//     dio.options.headers = {'Content-Type': 'application/json'};
//     final t = "ChatService - addRating";
//     try {
//       final response = await dio.put(
//         "$addRatingEndpoint/$id",
//         data: {"rate": rate, "comment": comment},
//       );
//       return pr(response.data['id'], t);
//     } catch (e) {
//       pr(e, t);
//     }

//     return null;
//   }
// }
