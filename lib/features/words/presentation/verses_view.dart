import 'package:dalalat_quran_light/features/words/controllers/roots_controller.dart';
import 'package:dalalat_quran_light/features/words/controllers/verses_controller.dart';
import 'package:dalalat_quran_light/features/words/entities/verse_entity.dart';
import 'package:dalalat_quran_light/features/words/entities/word_entity.dart';
import 'package:dalalat_quran_light/features/words/models/root_model/verse.dart';
import 'package:dalalat_quran_light/features/words/presentation/roots_view.dart';
import 'package:dalalat_quran_light/features/words/presentation/widgets/custom_action_button.dart';
import 'package:dalalat_quran_light/features/words/presentation/widgets/custom_badge.dart';
import 'package:dalalat_quran_light/features/words/presentation/widgets/verse_card.dart';
import 'package:dalalat_quran_light/utils/colors.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/unique_list_by_property.dart';
import 'package:dalalat_quran_light/widgets/quran_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class VersesView extends StatefulWidget {
  const VersesView({super.key, required this.rootId});
  final int rootId;
  @override
  State<VersesView> createState() => _VersesViewState();
}

class _VersesViewState extends State<VersesView> {
  late final VersesController versesController;
  late final RootsController rootsController;

  WordEntity? selectedWord;
  @override
  void initState() {
    versesController = Get.find<VersesController>();
    rootsController = Get.find<RootsController>();
    versesController.search(widget.rootId);
    super.initState();
  }

  List<WordEntity>? words;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (a, b) {
        rootsController.searchInput.text = '';
        // hideKeyboard();
        rootsFocusNode.unfocus();
      },
      child: Scaffold(
        appBar: QuranBar("نتائج البحث في الآيات"),
        backgroundColor: lightGray2,
        resizeToAvoidBottomInset: false,
        floatingActionButton: Builder(
          builder: (_) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selectedWord != null)
                  CustomActionButton(
                    onTap: () async {
                      setState(() {
                        selectedWord = null;
                      });
                      // hideKeyboard();
                    },
                    color: Colors.red,
                    icon: MdiIcons.close,
                  ),
                SizedBox(height: 10),
                CustomActionButton(
                  onTap: () async {
                    // FocusScope.of(context).unfocus();
                    await showModalBottomSheet(
                      context: context,
                      builder: (a) {
                        return Builder(
                          builder: (context) {
                            final roots = rootsController.rootsList.data ?? [];
                            if (roots.isNotEmpty == true) {
                              // words = getUniqueListByProperty(
                              //   words ?? WordEntity.transformRootsToWordsEntity(state.data ?? []),
                              //   (word) => word.wordTashkeel,
                              // );
                              words = words ?? WordEntity.transformRootsToWordsEntity(roots);
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                child: SingleChildScrollView(
                                  child: Wrap(
                                    children: List.generate(
                                      words!.length,
                                      (index) => InkWell(
                                        onTap: () {
                                          if (words![index].wordTashkeel == null) return;
                                          // wordsController.wordId = words![index].wordId!;
                                          // rootsController.searchInput.text =
                                          //     words![index].wordTashkeel!;
                                          setState(() {
                                            selectedWord = words![index];
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: CustomBadge(
                                          word: words![index],
                                          selected: words![index].wordId == selectedWord?.wordId,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                            // if (state.response == ResponseEnum.loading) {
                            //   return Center(child: CircularProgressIndicator());
                            // }
                            // return Center(child: Column(children: [Text("لا توجد بيانات")]));
                            return SizedBox();
                          },
                        );
                      },
                    );
                    // hideKeyboard();
                  },
                  color: primaryColor,
                  icon: MdiIcons.magnify,
                ),
              ],
            );
          },
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              GetBuilder<VersesController>(
                builder: (_) {
                  if (versesController.verses.response == ResponseEnum.loading) {
                    return Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(vertical: 100),
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (versesController.verses.data == null ||
                      versesController.verses.data?.isEmpty == true) {
                    return Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 50),
                      child: Text("لا توجد بيانات"),
                    );
                  }
                  List<VerseModel?> verses = getUniqueListByProperty(
                    versesController.verses.data ?? <VerseModel>[],
                    (verse) => verse.id,
                  );
                  verses = getUniqueListByProperty(
                    versesController.verses.data ?? <VerseModel>[],
                    (verse) => verse.text,
                  );
                  if (selectedWord != null) {
                    verses = verses
                        .where((v) => v!.wordTashkeel == selectedWord?.wordTashkeel)
                        .toList();
                  }
                  return Column(
                    children: List.generate(verses.length, (index) {
                      final verse = verses[index];
                      return VerseCard(
                        key: UniqueKey(),
                        verse: VerseEntity(
                          surahId: verse!.surahId,
                          surahName: verse.surah?.name,
                          verseNumber: verse.verseNumber,
                          verseText: verse.text,
                        ),
                      );
                    }),
                  );
                },
              ),

              // Divider(),
              // Sizer(),
            ],
          ),
        ),
      ),
    );
  }
}
