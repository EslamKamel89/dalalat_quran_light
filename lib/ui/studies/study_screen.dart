import 'package:dalalat_quran_light/controllers/get_study_controller.dart';
import 'package:dalalat_quran_light/models/study_model.dart';
import 'package:dalalat_quran_light/ui/chat/helpers/clean_reply.dart';
import 'package:dalalat_quran_light/utils/colors.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/share.dart';
import 'package:dalalat_quran_light/utils/text_styles.dart';
import 'package:dalalat_quran_light/widgets/quran_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

class StudyDetailsScreen extends StatefulWidget {
  static String id = '/StudyDetailsScreen';

  const StudyDetailsScreen({super.key});

  @override
  State<StudyDetailsScreen> createState() => _StudyDetailsScreenState();
}

class _StudyDetailsScreenState extends State<StudyDetailsScreen> {
  final GetStudyController _getStudyController = Get.find<GetStudyController>();
  StudyModel? studyModel;
  final ScrollController _scrollController = ScrollController();
  bool _isScrollable = false;
  bool _showFeedback = false;
  int? id;
  final t = 'StudyDetailsScreen';

  @override
  void initState() {
    id = Get.arguments;
    if (id == null) {
      return;
    }
    pr(id, '$t studyId');
    _getStudyController
        .getStudy(id: id!)
        .then((value) {
          studyModel = value;
          pr(studyModel, '$t - studyModel');
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
    return GetBuilder<GetStudyController>(
      builder: (_) {
        return Scaffold(
          appBar: QuranBar(studyModel?.name ?? ''),
          backgroundColor: lightGray2,
          body: studyModel != null
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
                                          studyModel?.name ?? '',
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
                                          ShareUtil.share(
                                            header: studyModel?.name ?? '',
                                            content: studyModel?.description ?? '',
                                            subject: studyModel?.name ?? '',
                                          );
                                        },
                                        icon: const Icon(Icons.share, color: primaryColor),
                                      ),
                                    ],
                                  ),

                                  Html(
                                    data: cleanHtml(studyModel?.description ?? ''),
                                    style: mainHtmlStyle(),
                                  ),

                                  // if (studyModel?.description != null &&
                                  //     _isScrollable &&
                                  //     _showFeedback)
                                  //   FeedbackTextWidget(
                                  //     horizontalPadding: 20,
                                  //     onTap: () {
                                  //       Get.toNamed(
                                  //         AddCommentView.id,
                                  //         arguments: {
                                  //           "id": studyModel?.id,
                                  //           'commentType': 'article',
                                  //         },
                                  //       );
                                  //     },
                                  //   ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // if (studyModel?.description != null && !_isScrollable && _showFeedback)
                      //   FeedbackTextWidget(
                      //     horizontalPadding: 20,
                      //     onTap: () {
                      //       Get.toNamed(
                      //         AddCommentView.id,
                      //         arguments: {"id": studyModel?.id, 'commentType': 'article'},
                      //       );
                      //     },
                      //   ),
                    ],
                  ),
                )
              : _getStudyController.responseState == ResponseEnum.loading
              ? const Center(child: CircularProgressIndicator())
              : const Center(child: DefaultText('نأسف لحدوث خطا, نرجو المحاولة في وقت لاحق ')),
        );
      },
    );
  }
}
