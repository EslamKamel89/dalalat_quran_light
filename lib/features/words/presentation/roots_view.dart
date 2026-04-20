import 'package:dalalat_quran_light/features/words/controllers/roots_controller.dart';
import 'package:dalalat_quran_light/features/words/presentation/widgets/all_roots_widget.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/widgets/quran_toolbar.dart';
import 'package:dalalat_quran_light/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:get/get.dart';

class RootsView extends StatefulWidget {
  const RootsView({super.key, this.addScaffold = true});
  final bool addScaffold;
  static const String id = '/RootsView';
  @override
  State<RootsView> createState() => _RootsViewState();
}

FocusNode rootsFocusNode = FocusNode();

class _RootsViewState extends State<RootsView> {
  late final RootsController rootsController;
  final scrollController = ScrollController();
  final Debouncer _debouncer = Debouncer();
  // final Throttler _throttler = Throttler();
  final Debouncer _scrollDebouncer = Debouncer();
  @override
  void initState() {
    rootsController = Get.find<RootsController>();
    // searchController.text = '';
    rootsController.search('');
    // wordsController.search('');

    rootsController.searchInput.addListener(() {
      // _debouncer.debounce(
      _debouncer.debounce(
        duration: Duration(milliseconds: 1000),
        onDebounce: () {
          rootsController.search(rootsController.searchInput.text);
          // wordsController.search(rootsController.searchInput.text);
        },
      );
    });
    scrollController.addListener(() {
      //    if (scrollController.position.activity?.isScrolling ?? false) {
      //   FocusScope.of(context).unfocus();
      // }
      _scrollDebouncer.debounce(
        duration: Duration(milliseconds: 500),
        onDebounce: () {
          rootsFocusNode.unfocus();
        },
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    // rootsController.searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = SingleChildScrollView(
      controller: scrollController,
      child: GetBuilder<RootsController>(
        builder: (_) {
          return Column(
            children: [
              SearchWidget(rootsController.searchInput, null, null),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Builder(
                  builder: (context) {
                    final roots = rootsController.rootsList;
                    if (roots.data?.isNotEmpty == true) {
                      return Column(
                        children: [
                          if (roots.response == ResponseEnum.loading)
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(bottom: 10),
                              child: CircularProgressIndicator(),
                            ),
                          AllRootsWidget(roots: roots.data ?? []),
                        ],
                      );
                    }
                    if (roots.response == ResponseEnum.loading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return Center(child: Column(children: [Text("لا توجد بيانات")]));
                    // return SizedBox();
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
    if (widget.addScaffold) {
      return Scaffold(appBar: QuranBar("المرجع"), body: content);
    } else {
      return content;
    }
  }
}
