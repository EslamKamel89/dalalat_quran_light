import 'package:dalalat_quran_light/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuranRootsSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;

  const QuranRootsSearchBar({super.key, required this.controller, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              filled: true,
              fillColor: lightGray,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              hintText: "enter_root".tr,
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
          onPressed: () {
            FocusScope.of(context).unfocus();
            onSearch();
          },
          icon: const Icon(Icons.search, color: Colors.white),
          label: Text("search".tr, style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
