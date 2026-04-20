import 'package:dalalat_quran_light/features/discussions/controllers/discussion_controller.dart';
import 'package:dalalat_quran_light/features/discussions/models/discussion_model/comment_model.dart';
import 'package:dalalat_quran_light/features/discussions/models/discussion_model/discussion_model.dart';
import 'package:dalalat_quran_light/features/discussions/presentation/widgets/confirm_delete.dart';
import 'package:dalalat_quran_light/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentCard extends StatefulWidget {
  final CommentModel comment;
  final DiscussionModel discussion;
  const CommentCard({super.key, required this.discussion, required this.comment});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  final DiscussionController _controller = Get.find<DiscussionController>();
  bool _expanded = false;
  bool _isOverflowing = false;
  bool _isEditMode = false;
  String _originalComment = '';
  bool _like = false;
  @override
  void initState() {
    _originalComment = widget.comment.comment ?? '';
    _like = _isLiked();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.comment.comment ?? '';
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.comment.thoughtful?.name ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor2),
              ),
              const SizedBox(height: 6),
              if (!_isEditMode) ...[
                LayoutBuilder(
                  builder: (context, constraints) {
                    final span = TextSpan(
                      text: text,
                      style: const TextStyle(
                        fontSize: 17,
                        fontFamily: "Amiri",
                        color: Colors.black,
                      ),
                    );

                    final tp = TextPainter(
                      text: span,
                      maxLines: 3,
                      textDirection: TextDirection.rtl,
                    )..layout(maxWidth: constraints.maxWidth);

                    _isOverflowing = tp.didExceedMaxLines;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          text,
                          maxLines: _expanded ? null : 3,
                          overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 17,
                            fontFamily: "Amiri",
                            color: Colors.black,
                          ),
                        ),
                        if (_isOverflowing)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _expanded = !_expanded;
                              });
                            },
                            child: Text(
                              _expanded ? 'عرض أقل' : 'عرض المزيد',
                              style: const TextStyle(color: primaryColor),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 12),
              ],
              if (_isEditMode && _isOwner()) ...[_buildTextField(), const SizedBox(height: 12)],
              Row(
                children: [
                  if (_isOwner()) ...[
                    _ActionIcon(
                      icon: _isEditMode ? Icons.close : Icons.edit,
                      color: primaryColor,
                      onTap: _toggleUpdate,
                    ),
                    const SizedBox(width: 12),
                  ],
                  if (_isOwner() && _isEditMode) ...[
                    _ActionIcon(icon: Icons.save, color: primaryColor, onTap: _update),
                    const SizedBox(width: 12),
                  ],
                  _ActionIcon(
                    icon: _like ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                    onTap: _toggleLike,
                    count: widget.comment.reactsCount,
                  ),
                  const SizedBox(width: 12),
                  if (_isOwner()) ...[
                    _ActionIcon(icon: Icons.delete, color: Colors.red, onTap: _delete),
                    const SizedBox(width: 12),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleUpdate() {
    if (_isEditMode) {
      widget.comment.comment = _originalComment;
    }
    _isEditMode = !_isEditMode;
    setState(() {});
  }

  Future _toggleLike() async {
    _like = !_like;
    setState(() {});
    if (_isLiked()) {
      await _controller.removeLike(widget.comment.id);
    } else {
      await _controller.addLike(widget.comment.id);
    }
    await _controller.discussions();
    _like = _isLiked();
  }

  Future _update() async {
    _originalComment = widget.comment.comment ?? '';
    setState(() {
      _isEditMode = !_isEditMode;
    });
    FocusScope.of(context).unfocus();
    await _controller.updateComment(
      widget.discussion.id,
      widget.comment.id,
      widget.comment.comment,
    );
    await _controller.discussions();
  }

  Future _delete() async {
    widget.discussion.comments?.remove(widget.comment);
    final confirm = await showDeleteCommentDialog();
    if (!confirm) return;
    await _controller.deleteComment(widget.comment.id);
    await _controller.discussions();
  }

  bool _isOwner() {
    return getCurrentUser()?.id == widget.comment.thoughtful?.id;
  }

  bool _isLiked() {
    final discussions = _controller.discussionsRes.value.data;
    CommentModel? comment;
    for (var i = 0; i < discussions!.length; i++) {
      final d = discussions[i];
      for (var j = 0; j < (d.comments?.length ?? 0); j++) {
        final c = d.comments![j];
        if (c.id == widget.comment.id) {
          comment = c;
        }
      }
    }
    return comment?.reacts?.isNotEmpty == true;
  }

  Widget _buildTextField() {
    return TextFormField(
      initialValue: widget.comment.comment,
      onChanged: (v) => widget.comment.comment = v,
      keyboardType: TextInputType.multiline,
      minLines: 3,
      maxLines: null,
      textDirection: TextDirection.rtl,
      style: const TextStyle(fontFamily: "Amiri", fontSize: 17, color: Colors.black, height: 1.6),
      decoration: InputDecoration(
        hintText: 'عدّل التعليق...',
        hintStyle: TextStyle(fontFamily: "Amiri", fontSize: 16, color: Colors.grey.shade500),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final int? count;
  const _ActionIcon({required this.icon, required this.color, required this.onTap, this.count});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            if (count != null && count != 0) ...[Text(count.toString()), SizedBox(width: 5)],
            Icon(icon, size: 18, color: color),
          ],
        ),
      ),
    );
  }
}
