import 'package:dalalat_quran_light/db/database_helper.dart';
import 'package:dalalat_quran_light/features/notifications/models/notification_model.dart';
import 'package:dalalat_quran_light/features/quran/entities/surah_entity.dart';
import 'package:dalalat_quran_light/features/quran/presentation/quran_reader_view.dart';
import 'package:dalalat_quran_light/features/quran/presentation/surah_list_view.dart';
import 'package:dalalat_quran_light/ui/artice_details_screen.dart';
import 'package:dalalat_quran_light/ui/articles_screen/articles_screen.dart';
import 'package:dalalat_quran_light/ui/tag_details_screen.dart';
import 'package:dalalat_quran_light/ui/tags_screen/tags_screen.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:dalalat_quran_light/widgets/explain_dialog.dart';
import 'package:get/get.dart';

Future onNotificationClick(NotificationModel model) async {
  pr(model, 'notification model - onNotificationClick handler');
  /*
  * possible paths
  tags_equal
  tags_meaning
  articles
  ayats
  tags_rules
   */
  if (model.path == 'tags_equal') {
    Get.to(const TagsScreen(currentIndex: 0));
    await _delay();
    Get.to(TagDetailsScreen(), transition: Transition.fade, arguments: model.pathId);
  }
  if (model.path == 'tags_meaning') {
    Get.to(const TagsScreen(currentIndex: 1));
    await _delay();
    Get.to(TagDetailsScreen(), transition: Transition.fade, arguments: model.pathId);
  }
  if (model.path == 'tags_rules') {
    Get.to(const TagsScreen(currentIndex: 2));
    await _delay();
    Get.to(TagDetailsScreen(), transition: Transition.fade, arguments: model.pathId);
  }

  if (model.path == 'articles') {
    Get.to(const ArticlesScreen());
    await _delay();
    Get.to(const ArticleDetailsScreen(), transition: Transition.fadeIn, arguments: model.pathId);
  }
  if (model.path == 'ayats') {
    Get.to(() => SurahListView());
    await _delay();
    var page = model.page;
    var id = model.idAya;
    if ([page, id].contains(null)) return;
    var suraAr = await DataBaseHelper.dataBaseInstance().getSuraById(model.surah.toString());
    Get.to(
      () => QuranReaderView(
        surah: SurahEntity(id: -1, name: suraAr, startPage: page ?? -1),
      ),
    );

    await _delay();
    Get.dialog(
      ExplainDialog(ayaKey: "$id", videoId: '', suraName: suraAr, ayaNumber: model.pathId),
    );
  }
}

Future _delay() async {
  await Future.delayed(Duration(milliseconds: 200));
}
