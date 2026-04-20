import 'package:dalalat_quran_light/features/discussions/controllers/discussion_controller.dart';
import 'package:dalalat_quran_light/features/discussions/models/discussion_model/comment_model.dart';
import 'package:dalalat_quran_light/features/discussions/models/discussion_model/thoughtful_model.dart';
import 'package:dalalat_quran_light/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeaveCommentWidget extends StatefulWidget {
  LeaveCommentWidget({super.key, required this.comments, required this.discussionId});
  List<CommentModel> comments;
  final int? discussionId;
  @override
  State<LeaveCommentWidget> createState() => _LeaveCommentWidgetState();
}

class _LeaveCommentWidgetState extends State<LeaveCommentWidget> {
  final TextEditingController _textController = TextEditingController();
  final DiscussionController _controller = Get.find<DiscussionController>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(color: lightGray, borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              maxLines: null,
              textDirection: TextDirection.rtl,
              minLines: 5,
              decoration: InputDecoration(
                hintText: 'اكتب تعليقك هنا...',
                hintTextDirection: TextDirection.rtl,
                filled: true,
                fillColor: lightGray2,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: mediumGray),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: mediumGray),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: primaryColor),
                ),
              ),
            ),
            const SizedBox(width: 10),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () async {
                final commentText = _textController.text;
                if (commentText.isEmpty) return;
                widget.comments.add(
                  CommentModel(
                    comment: _textController.text,
                    thoughtful: ThoughtfulModel(name: 'أنت'),
                  ),
                );
                _controller.discussionsRes.value = _controller.discussionsRes.value.copyWith();
                _textController.clear();
                FocusScope.of(context).unfocus();
                await _controller.addComment(widget.discussionId, commentText);
                await _controller.discussions();
              },
              child: const Text(
                'إضافة تعليق',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
