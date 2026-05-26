import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../services/holiday_service.dart';

class HolidayAnimatedTitle extends StatefulWidget {
  final double fontSize;

  const HolidayAnimatedTitle({super.key, required this.fontSize});

  @override
  State<HolidayAnimatedTitle> createState() => _HolidayAnimatedTitleState();
}

class _HolidayAnimatedTitleState extends State<HolidayAnimatedTitle> {
  bool showHolidayTitle = true;

  @override
  void initState() {
    super.initState();

    final holiday = HolidayService.currentHoliday();

    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) {
        setState(() {
          showHolidayTitle = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final holiday = HolidayService.currentHoliday();

    final holidayText = holiday?.greetingArabic ?? '';
    if (holiday == null) {
      return _NormalTitle(key: const ValueKey('normal_title'), fontSize: widget.fontSize);
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1200),

      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,

          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -0.15),
              end: Offset.zero,
            ).animate(animation),

            child: child,
          ),
        );
      },

      child:
          showHolidayTitle
              ? _HolidayText(
                key: const ValueKey('holiday_title'),
                text: holidayText,
                fontSize: widget.fontSize,
              )
              : _NormalTitle(key: const ValueKey('normal_title'), fontSize: widget.fontSize),
    );
  }
}

class _HolidayText extends StatelessWidget {
  final String text;
  final double fontSize;

  const _HolidayText({super.key, required this.text, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text(
          text,
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,

          style: TextStyle(
            color: const Color(0xFFFFE7B0),

            fontSize: fontSize,

            fontFamily: 'Almarai',

            fontWeight: FontWeight.w800,

            shadows: [Shadow(color: const Color(0xFFF5B45E).withOpacity(0.45), blurRadius: 18)],
          ),
        )
        .animate()
        .fadeIn(duration: 700.ms)
        .moveY(begin: -18, end: 0, duration: 1000.ms, curve: Curves.easeOutQuart)
        .shimmer(duration: 2200.ms, delay: 1200.ms);
  }
}

class _NormalTitle extends StatelessWidget {
  final double fontSize;

  const _NormalTitle({super.key, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text(
      'app_name'.tr,

      key: const ValueKey('normal_app_title'),

      textAlign: TextAlign.center,

      style: TextStyle(color: Colors.white, fontSize: fontSize, fontFamily: 'Almarai'),
    );
  }
}
