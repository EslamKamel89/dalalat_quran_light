import 'dart:developer';

import 'package:dalalat_quran_light/db/database_helper.dart';
import 'package:dalalat_quran_light/models/reciters_model.dart';
import 'package:dalalat_quran_light/ui/settings_screen/setting_screen.dart';
import 'package:dalalat_quran_light/utils/constants.dart';
import 'package:dalalat_quran_light/utils/servicle_locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  var langPosition = 0.obs;
  var recitersList = <ReciterModel>[].obs;
  var recitersIds = [].obs;
  var selectedReciter = ReciterModel().obs;
  String selectedReciterId = '1';
  var pageBg = 10.obs;
  var normalFontColor = 10.obs;
  var tagWordsColor = 10.obs;
  var readWordsColor = 10.obs;
  var colorLoading = true.obs;
  var lastSyncDate = ''.obs;

  FontType? fontType;
  var mFontType = FontType.normal.name.obs;
  SharedPreferences sharedPref = serviceLocator<SharedPreferences>();
  FontType fontTypeEnum = FontType.normal;

  bool get showNotifications {
    return sharedPref.getBool('showNotifications') ?? true;
  }

  set showNotifications(bool val) {
    sharedPref.setBool('showNotifications', val);
  }

  bool get showAppDetails {
    return sharedPref.getBool('showAppDetails') ?? false;
  }

  set showAppDetails(bool val) {
    sharedPref.setBool('showAppDetails', val);
  }

  void changeFontType(FontType fontType) {
    fontTypeEnum = fontType;
    update();
  }

  @override
  void onInit() async {
    super.onInit();
    pageBg.value = await DataBaseHelper.dataBaseInstance().getColor(KpageBg);
    normalFontColor.value = await DataBaseHelper.dataBaseInstance().getColor(KnormalFontColor);
    tagWordsColor.value = await DataBaseHelper.dataBaseInstance().getColor(KtagWordsColor);
    readWordsColor.value = await DataBaseHelper.dataBaseInstance().getColor(KreadWordsColor);

    colorLoading.value = false;
    var lang = await GetStorage().read(language);
    if (lang != null) {
      langPosition.value = _getPositionFromCode(await GetStorage().read(language));
    }

    var sharedPref = await SharedPreferences.getInstance();
    selectedReciterId = sharedPref.getString(reciterKey) ?? "1";
    mFontType.value = GetStorage().read(fontTypeKey).toString() == 'null'
        ? FontType.normal.name
        : GetStorage().read(fontTypeKey);
    fontType = mFontType.value == normal ? FontType.normal : FontType.bold;
    log(
      'Language = ${_getPositionFromCode(GetStorage().read(language))} Storage = ${GetStorage().read(language)}',
    );
    update();
    getReciters();
    // update();
  }

  void setSelectedLocale(int position) {
    langPosition.value = position;
    GetStorage().write(language, modes[position].langCode);
    Get.updateLocale(Locale(modes[position].langCode));
    update();
  }

  int _getPositionFromCode(String code) {
    int pos = 0;
    switch (code) {
      case 'ar':
        pos = 0;
        break;
      case 'en':
        pos = 1;
        break;
      case 'fr':
        pos = 2;
        break;
      case 'es':
        pos = 3;
        break;
      case 'it':
        pos = 4;
        break;
      default:
        pos = 0;
        break;
    }

    return pos;
  }

  void getReciters() async {
    // lastSyncDate.value = await DataBaseHelper.dataBaseInstance().getLastSyncDate();
    // recitersList.value = await DataBaseHelper.dataBaseInstance().getReciters();
    // for (var x = 0; x < recitersList.length; x++) {
    //   recitersIds.add(recitersList[x].id.toString());
    // }
    // update();
    // getSelectedReciter();

    // update();
  }

  void getSelectedReciter() {
    try {
      selectedReciter.value = recitersList
          .where(((x) => x.id!.toString() == selectedReciterId))
          .first;
      log('getSelectedReciter Inside Try $selectedReciterId ');
    } catch (e) {
      selectedReciter.value = recitersList[0];
    }

    update();
  }

  void setPageBg(int index) {
    pageBg.value = index;
    // DataBaseHelper.dataBaseInstance().updateColor(KpageBg, pageBg.value);
  }

  void setNormalFont(int index) {
    normalFontColor.value = index;
    // DataBaseHelper.dataBaseInstance().updateColor(KnormalFontColor, normalFontColor.value);
  }

  void setTagWordsColor(int index) {
    tagWordsColor.value = index;
    // DataBaseHelper.dataBaseInstance().updateColor(KtagWordsColor, tagWordsColor.value);
  }

  void setReadingColor(int index) {
    readWordsColor.value = index;
    // DataBaseHelper.dataBaseInstance().updateColor(KreadWordsColor, readWordsColor.value);
  }

  void saveSetting() {
    sharedPref.setString(reciterKey, selectedReciter.value.id.toString());
    GetStorage().write(fontTypeKey, mFontType.value);
    GetStorage().write(reciterKey, selectedReciter.value.id);
  }

  int lanIndex() {
    var mLang = GetStorage().read(language);
    return _getPositionFromCode(mLang);
  }
}
