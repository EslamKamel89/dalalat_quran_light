import 'package:dalalat_quran_light/features/discussions/models/discussion_model/discussion_model.dart';
import 'package:dalalat_quran_light/features/discussions/presentation/topic_details_screen.dart';
import 'package:dalalat_quran_light/utils/colors.dart';
import 'package:dalalat_quran_light/utils/text_styles.dart';
import 'package:flutter/material.dart';

class DiscussionCard extends StatelessWidget {
  final DiscussionModel discussion;

  const DiscussionCard({super.key, required this.discussion});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: ArabicText(discussion.title ?? '', fontWeight: FontWeight.bold, color: primaryColor),
        // subtitle: ArabicText(discussion.description ?? '', maxLines: 1),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => DiscussionDetailsScreen(discussion: discussion)),
          );
        },
      ),
    );
  }
}
