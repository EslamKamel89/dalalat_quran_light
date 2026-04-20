class ThoughtfulModel {
  int? id;
  String? name;
  String? email;
  int? enabled;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;

  ThoughtfulModel({
    this.id,
    this.name,
    this.email,
    this.enabled,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'Thoughtful(id: $id, name: $name, email: $email, enabled: $enabled, description: $description, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  factory ThoughtfulModel.fromJson(Map<String, dynamic> json) =>
      ThoughtfulModel(
        id: json['id'] as int?,
        name: json['name'] as String?,
        email: json['email'] as String?,
        enabled: json['enabled'] as int?,
        description: json['description'] as String?,
        createdAt:
            json['created_at'] == null
                ? null
                : DateTime.parse(json['created_at'] as String),
        updatedAt:
            json['updated_at'] == null
                ? null
                : DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'enabled': enabled,
    'description': description,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  ThoughtfulModel copyWith({
    int? id,
    String? name,
    String? email,
    int? enabled,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ThoughtfulModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      enabled: enabled ?? this.enabled,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
