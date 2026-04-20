import 'package:dalalat_quran_light/features/words/entities/word_entity.dart';
import 'package:dalalat_quran_light/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomBadge extends StatefulWidget {
  const CustomBadge({super.key, required this.word, required this.selected});
  final WordEntity word;
  final bool selected;
  @override
  State<CustomBadge> createState() => _CustomBadgeState();
}

class _CustomBadgeState extends State<CustomBadge> {
  late final RootsIndexCubit;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.word.wordTashkeel != null && widget.word.wordTashkeel!.isNotEmpty
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: widget.selected ? primaryColor : primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: primaryColor),
            ),
            child: Text(
              widget.word.wordTashkeel ?? '',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: widget.selected ? Colors.white : primaryColor,
              ),
            ),
          )
        : SizedBox();
  }
}
