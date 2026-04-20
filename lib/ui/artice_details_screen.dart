import 'package:dalalat_quran_light/controllers/article_details_controller.dart';
import 'package:dalalat_quran_light/controllers/download_link_controller.dart';
import 'package:dalalat_quran_light/controllers/get_article_controller.dart';
import 'package:dalalat_quran_light/controllers/settings_controller.dart';
import 'package:dalalat_quran_light/models/article_model.dart';
import 'package:dalalat_quran_light/ui/add_comment.dart';
import 'package:dalalat_quran_light/ui/chat/helpers/clean_reply.dart';
import 'package:dalalat_quran_light/ui/settings_screen/setting_screen.dart';
import 'package:dalalat_quran_light/utils/colors.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/share.dart';
import 'package:dalalat_quran_light/utils/text_styles.dart';
import 'package:dalalat_quran_light/widgets/feedback_text_widget.dart';
import 'package:dalalat_quran_light/widgets/quran_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleDetailsScreen extends StatefulWidget {
  static String id = '/ArticleDetailsScreen';

  const ArticleDetailsScreen({super.key});

  @override
  State<ArticleDetailsScreen> createState() => _ArticleDetailsScreenState();
}

class _ArticleDetailsScreenState extends State<ArticleDetailsScreen> {
  final ArticlesDetailsController _detailsController = Get.put(ArticlesDetailsController());
  final GetDownloadLinkController _downloadLinkController = Get.find<GetDownloadLinkController>();
  final GetArticleController _getArticleController = Get.find<GetArticleController>();
  ArticleModel? articleModel;
  final ScrollController _scrollController = ScrollController();
  bool _isScrollable = false;
  bool _showFeedback = false;
  int? id;
  final t = 'ArticleDetailsScreen';
  String? downloadLink;

  @override
  void initState() {
    id = Get.arguments;
    if (id == null) {
      return;
    }
    pr(id, '$t articleId');
    _getArticleController
        .getArticle(id: id!)
        .then((value) {
          articleModel = value;
          pr(articleModel, '$t - articleModel');
          _downloadLinkController
              .getDownloadlink(
                downloadLinkType: DownloadLinkType.article,
                id: articleModel?.id.toString() ?? '',
              )
              .then((value) {
                pr(value, '$t - downloadLink');
                return downloadLink = value;
              });
        })
        .then((_) {
          _detailsController.articleId = (articleModel?.id)!;
          _detailsController.getRelatedArticles();
        })
        .then((_) {
          Future.delayed(Duration(seconds: 1), () {
            setState(() {
              _showFeedback = true;
            });
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _updateScrollableFlag();
          });
        });
    _scrollController.addListener(_updateScrollableFlag);
    super.initState();
  }

  @override
  void dispose() {
    ArticleDetailsData.relatedArticles = [];
    _scrollController.removeListener(_updateScrollableFlag);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateScrollableFlag() {
    if (!_scrollController.hasClients) return;

    final bool nowScrollable = _scrollController.position.maxScrollExtent > 0;

    if (nowScrollable != _isScrollable) {
      setState(() {
        _isScrollable = nowScrollable;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GetArticleController>(
      builder: (_) {
        return Scaffold(
          appBar: QuranBar(articleModel?.name ?? ''),
          backgroundColor: lightGray2,
          body: articleModel != null
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    border: Border.all(color: lightGray2, width: 1),
                  ),
                  margin: const EdgeInsets.only(top: 20, bottom: 20, right: 10, left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(15)),
                            border: Border.all(color: lightGray2, width: 1),
                          ),
                          margin: const EdgeInsets.only(top: 20, bottom: 20, right: 10, left: 10),
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(8),
                            controller: _scrollController,
                            child: Container(
                              margin: const EdgeInsetsDirectional.only(start: 20, end: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          articleModel?.name ?? '',
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor,
                                            fontSize: 18,
                                            fontFamily: 'Almarai',
                                          ),
                                        ),
                                      ),
                                      // Spacer(),
                                      IconButton(
                                        onPressed: () {
                                          // String shareContent =
                                          //     ' ${articleModel?.name ?? ''}';
                                          // shareContent =
                                          //     '$shareContent\n-------------------------';
                                          // shareContent =
                                          // '$shareContent\n${articleModel?.descriptionWithNoTags() ?? ''}';
                                          // Share.share(
                                          //   shareContent,
                                          //   subject:
                                          //       ' ${articleModel?.name ?? ''}',
                                          // );
                                          ShareUtil.share(
                                            header: articleModel?.name ?? '',
                                            content: articleModel?.description ?? '',
                                            subject: articleModel?.name ?? '',
                                          );
                                        },
                                        icon: const Icon(Icons.share, color: primaryColor),
                                      ),
                                    ],
                                  ),

                                  Html(
                                    data: cleanHtml(articleModel?.description ?? ''),
                                    style: mainHtmlStyle(),
                                  ),
                                  GetBuilder<GetDownloadLinkController>(
                                    builder: (_) {
                                      if (downloadLink != null) {
                                        return TextButton(
                                          onPressed: () {
                                            launchUrl(Uri.parse(downloadLink!));
                                          },
                                          child: Text(
                                            'أقرا المزيد',
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                              fontSize:
                                                  Get.find<SettingsController>().fontTypeEnum ==
                                                      FontType.normal
                                                  ? 14
                                                  : 18,
                                              fontFamily: 'Almarai',
                                            ),
                                          ),
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    },
                                  ),

                                  if (articleModel?.description != null &&
                                      _isScrollable &&
                                      _showFeedback)
                                    FeedbackTextWidget(
                                      horizontalPadding: 20,
                                      onTap: () {
                                        Get.toNamed(
                                          AddCommentView.id,
                                          arguments: {
                                            "id": articleModel?.id,
                                            'commentType': 'article',
                                          },
                                        );
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (articleModel?.description != null && !_isScrollable && _showFeedback)
                        FeedbackTextWidget(
                          horizontalPadding: 20,
                          onTap: () {
                            Get.toNamed(
                              AddCommentView.id,
                              arguments: {"id": articleModel?.id, 'commentType': 'article'},
                            );
                          },
                        ),
                      GetBuilder<ArticlesDetailsController>(
                        builder: (_) {
                          return Visibility(
                            visible: ArticleDetailsData.relatedArticles.isNotEmpty,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'read_also'.tr,
                                    style: const TextStyle(
                                      color: primaryColor,
                                      fontFamily: "Almarai",
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.only(left: 3, right: 3),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: ArticleDetailsData.relatedArticles.length,
                                    itemBuilder: (context, index) {
                                      return ElevatedButton(
                                        onPressed: () {
                                          Get.to(
                                            const ArticleDetailsScreen(),
                                            transition: Transition.fade,
                                            arguments: ArticleDetailsData.relatedArticles[index].id,
                                            preventDuplicates: false,
                                          );
                                        },

                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.blueGrey,
                                          backgroundColor: Colors.white,
                                          padding: EdgeInsets.zero,
                                          elevation: 2,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 15,
                                          ),
                                          child: Text(
                                            ArticleDetailsData.relatedArticles[index].name,
                                            style: const TextStyle(fontFamily: 'Almarai'),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              : _getArticleController.responseState == ResponseEnum.loading
              ? const Center(child: CircularProgressIndicator())
              : const Center(child: DefaultText('نأسف لحدوث خطا, نرجو المحاولة في وقت لاحق ')),
        );
      },
    );
  }

  String parseHtmlString(String htmlString) {
    return htmlString;
    final document = parse(htmlString);
    final String parsedString = parse(document.body!.text).documentElement!.text;
    return parsedString;
  }
}
