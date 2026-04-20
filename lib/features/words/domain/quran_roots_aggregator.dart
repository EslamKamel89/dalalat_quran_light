import 'package:dalalat_quran_light/features/words/models/quran_word/quran_word.dart';

class QuranRootsAggregator {
  final List<QuranWordModel> raw;

  QuranRootsAggregator(this.raw);

  Map<int, List<QuranWordModel>> groupByAyah() {
    final map = <int, List<QuranWordModel>>{};

    for (final item in raw) {
      final key = item.quranAyahId;
      if (key == null) continue;

      map.putIfAbsent(key, () => []);
      map[key]!.add(item);
    }

    return map;
  }

  Map<String, List<QuranWordModel>> groupByToken() {
    final map = <String, List<QuranWordModel>>{};

    for (final item in raw) {
      final token = item.tokenUthmani;
      if (token == null || token.isEmpty) continue;

      map.putIfAbsent(token, () => []);
      map[token]!.add(item);
    }

    return map;
  }

  int uniqueAyahCount() {
    return groupByAyah().length;
  }
}
