import 'package:flutter/material.dart';

class HighlightHelper {
  static List<TextSpan> buildHighlightedText(
    String fullText,
    String token,
    TextStyle normal,
    TextStyle highlight,
  ) {
    final parts = fullText.split(token);

    final spans = <TextSpan>[];

    for (int i = 0; i < parts.length; i++) {
      spans.add(TextSpan(text: parts[i], style: normal));

      if (i < parts.length - 1) {
        spans.add(TextSpan(text: token, style: highlight));
      }
    }

    return spans;
  }
}
