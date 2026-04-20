import 'package:dalalat_quran_light/features/chat/models/chat_message_entity.dart';
import 'package:dalalat_quran_light/features/chat/presentation/widgets/rating_comment_widget.dart';
import 'package:dalalat_quran_light/ui/chat/helpers/clean_reply.dart';
import 'package:dalalat_quran_light/ui/intro_screen.dart';
import 'package:dalalat_quran_light/utils/assets.dart';
import 'package:dalalat_quran_light/utils/colors.dart';
import 'package:dalalat_quran_light/utils/share.dart';
import 'package:dalalat_quran_light/widgets/styled_html_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ChatBubble extends StatefulWidget {
  final ChatMessageEntity message;
  final bool animate;
  const ChatBubble({super.key, required this.message, required this.animate});

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    final isUser = widget.message.isUser;
    final avatar = isUser
        ? CircleAvatar(child: Icon(Icons.person, color: Colors.white, size: 16))
        : CircleAvatar(
            backgroundColor: primaryColor.withOpacity(0.05),
            child: Image.asset(AssetsData.logoSmall, height: 30),
          );

    return Padding(
      padding: EdgeInsets.only(
        top: 6,
        bottom: widget.message.isTyping ? 40.vh : 6,
        left: 12,
        right: 12,
      ),
      child: Row(
        mainAxisAlignment: !isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isUser) avatar,
          Flexible(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 8, right: 8, bottom: !isUser ? 30 : 20),
                  // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isUser
                        ? Color(0xff8B5FBF).withOpacity(0.6)
                        : Colors.grey[300]!.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: widget.message.isTyping
                      ? Lottie.asset(AssetsData.loading, height: 100, width: double.infinity)
                      : InkWell(
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(
                                text: ShareUtil.buildShareContent(
                                  header: "الأجابة",
                                  content: cleanReply(
                                    widget.message.text,
                                    removeHtml: true,
                                    showComment: false,
                                  ),
                                ),
                              ),
                            );
                          },

                          child: Builder(
                            builder: (context) {
                              return StreamingHtmlView(
                                rawResponseHtml: widget.message.text,
                                // addStyling: true,
                                animate: widget.animate,
                                accentColor: primaryColor,
                              );
                            },
                          ),
                        ),
                ),
                if (!isUser)
                  Positioned(
                    bottom: 0,
                    left: !isUser ? -10 : null,
                    right: isUser ? -10 : null,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      decoration: BoxDecoration(
                        color: primaryColor2.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          RatingCommentWidget(
                            id: widget.message.id ?? '',
                            initialComment: widget.message.comment ?? '',
                            initialRating: widget.message.rating ?? 0,
                          ),
                          SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              ShareUtil.share(
                                header: "الأجابة",
                                content: cleanReply(
                                  widget.message.text,
                                  removeHtml: true,
                                  showComment: false,
                                ),
                                subject: "الأجابة",
                              );
                              // SharePlus.instance.share(
                              //   ShareParams(
                              //     text: cleanReply(
                              //       widget.message.text,
                              //       removeHtml: true,
                              //       showComment: false,
                              //     ),
                              //   ),
                              // );
                            },
                            child: Icon(MdiIcons.share, size: 25, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // if (!isUser) avatar,
        ],
      ),
    );
  }
}
