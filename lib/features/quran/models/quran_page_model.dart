class QuranPageModel {
  final int pageNumber;
  final String pageUrl;

  QuranPageModel({required this.pageNumber, required this.pageUrl});
  factory QuranPageModel.fromJson(Map<String, dynamic> json) {
    return QuranPageModel(
      pageNumber: json['page_number'] as int,
      pageUrl: json['page_url'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {'page_number': pageNumber, 'page_url': pageUrl};
  }

  QuranPageModel copyWith({int? pageNumber, String? pageUrl}) {
    return QuranPageModel(
      pageNumber: pageNumber ?? this.pageNumber,
      pageUrl: pageUrl ?? this.pageUrl,
    );
  }

  @override
  String toString() => 'QuranPageModel(pageNumber: $pageNumber, pageUrl: $pageUrl)';
}
