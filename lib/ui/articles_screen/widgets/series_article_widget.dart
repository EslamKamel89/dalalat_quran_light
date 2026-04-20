import 'package:dalalat_quran_light/controllers/article_series_controller.dart';
import 'package:dalalat_quran_light/ui/articles_screen/widgets/series_article_card_widget.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/text_styles.dart';
import 'package:dalalat_quran_light/widgets/articles_widgets_loading.dart';
import 'package:dalalat_quran_light/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class SeriesArticlesWidget extends StatefulWidget {
  const SeriesArticlesWidget({super.key});

  @override
  State<SeriesArticlesWidget> createState() => SeriesArticlesWidgetState();
}

class SeriesArticlesWidgetState extends State<SeriesArticlesWidget> {
  final ArticlesSeriesController _articlesController = Get.find<ArticlesSeriesController>();
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    _searchController.addListener(() {
      _articlesController.search(_searchController.text.toLowerCase());
    });
    _articlesController.getArticleSeries();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _searchController.addListener(() {
    //   _articlesController.search(_searchController.text.toString().toLowerCase());
    // });
    return GetBuilder<ArticlesSeriesController>(
      builder: (context) {
        return ArticlesSeriesData.filteredList.isEmpty &&
                _articlesController.responseState == ResponseEnum.loading
            ? const ArticlesWidgetLoadingColumn()
            : ListView.builder(
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Column(
                      children: [
                        SearchWidget(_searchController, null, () {
                          _articlesController.search(
                            _searchController.text.toString().toLowerCase(),
                          );
                        }),
                        ArticlesSeriesData.filteredList.isEmpty
                            ? Center(child: DefaultText("no_data".tr))
                            : const SizedBox(),
                      ],
                    );
                  }
                  index = index - 1;
                  if (index < ArticlesSeriesData.filteredList.length) {
                    return SeriesArticleCardWidget(
                      ArticlesSeriesData.filteredList[index],
                    ).animate().scale(delay: (index * 50).ms);
                  }
                  return _articlesController.responseState == ResponseEnum.loading
                      ? const ArticlesWidgetLoadingColumn()
                      : const SizedBox();
                },
                itemCount: ArticlesSeriesData.filteredList.length + 2,
              );
      },
    );
  }
}
