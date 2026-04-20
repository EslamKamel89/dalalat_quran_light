// ignore_for_file: public_member_api_docs, sort_constructors_first
class SurahEntity {
  final int id;
  final String name;
  final int startPage;

  const SurahEntity({required this.id, required this.name, required this.startPage});

  SurahEntity copyWith({int? id, String? name, int? startPage}) {
    return SurahEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      startPage: startPage ?? this.startPage,
    );
  }
}
