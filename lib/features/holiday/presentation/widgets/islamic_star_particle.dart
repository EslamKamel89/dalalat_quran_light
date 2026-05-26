import 'dart:math';

import 'package:flutter/material.dart';

Path drawIslamicStar(Size size) {
  final path = Path();

  final center = Offset(size.width / 2, size.height / 2);

  final outerRadius = size.width / 2;
  final innerRadius = outerRadius / 2;

  for (int i = 0; i < 8; i++) {
    final angle = (pi / 4) * i;

    final radius = i.isEven ? outerRadius : innerRadius;

    final x = center.dx + radius * cos(angle);
    final y = center.dy + radius * sin(angle);

    if (i == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
  }

  path.close();

  return path;
}
