// ignore_for_file: public_member_api_docs, sort_constructors_first
class ChatMessageEntity {
  String? id;
  final String chatHistoryId;
  final String text;
  final bool isUser;
  final bool isTyping;
  final String? comment;
  final int? rating;

  ChatMessageEntity({
    required this.chatHistoryId,
    required this.text,
    required this.isUser,
    this.isTyping = false,
    this.id,
    this.comment,
    this.rating,
  }) {
    id ??= createId();
  }

  ChatMessageEntity copyWith({
    String? id,
    String? chatHistoryId,
    String? text,
    bool? isUser,
    bool? isTyping,
    int? rating,
    String? comment,
  }) {
    return ChatMessageEntity(
      id: id ?? this.id,
      chatHistoryId: chatHistoryId ?? this.chatHistoryId,
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      isTyping: isTyping ?? this.isTyping,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'chatHistoryId': chatHistoryId,
      'text': text,
      'isUser': isUser,
      'isTyping': isTyping,
      'rating': rating,
      'comment': comment,
    };
  }

  factory ChatMessageEntity.fromJson(Map<String, dynamic> json) {
    return ChatMessageEntity(
      id: json['id'] as String,
      chatHistoryId: json['chatHistoryId'] as String,
      text: json['text'] as String,
      isUser: json['isUser'] as bool,
      isTyping: json['isTyping'] as bool,
      rating: json['rating'] as int?,
      comment: json['comment'] as String?,
    );
  }
  static String createId() {
    return "ChatMessageEntity.${DateTime.now().millisecondsSinceEpoch}";
  }
}
