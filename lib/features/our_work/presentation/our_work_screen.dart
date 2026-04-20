import 'package:dalalat_quran_light/features/our_work/data/apps.dart';
import 'package:dalalat_quran_light/features/our_work/presentation/widgets/app_card.dart';
import 'package:dalalat_quran_light/utils/colors.dart';
import 'package:dalalat_quran_light/widgets/quran_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OurWorkScreen extends StatelessWidget {
  const OurWorkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGray,
      appBar: QuranBar('من أعمالنا'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 20),
            _buildHeader(),
            const SizedBox(height: 30),
            ...apps.map((app) => AppCard(app: app)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
          "من أعمالنا",
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryColor),
        )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: -0.3, end: 0, curve: Curves.easeOut)
        .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack);
  }
}
