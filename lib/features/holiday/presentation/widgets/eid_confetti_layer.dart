import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import 'crescent_particle.dart';
import 'islamic_star_particle.dart';

class EidConfettiLayer extends StatefulWidget {
  const EidConfettiLayer({super.key});

  @override
  State<EidConfettiLayer> createState() => _EidConfettiLayerState();
}

class _EidConfettiLayerState extends State<EidConfettiLayer> {
  late ConfettiController leftController;
  late ConfettiController rightController;

  @override
  void initState() {
    leftController = ConfettiController(duration: const Duration(seconds: 6));

    rightController = ConfettiController(duration: const Duration(seconds: 6));

    leftController.play();
    rightController.play();

    super.initState();
  }

  @override
  void dispose() {
    leftController.dispose();
    rightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          /// LEFT
          Align(
            alignment: Alignment.topLeft,
            child: ConfettiWidget(
              confettiController: leftController,
              blastDirection: pi / 4,
              emissionFrequency: 0.02,
              numberOfParticles: 2,
              gravity: 0.08,
              shouldLoop: false,
              colors: const [Color(0xFFF5B45E), Color(0xFFFFE7B0)],
              createParticlePath: drawCrescent,
            ),
          ),

          /// RIGHT
          Align(
            alignment: Alignment.topRight,
            child: ConfettiWidget(
              confettiController: rightController,
              blastDirection: pi - (pi / 4),
              emissionFrequency: 0.02,
              numberOfParticles: 2,
              gravity: 0.08,
              shouldLoop: false,
              colors: const [Color(0xFFF5B45E), Color(0xFFFFE7B0)],
              createParticlePath: drawIslamicStar,
            ),
          ),
        ],
      ),
    );
  }
}
