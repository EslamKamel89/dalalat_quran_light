import 'dart:convert';

import 'package:dalalat_quran_light/features/chat/controller/chat_state.dart';
import 'package:dalalat_quran_light/features/chat/models/chat_history_entity.dart';
import 'package:dalalat_quran_light/features/chat/models/chat_message_entity.dart';
import 'package:dalalat_quran_light/features/chat/services/chat_service.dart';
import 'package:dalalat_quran_light/utils/generate_random_token.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/servicle_locator.dart';
import 'package:dalalat_quran_light/utils/shared_prefrences_key.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatController extends GetxController {
  final ChatService service = serviceLocator();
  final storage = serviceLocator<SharedPreferences>();
  ChatState state = ChatState(messages: [], conversationsInHistory: []);
  void init() async {
    List<String> conversationsInHistoryJson =
        storage.getStringList(ShPrefKey.chatHistoryData) ?? [];
    List<ChatHistoryEntity> conversationsInHistory = conversationsInHistoryJson
        .map((json) => ChatHistoryEntity.fromJson(jsonDecode(json)))
        .where((conversation) => conversation.title != null)
        .toList();
    if (currentSession == null) {
      currentSession = ChatHistoryEntity(timestamp: DateTime.now());
      await storage.setStringList(ShPrefKey.chatHistoryData, [
        jsonEncode(currentSession?.toJson()),
        ...conversationsInHistoryJson,
      ]);
      conversationsInHistory = [currentSession!, ...conversationsInHistory];
    }
    List<String> chatDataJson =
        storage.getStringList("${ShPrefKey.chatData}.${currentSession!.id}") ?? [];
    List<ChatMessageEntity> chatData = chatDataJson
        .map((chat) => ChatMessageEntity.fromJson(jsonDecode(chat)))
        .toList();
    state = state.copyWith(
      conversationsInHistory: conversationsInHistory,
      filteredConversations: conversationsInHistory,
      messages: chatData,
      currentSessionConversation: currentSession,
      selectedConversation: currentSession,
    );
    update();
    // cache the current server user session to memory
    final res = await service.initSession();
    if (res.response == ResponseEnum.success && res.data != null) {
      await storage.setInt(ShPrefKey.serverUserSession, res.data!);
    }
  }

  Future<void> sendMessage(String ques) async {
    final userMessage = ChatMessageEntity(
      text: ques,
      isUser: true,
      chatHistoryId: state.currentSessionConversation!.id!,
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      currentSessionConversation: state.currentSessionConversation!.copyWith(
        title: state.currentSessionConversation?.title ?? ques,
      ),
      conversationsInHistory: cacheChatHistory(
        state.conversationsInHistory
            .map(
              (conversation) => conversation.id == currentSession!.id && conversation.title == null
                  ? conversation.copyWith(title: ques)
                  : conversation,
            )
            .toList(),
      ),
    );
    update();

    // Add typing indicator
    final typingIndicator = ChatMessageEntity(
      text: '',
      isUser: false,
      isTyping: true,
      chatHistoryId: state.currentSessionConversation!.id!,
    );
    state = state.copyWith(messages: [...state.messages, typingIndicator]);
    update();
    final token = generateRandom16CharId();
    final response = await service.ask(ques, token);
    String? id = await service.getId(ques, response.text ?? '', response.source ?? 'rag');
    final botReply = ChatMessageEntity(
      id: id,
      text: response.text ?? '',
      isUser: false,
      chatHistoryId: state.currentSessionConversation!.id!,
    );
    final updatedMessages = state.messages.where((msg) => !msg.isTyping).toList()..add(botReply);
    state = state.copyWith(messages: updatedMessages);
    update();
    storage.setStringList(
      "${ShPrefKey.chatData}.${state.selectedConversation?.id}",
      state.messages.map((chat) => jsonEncode(chat.toJson())).toList(),
    );
  }

  void selectConversation(String conversationId) {
    final ChatHistoryEntity selectedCoversation = state.conversationsInHistory.firstWhere(
      (conversation) => conversation.id == conversationId,
    );
    List<String> chatDataJson =
        storage.getStringList("${ShPrefKey.chatData}.${selectedCoversation.id}") ?? [];
    List<ChatMessageEntity> chatData = chatDataJson
        .map((chat) => ChatMessageEntity.fromJson(jsonDecode(chat)))
        .toList();
    state = state.copyWith(messages: chatData, selectedConversation: selectedCoversation);
    update();
  }

  void deleteConversation(String conversationId) {
    if (state.conversationsInHistory.length <= 1) return;
    state.conversationsInHistory.removeWhere((conversation) => conversation.id == conversationId);
    cacheChatHistory(state.conversationsInHistory);
    state = state.copyWith();
    update();
  }

  List<ChatHistoryEntity> cacheChatHistory(List<ChatHistoryEntity> conversations) {
    storage.setStringList(
      ShPrefKey.chatHistoryData,
      conversations.map((conversation) => jsonEncode(conversation.toJson())).toList(),
    );
    return conversations;
  }

  void filterConversations(String query) {
    if (query.isEmpty) {
      state = state.copyWith(filteredConversations: state.conversationsInHistory);
      update();
    } else {
      final filtered = state.conversationsInHistory.where((conversation) {
        return conversation.title?.toLowerCase().contains(query.toLowerCase()) ?? false;
      }).toList();
      state = state.copyWith(filteredConversations: filtered);
      update();
    }
  }

  Future addRating(int rate, String comment, String id) async {
    await service.addRating(rate, comment, id);
  }
}
