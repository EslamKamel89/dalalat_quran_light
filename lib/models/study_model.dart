class StudyModel {
  int? id;
  int? langId;
  String? name;
  String? description;
  int? seq;
  int? series;
  int? parent;
  dynamic createdBy;
  int? enabled;
  dynamic file;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  StudyModel({
    this.id,
    this.langId,
    this.name,
    this.description,
    this.seq,
    this.series,
    this.parent,
    this.createdBy,
    this.enabled,
    this.file,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  @override
  String toString() {
    return 'StudyModel(id: $id, langId: $langId, name: $name, description: $description, seq: $seq, series: $series, parent: $parent, createdBy: $createdBy, enabled: $enabled, file: $file, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  factory StudyModel.fromJson(Map<String, dynamic> json) => StudyModel(
    id: json['id'] as int?,
    langId: json['lang_id'] as int?,
    name: json['name'] as String?,
    description: json['description'] as String?,
    seq: json['seq'] as int?,
    series: json['series'] as int?,
    parent: json['parent'] as int?,
    createdBy: json['created_by'] as dynamic,
    enabled: json['enabled'] as int?,
    file: json['file'] as dynamic,
    createdAt:
        json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
    updatedAt:
        json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
    deletedAt: json['deleted_at'] as dynamic,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'lang_id': langId,
    'name': name,
    'description': description,
    'seq': seq,
    'series': series,
    'parent': parent,
    'created_by': createdBy,
    'enabled': enabled,
    'file': file,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'deleted_at': deletedAt,
  };
}
