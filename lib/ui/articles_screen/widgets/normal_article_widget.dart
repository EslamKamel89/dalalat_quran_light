import 'package:dalalat_quran_light/controllers/articles_controller.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/text_styles.dart';
import 'package:dalalat_quran_light/widgets/articles_widgets.dart';
import 'package:dalalat_quran_light/widgets/articles_widgets_loading.dart';
import 'package:dalalat_quran_light/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NormalArticlesWidget extends StatefulWidget {
  const NormalArticlesWidget({super.key});

  @override
  State<NormalArticlesWidget> createState() => _NormalArticlesWidgetState();
}

class _NormalArticlesWidgetState extends State<NormalArticlesWidget> {
  final ArticlesController _articlesController = Get.find<ArticlesController>();
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  @override
  void initState() {
    ArticlesData.filteredList = ArticlesData.articlesList;
    _getArticles();
    super.initState();
  }

  Future<void> _getArticles() async {
    _fetchData();
    _searchController.addListener(() {
      _articlesController.search(_searchController.text.toString().toLowerCase());
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchData() async {
    await _articlesController.allArticles();
    if (!_isLoading) {
      _isLoading = true;
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ArticlesController>(
      builder: (context) {
        return ListView.builder(
          itemBuilder: (context, index) {
            if (index == 0) {
              return Column(
                children: [
                  SearchWidget(_searchController, null, () {
                    _articlesController.search(_searchController.text.toString().toLowerCase());
                  }),
                  ArticlesData.filteredList.isEmpty &&
                          _articlesController.responseState == ResponseEnum.success
                      ? Center(child: DefaultText("no_data".tr))
                      : const SizedBox(),
                ],
              );
            }
            index = index - 1;
            if (index < ArticlesData.filteredList.length) {
              return ArticleCardWidget(ArticlesData.filteredList[index]);
            }
            return _articlesController.responseState == ResponseEnum.loading
                ? const ArticlesWidgetLoadingColumn()
                : const SizedBox();
          },
          itemCount: ArticlesData.filteredList.length + 2,
        );
      },
    );
  }
}
