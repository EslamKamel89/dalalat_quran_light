import 'package:dalalat_quran_light/utils/print_helper.dart';

class NotificationModel {
  int? id;
  String? path;
  String? content;
  String? type;
  int? pathId;
  String? createdAt;
  int? surah;
  int? idAya;
  int? page;

  NotificationModel({
    this.id,
    this.path,
    this.content,
    this.type,
    this.pathId,
    this.createdAt,
    this.surah,
    this.idAya,
    this.page,
  });

  @override
  String toString() {
    return 'NotificationModel(id: $id, path: $path, content: $content, type: $type, pathId: $pathId, createdAt: $createdAt, surah: $surah , idAya: $idAya , page: $page)';
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    pr(json, 'NotificationModel.fromJson - raw json');
    int? toInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String && value.trim().isNotEmpty) {
        return int.tryParse(value.trim());
      }
      return null;
    }

    return pr(
      NotificationModel(
        id: toInt(json['id']),
        path: json['path'] as String?,
        content: json['content'] as String?,
        type: json['type'] as String?,
        pathId: toInt(json['path_id']),
        createdAt: json['created_at'] as String?,
        surah: toInt(json['surah']),
        idAya: toInt(json['id_aya']),
        page: toInt(json['page']),
      ),
      'NotificationModel.fromJson - parsed model',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'path': path,
    'type': type,
    'content': content,
    'path_id': pathId,
    'created_at': createdAt,
    'surah': surah,
    'id_aya': idAya,
    'page': page,
  };

  NotificationModel copyWith({
    int? id,
    String? path,
    String? content,
    int? pathId,
    String? createdAt,
    int? surah,
    String? type,
    int? idAya,
    int? page,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      path: path ?? this.path,
      content: content ?? this.content,
      type: type ?? this.type,
      pathId: pathId ?? this.pathId,
      createdAt: createdAt ?? this.createdAt,
      surah: surah ?? this.surah,
      idAya: idAya ?? this.idAya,
      page: page ?? this.page,
    );
  }
}
