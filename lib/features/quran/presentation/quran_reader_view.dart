import 'package:cached_network_image/cached_network_image.dart';
import 'package:dalalat_quran_light/features/quran/controllers/quran_reader_controller.dart';
import 'package:dalalat_quran_light/features/quran/entities/surah_entity.dart';
import 'package:dalalat_quran_light/features/quran/presentation/widgets/ayah_card.dart';
import 'package:dalalat_quran_light/ui/dialog_word_tag.dart';
import 'package:dalalat_quran_light/utils/colors.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/widgets/explain_dialog.dart';
import 'package:dalalat_quran_light/widgets/quran_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class QuranReaderView extends StatefulWidget {
  final SurahEntity surah;

  const QuranReaderView({super.key, required this.surah});

  @override
  State<QuranReaderView> createState() => _QuranReaderViewState();
}

class _QuranReaderViewState extends State<QuranReaderView> {
  final QuranReaderController _controller = Get.find<QuranReaderController>();

  @override
  void initState() {
    _controller.init(widget.surah);
    super.initState();
  }

  @override
  void dispose() {
    _controller.pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuranReaderController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: lightGray2,
          appBar: QuranBar('سورة ${controller.currentSurah.name}'),
          body: Builder(
            builder: (context) {
              switch (controller.pages.response) {
                case ResponseEnum.loading:
                  return const Center(child: CircularProgressIndicator());

                case ResponseEnum.failed:
                  return Center(child: Text(controller.pages.errorMessage ?? 'حدث خطأ'));

                case ResponseEnum.success:
                  final pages = controller.pages.data ?? [];

                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: PageView.builder(
                      controller: controller.pageController,
                      itemCount: pages.length,
                      onPageChanged: (index) {
                        controller.onPageChanged(index);
                      },
                      itemBuilder: (context, index) {
                        final page = pages[index];

                        return _QuranPageWidget(
                          key: ValueKey(page.pageUrl),
                          pageUrl: page.pageUrl,
                        ).animate().fadeIn(duration: 300.ms);
                      },
                    ),
                  );

                default:
                  return const SizedBox();
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: primaryColor.withOpacity(0.7),
            onPressed: () {
              controller.fetchAyatForCurrentPage();
              _showAyatBottomSheet(context, controller);
            },
            child: const Icon(Icons.menu_book, color: Colors.white),
          ).animate().scale(duration: 300.ms),
        );
      },
    );
  }

  void _showAyatBottomSheet(BuildContext context, QuranReaderController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return GetBuilder<QuranReaderController>(
          builder: (controller) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                color: lightGray,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: _buildAyatState(controller),
            ).animate().slideY(begin: 1, end: 0, duration: 400.ms);
          },
        );
      },
    );
  }

  Widget _buildAyatState(QuranReaderController controller) {
    switch (controller.ayat.response) {
      case ResponseEnum.loading:
        return const Center(child: CircularProgressIndicator());

      case ResponseEnum.failed:
        return Center(child: Text(controller.ayat.errorMessage ?? 'حدث خطأ'));

      case ResponseEnum.success:
        final ayat = controller.ayat.data ?? [];

        if (ayat.isEmpty) {
          return const Center(child: Text('لا توجد بيانات'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: ayat.length,
          itemBuilder: (context, index) {
            final ayah = ayat[index];

            return AyahCard(
              ayah: ayah,
              onTafsirTap: () {
                Get.dialog(
                  ExplainDialog(
                    ayaKey: ayah.id.toString(),
                    videoId: "-1",
                    suraName: null,
                    ayaNumber: null,
                  ),
                );
              },
              onTagTap: (tag) {
                Get.dialog(DialogWordTag(tagId: tag.id.toString(), wordId: "-1"));
              },
            );
          },
        );

      default:
        return const SizedBox();
    }
  }
}

class _QuranPageWidget extends StatelessWidget {
  final String pageUrl;

  const _QuranPageWidget({super.key, required this.pageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 2, right: 3, left: 3, bottom: 25),
      child: CachedNetworkImage(
        imageUrl: pageUrl,
        fit: BoxFit.fill,
        fadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,
        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) =>
            const Center(child: Icon(Icons.error, color: Colors.red)),
      ),
    );
  }
}
