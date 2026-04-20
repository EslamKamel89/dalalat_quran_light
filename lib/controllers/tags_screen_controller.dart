import 'dart:convert';

import 'package:dalalat_quran_light/models/tag_model.dart';
import 'package:dalalat_quran_light/utils/api_service/dio_consumer.dart';
import 'package:dalalat_quran_light/utils/constants.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:dalalat_quran_light/utils/response_state_enum.dart';
import 'package:dalalat_quran_light/utils/servicle_locator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TagType { difference, meaning, equal }

String? tagTypeStr({required TagType tagType}) =>
    {
      TagType.equal: 'equal',
      TagType.meaning: 'meaning',
      // TagType.difference: 'difference',
      // TagType.difference: 'expression',
      TagType.difference: 'rules',
    }[tagType];
// String? tagTypeStr({required TagType tagType}) =>
//     {TagType.difference: 'difference', TagType.equal: 'equal', TagType.meaning: 'meaning'}[tagType];

abstract class TagsScreenData {
  static List tagsEqualsList = [];
  static List filteredEqualsList = [];
  static List tagsMeaningList = [];
  static List filteredMeaningList = [];
  static List tagsDifferenceList = [];
  static List filteredDifferenceList = [];
}

class TagsScreenController extends GetxController {
  var isLoading = true.obs;
  ResponseEnum responseState = ResponseEnum.initial;
  final getTagsEndpoint = "tag-type";
  void getTags({required TagType tagType}) async {
    // var list = await DataBaseHelper.dataBaseInstance().tagsIndex();
    pr(tagTypeStr(tagType: tagType));
    await getTagsApi(tagType: tagType);

    isLoading.value = false;
    update();
  }

  Future getTagsApi({required TagType tagType}) async {
    final t = 'getTagsApi - TagsScreenController - $tagType ';
    DioConsumer dioConsumer = serviceLocator();
    String path = baseUrl() + getTagsEndpoint;
    String deviceLocale = Get.locale?.languageCode ?? 'ar';

    responseState = ResponseEnum.loading;
    update();

    try {
      final response = await dioConsumer.get(
        "$path/${tagTypeStr(tagType: tagType)}?lang=$deviceLocale",
      );

      List data = jsonDecode(response);
      pr(data, '$t - raw response');

      List<TagModel> tags = data.map<TagModel>((json) => TagModel.fromJson(json)).toList();

      pr(tags, '$t - parsed response');

      await cacheTags(models: tags, tagType: tagType);

      setTagsList(tagType: tagType, tags: tags);

      responseState = ResponseEnum.success;
      update();
    } on Exception catch (e) {
      pr('Exception occured: $e', t);

      final cachedTags = await getCachedTags(tagType: tagType);

      if (cachedTags.isNotEmpty) {
        setTagsList(tagType: tagType, tags: cachedTags);
        responseState = ResponseEnum.success;
      } else {
        setTagsList(tagType: tagType, tags: []);
        responseState = ResponseEnum.failed;
      }

      update();
    }
  }

  void search({required String key, required TagType tagType}) {
    switch (tagType) {
      case TagType.difference:
        TagsScreenData.filteredDifferenceList = TagsScreenData.tagsDifferenceList;
        TagsScreenData.filteredDifferenceList =
            TagsScreenData.tagsDifferenceList.where(((x) {
              return x.toString().toLowerCase().contains(key.toLowerCase());
            })).toList();
        update();
        break;
      case TagType.meaning:
        TagsScreenData.filteredMeaningList = TagsScreenData.tagsMeaningList;
        TagsScreenData.filteredMeaningList =
            TagsScreenData.tagsMeaningList.where(((x) {
              return x.toString().toLowerCase().contains(key.toLowerCase());
            })).toList();
        update();
        break;
      case TagType.equal:
        TagsScreenData.filteredEqualsList = TagsScreenData.tagsEqualsList;
        TagsScreenData.filteredEqualsList =
            TagsScreenData.tagsEqualsList.where(((x) {
              return x.toString().toLowerCase().contains(key.toLowerCase());
            })).toList();
        update();
        break;
    }
  }

  Future<void> cacheTags({required List<TagModel> models, required TagType tagType}) async {
    final prefs = serviceLocator<SharedPreferences>();

    final List<Map<String, dynamic>> jsonList = models.map((e) => e.toJson()).toList();

    await prefs.setString('$tagsKey ${tagTypeStr(tagType: tagType)!}', jsonEncode(jsonList));
  }

  Future<List<TagModel>> getCachedTags({required TagType tagType}) async {
    final prefs = serviceLocator<SharedPreferences>();

    final String? cached = prefs.getString('$tagsKey ${tagTypeStr(tagType: tagType)!}');

    if (cached == null || cached.isEmpty) return [];

    final List data = jsonDecode(cached);

    return data.map<TagModel>((json) => TagModel.fromJson(json)).toList();
  }

  void setTagsList({required TagType tagType, required List<TagModel> tags}) {
    switch (tagType) {
      case TagType.difference:
        TagsScreenData.tagsDifferenceList = tags;
        TagsScreenData.filteredDifferenceList = tags;
        break;
      case TagType.meaning:
        TagsScreenData.tagsMeaningList = tags;
        TagsScreenData.filteredMeaningList = tags;
        break;
      case TagType.equal:
        TagsScreenData.tagsEqualsList = tags;
        TagsScreenData.filteredEqualsList = tags;
        break;
    }
  }
}
