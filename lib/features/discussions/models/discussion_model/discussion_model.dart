import 'package:dalalat_quran_light/features/discussions/models/discussion_model/comment_model.dart';

class DiscussionModel {
  int? id;
  String? title;
  String? description;
  String? langSymbol;
  String? createdAt;
  List<CommentModel>? comments;
  int? totalComments;

  DiscussionModel({
    this.id,
    this.title,
    this.description,
    this.langSymbol,
    this.createdAt,
    this.comments,
    this.totalComments,
  });

  @override
  String toString() {
    return 'DiscussionModel(id: $id, title: $title, description: $description, langSymbol: $langSymbol, createdAt: $createdAt, comments: $comments, totalComments: $totalComments)';
  }

  factory DiscussionModel.fromJson(Map<String, dynamic> json) {
    return DiscussionModel(
      id: json['id'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      langSymbol: json['lang_symbol'] as String?,
      createdAt: json['created_at'] as String?,
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalComments: json['total_comments'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'lang_symbol': langSymbol,
    'created_at': createdAt,
    'comments': comments?.map((e) => e.toJson()).toList(),
    'total_comments': totalComments,
  };

  DiscussionModel copyWith({
    int? id,
    String? title,
    String? description,
    String? langSymbol,
    String? createdAt,
    List<CommentModel>? comments,
    int? totalComments,
  }) {
    return DiscussionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      langSymbol: langSymbol ?? this.langSymbol,
      createdAt: createdAt ?? this.createdAt,
      comments: comments ?? this.comments,
      totalComments: totalComments ?? this.totalComments,
    );
  }
}
