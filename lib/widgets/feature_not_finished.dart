import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FeatureNotFinished extends StatelessWidget {
  const FeatureNotFinished({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 80,
              bottom: 24,
              left: 24,
              right: 24,
            ),
            margin: const EdgeInsets.only(top: 50),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "هذه الميزة قيد التطوير",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: Navigator.of(context).pop,
                  child: const Text("حسنًا"),
                ),
              ],
            ),
          ),
          // Positioned(
          //   top: 0,
          //   child: Icon(
          //     Icons.construction,
          //     size: 60,
          //     color: Theme.of(context).primaryColor,
          //   ).animate().scale(duration: 600.ms).fadeIn(duration: 400.ms),
          // ),
        ],
      ),
    ).animate().slideY(begin: -0.2, end: 0).fadeIn();
  }
}
