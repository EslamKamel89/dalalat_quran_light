import 'package:dalalat_quran_light/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TokenChipsRow extends StatelessWidget {
  final Map<String, List> groupedTokens;
  final String? selectedToken;
  final Function(String?) onTap;

  const TokenChipsRow({
    super.key,
    required this.groupedTokens,
    required this.selectedToken,
    required this.onTap,
  });

  Widget buildChip({
    required String label,
    required bool selected,
    required VoidCallback onPressed,
    int? count,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? primaryColor : lightGray,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Text(label, style: TextStyle(color: selected ? Colors.white : primaryColor)),
            if (count != null) ...[
              const SizedBox(width: 6),
              CircleAvatar(
                radius: 15,
                backgroundColor: Colors.white,
                child: Text("$count", style: const TextStyle(fontSize: 12)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[];

    chips.add(
      buildChip(label: "all".tr, selected: selectedToken == null, onPressed: () => onTap(null)),
    );

    for (var entry in groupedTokens.entries) {
      chips.add(
        buildChip(
          label: entry.key,
          count: entry.value.length,
          selected: entry.key == selectedToken,
          onPressed: () => onTap(entry.key),
        ),
      );
    }

    return SizedBox(
      height: 50,
      child: ListView(scrollDirection: Axis.horizontal, children: chips),
    );
  }
}
