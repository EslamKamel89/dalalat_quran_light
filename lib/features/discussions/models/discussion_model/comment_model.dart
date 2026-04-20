import 'thoughtful_model.dart';

class CommentModel {
  int? id;
  int? discussionId;
  int? thoughtfulId;
  String? comment;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? reactsCount;
  ThoughtfulModel? thoughtful;
  List<dynamic>? reacts;

  CommentModel({
    this.id,
    this.discussionId,
    this.thoughtfulId,
    this.comment,
    this.createdAt,
    this.updatedAt,
    this.reactsCount,
    this.thoughtful,
    this.reacts,
  });

  @override
  String toString() {
    return 'Comment(id: $id, discussionId: $discussionId, thoughtfulId: $thoughtfulId, comment: $comment, createdAt: $createdAt, updatedAt: $updatedAt, reactsCount: $reactsCount, thoughtful: $thoughtful, reacts: $reacts)';
  }

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
    id: json['id'] as int?,
    discussionId: json['discussion_id'] as int?,
    thoughtfulId: json['thoughtful_id'] as int?,
    comment: json['comment'] as String?,
    // comment: randomText,
    createdAt:
        json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
    updatedAt:
        json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
    reactsCount: json['reacts_count'] as int?,
    thoughtful:
        json['thoughtful'] == null
            ? null
            : ThoughtfulModel.fromJson(
              json['thoughtful'] as Map<String, dynamic>,
            ),
    reacts: json['reacts'] as List<dynamic>?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'discussion_id': discussionId,
    'thoughtful_id': thoughtfulId,
    'comment': comment,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'reacts_count': reactsCount,
    'thoughtful': thoughtful?.toJson(),
    'reacts': reacts,
  };

  CommentModel copyWith({
    int? id,
    int? discussionId,
    int? thoughtfulId,
    String? comment,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? reactsCount,
    ThoughtfulModel? thoughtful,
    List<dynamic>? reacts,
  }) {
    return CommentModel(
      id: id ?? this.id,
      discussionId: discussionId ?? this.discussionId,
      thoughtfulId: thoughtfulId ?? this.thoughtfulId,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reactsCount: reactsCount ?? this.reactsCount,
      thoughtful: thoughtful ?? this.thoughtful,
      reacts: reacts ?? this.reacts,
    );
  }
}
