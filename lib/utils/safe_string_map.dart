Map<String, String> safeStringMap(Map<String, dynamic>? source) {
  if (source == null) {
    return {};
  }

  final result = <String, String>{};

  source.forEach((key, value) {
    if (value != null) {
      result[key] = value.toString();
    }
  });

  return result;
}
