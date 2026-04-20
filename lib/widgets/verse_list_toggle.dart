import 'package:dalalat_quran_light/models/verse_model.dart';
import 'package:dalalat_quran_light/utils/text_styles.dart';
import 'package:dalalat_quran_light/utils/unique_list_by_property.dart';
import 'package:flutter/material.dart';

class VerseListToggle extends StatefulWidget {
  final List<VerseModel?>? verses;

  const VerseListToggle({super.key, required this.verses});

  @override
  State<VerseListToggle> createState() => _VerseListToggleState();
}

class _VerseListToggleState extends State<VerseListToggle> {
  bool _isVisible = false;

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.verses == null || widget.verses?.isEmpty == true) return const SizedBox();
    List<VerseModel?> uniqueVerses = getUniqueListByProperty(
      widget.verses ?? [],
      (verse) => "${verse.suraId}-${verse.ayah}",
    );
    // List<VerseModel?> uniqueVerses = widget.verses ?? [];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     const Spacer(),
          //     PrimaryButton(
          //       onPressed: _toggleVisibility,

          //       borderRadius: 5,
          //       child: Text(
          //         _isVisible ? "إخفاء الآيات" : "إظهار الآيات",
          //         style: const TextStyle(
          //           fontWeight: FontWeight.bold,
          //           color: Colors.white,
          //           fontSize: 18,
          //           fontFamily: 'Almarai',
          //         ),
          //       ),
          //     ),
          //     const Spacer(),
          //   ],
          // ),

          // ElevatedButton.icon(
          //   onPressed: _toggleVisibility,
          //   icon: Icon(_isVisible ? Icons.visibility_off : Icons.visibility),
          //   label: Text(
          //     _isVisible ? "إخفاء الآيات" : "إظهار السور",
          //     style: const TextStyle(fontSize: 16),
          //   ),
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: Colors.blueAccent,
          //     foregroundColor: Colors.white,
          //   ),
          // ),
          // const SizedBox(height: 10),
          // if (!_isVisible) const SizedBox(height: 50),
          // if (_isVisible)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: uniqueVerses.length,
            itemBuilder: (context, index) {
              final verse = uniqueVerses[index];
              if (verse == null) {
                return SizedBox();
              }
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        " ${verse.suraAr ?? 'غير متوفر'}",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      ArabicText(
                        verse.ayahText ?? 'لا يوجد نص',
                        // style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.right,
                        height: 2.5,
                      ),
                      const Divider(height: 24),
                      Text("رقم الآية: ${verse.ayah ?? '-'}"),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
