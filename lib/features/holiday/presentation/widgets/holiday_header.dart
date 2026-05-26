import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HolidayHeader extends StatelessWidget {
  final String text;

  const HolidayHeader({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SafeArea(
        child: Align(
          alignment: const Alignment(0, -0.15),
          child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),

                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF3B1D5A).withOpacity(0.82),
                      const Color(0xFF25113A).withOpacity(0.82),
                    ],
                  ),

                  border: Border.all(color: const Color(0xFFF5B45E), width: 1.4),

                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFF5B45E).withOpacity(0.18),
                      blurRadius: 25,
                      spreadRadius: 1,
                    ),
                  ],
                ),

                child: Text(
                  text,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    color: Color(0xFFFFE7B0),
                    fontSize: 28,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w800,
                    height: 1.4,

                    shadows: [
                      Shadow(color: Color(0xAA000000), blurRadius: 10, offset: Offset(0, 2)),
                    ],
                  ),
                ),
              )
              .animate()
              // Appears slightly above
              .moveY(begin: -120, end: 0, duration: 1400.ms, curve: Curves.easeOutQuart)
              // Fade in
              .fadeIn(duration: 1000.ms)
              // Gentle floating motion
              .then()
              .shimmer(duration: 2500.ms, delay: 1200.ms)
              // Fade out later
              .then(delay: 4.seconds)
              .fadeOut(duration: 1200.ms),
        ),
      ),
    );
  }
}
