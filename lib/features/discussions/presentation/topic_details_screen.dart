import 'package:dalalat_quran_light/features/discussions/controllers/discussion_controller.dart';
import 'package:dalalat_quran_light/features/discussions/models/discussion_model/discussion_model.dart';
import 'package:dalalat_quran_light/features/discussions/presentation/widgets/comment_card.dart';
import 'package:dalalat_quran_light/features/discussions/presentation/widgets/leave_comment_widget.dart';
import 'package:dalalat_quran_light/ui/chat/helpers/clean_reply.dart';
import 'package:dalalat_quran_light/ui/home_sura_screen.dart';
import 'package:dalalat_quran_light/utils/colors.dart';
import 'package:dalalat_quran_light/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

class DiscussionDetailsScreen extends StatefulWidget {
  final DiscussionModel discussion;

  const DiscussionDetailsScreen({super.key, required this.discussion});

  @override
  State<DiscussionDetailsScreen> createState() => _DiscussionDetailsScreenState();
}

class _DiscussionDetailsScreenState extends State<DiscussionDetailsScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(backgroundColor: primaryColor, title: Text(widget.discussion.title ?? '')),
        body: DefaultTabController(
          length: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TabBar(
                  indicatorColor: Colors.transparent,
                  tabs: [
                    TabButton(title: "الموضوع", selected: currentIndex == 0),
                    TabButton(title: "التعليقات", selected: currentIndex == 1),
                  ],
                  onTap: (value) {
                    setState(() {
                      currentIndex = value;
                    });
                  },
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: currentIndex == 0
                      ? ListView(
                          children: [
                            ArabicText(
                              widget.discussion.title ?? '',
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                            Html(
                              // data: _detailsController.selectedTagModel.value.description(),
                              data: cleanHtml(widget.discussion.description ?? ''),
                              style: mainHtmlStyle(),
                            ),
                            // ArabicText(widget.discussion.description ?? '', maxLines: 1),
                          ],
                        )
                      : Obx(() {
                          final DiscussionController controller = Get.find<DiscussionController>();
                          controller.discussionsRes.value;
                          final discussion = controller.discussionsRes.value.data?.firstWhereOrNull(
                            (d) => d.id == widget.discussion.id,
                          );

                          final comments = discussion!.comments ?? [];
                          if (comments.isEmpty) {
                            return ListView(
                              children: [
                                const SizedBox(height: 32),
                                Center(
                                  child: ArabicText(
                                    'لا توجد تعليقات بعد',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                LeaveCommentWidget(
                                  comments: comments,
                                  discussionId: widget.discussion.id,
                                ),
                              ],
                            );
                          }
                          return ListView.builder(
                            itemCount: comments.length + 1,
                            itemBuilder: (context, index) {
                              if (index < comments.length) {
                                final comment = comments[index];
                                return CommentCard(
                                  key: Key("${comment.id}-${comment.comment}"),
                                  discussion: discussion,
                                  comment: comments[index],
                                );
                              }

                              return LeaveCommentWidget(
                                comments: comments,
                                discussionId: widget.discussion.id,
                              );
                            },
                          );
                        }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
