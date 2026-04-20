import 'package:dalalat_quran_light/controllers/tags_screen_controller.dart';
import 'package:dalalat_quran_light/ui/tag_details_screen.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/text_styles.dart';
import 'package:dalalat_quran_light/widgets/search_widget.dart';
import 'package:dalalat_quran_light/widgets/tag_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class DifferenceTagsWidget extends StatefulWidget {
  const DifferenceTagsWidget({super.key});

  @override
  State<DifferenceTagsWidget> createState() => DifferenceTagsWidgetState();
}

class DifferenceTagsWidgetState extends State<DifferenceTagsWidget> {
  final TagsScreenController _tagsController = Get.find<TagsScreenController>();

  late TextEditingController _textEditingController;
  @override
  void initState() {
    // TagsScreenData.filteredList = [];
    // TagsScreenData.tagsList = [];
    if (TagsScreenData.tagsDifferenceList.isEmpty) {
      _tagsController.getTags(tagType: TagType.difference);
    }
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _textEditingController.addListener(() {
      _tagsController.search(
        key: _textEditingController.text.toString().toLowerCase(),
        tagType: TagType.difference,
      );
    });
    return GetBuilder<TagsScreenController>(
      builder: (context) {
        return _tagsController.responseState == ResponseEnum.loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Column(
                      children: [
                        SearchWidget(_textEditingController, null, () {
                          _tagsController.search(
                            key: _textEditingController.text.toString().toLowerCase(),
                            tagType: TagType.difference,
                          );
                        }),
                        TagsScreenData.filteredDifferenceList.isEmpty
                            ? Center(child: DefaultText("no_data".tr))
                            : SizedBox(),
                      ],
                    );
                  }
                  index--;
                  return TagItemWidget(
                    TagsScreenData.filteredDifferenceList[index],
                    const TagDetailsScreen(),
                  ).animate().scale(delay: (index * 50).ms);
                },
                itemCount: TagsScreenData.filteredDifferenceList.length + 1,
              );
      },
    );
  }
}
