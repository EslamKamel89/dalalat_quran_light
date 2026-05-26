import 'package:flutter/material.dart';

Path drawCrescent(Size size) {
  final path = Path();

  path.addOval(
    Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2),
  );

  path.addOval(
    Rect.fromCircle(center: Offset(size.width / 1.6, size.height / 2), radius: size.width / 2),
  );

  return path;
}
