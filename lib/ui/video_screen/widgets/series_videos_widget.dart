import 'package:dalalat_quran_light/controllers/video_series_controller.dart';
import 'package:dalalat_quran_light/models/video_series_model.dart';
import 'package:dalalat_quran_light/ui/video_screen/widgets/video_series_card.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/text_styles.dart';
import 'package:dalalat_quran_light/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SeriesVideosWidget extends StatefulWidget {
  const SeriesVideosWidget({super.key});

  @override
  State<SeriesVideosWidget> createState() => _SeriesVideosWidgetState();
}

class _SeriesVideosWidgetState extends State<SeriesVideosWidget> {
  final VideosSeriesController _videoController = Get.find<VideosSeriesController>()
    ..getVideoSeries();
  final TextEditingController _textEditingController = TextEditingController();
  @override
  void initState() {
    _videoController.getVideoSeries();
    _textEditingController.addListener(() {
      _videoController.search(_textEditingController.text.toString().toLowerCase());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          SearchWidget(_textEditingController, null, () {
            _videoController.search(_textEditingController.text.toString().toLowerCase());
          }),
          GetBuilder<VideosSeriesController>(
            builder: (_) {
              if (_videoController.responseState == ResponseEnum.loading) {
                return const Expanded(child: Center(child: CircularProgressIndicator()));
              }
              if (_videoController.responseState == ResponseEnum.success &&
                  VideosSeriesData.filteredList.isEmpty) {
                return Expanded(child: Center(child: ArabicText("no_data".tr)));
              }
              return Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    VideoSeriesModel videoSeriesModel = VideosSeriesData.filteredList[index];
                    return VideoSeriesCard(videoSeriesModel: videoSeriesModel);
                  },
                  itemCount: VideosSeriesData.filteredList.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
