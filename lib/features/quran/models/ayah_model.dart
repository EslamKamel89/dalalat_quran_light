class AyahTagModel {
  final int id;
  final String name;

  AyahTagModel({required this.id, required this.name});

  factory AyahTagModel.fromJson(Map<String, dynamic> json) {
    return AyahTagModel(id: (json['id'] as num).toInt(), name: json['name']?.toString() ?? '');
  }

  @override
  String toString() => 'AyahTagModel(id: $id, name: $name)';
}

class AyahModel {
  final int id;
  final String ayahText;
  final String? simpleText;
  final List<AyahTagModel> tags;

  AyahModel({
    required this.id,
    required this.ayahText,
    required this.simpleText,
    required this.tags,
  });
  factory AyahModel.fromJson(Map<String, dynamic> json) {
    return AyahModel(
      id: (json['id'] as num).toInt(),
      ayahText: json['verse']?.toString() ?? '',
      simpleText: json['simple']?.toString(),
      tags: (json['tags'] as List<dynamic>? ?? []).map((e) => AyahTagModel.fromJson(e)).toList(),
    );
  }
  AyahModel copyWith({int? id, String? ayahText, String? simpleText, List<AyahTagModel>? tags}) {
    return AyahModel(
      id: id ?? this.id,
      ayahText: ayahText ?? this.ayahText,
      simpleText: simpleText ?? this.simpleText,
      tags: tags ?? this.tags,
    );
  }

  @override
  String toString() {
    return 'AyahModel(id: $id , ayahText: $ayahText, simpleText: $simpleText, tags: $tags)';
  }
}
