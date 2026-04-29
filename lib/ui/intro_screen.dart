import 'package:dalalat_quran_light/controllers/correct_word_controller.dart';
import 'package:dalalat_quran_light/controllers/similar_word_controller.dart';
import 'package:dalalat_quran_light/features/chat/presentation/chat_screen.dart';
import 'package:dalalat_quran_light/features/grammer_rules/presentation/views/grammer_rules_view.dart';
import 'package:dalalat_quran_light/features/notifications/presentation/widgets/notifications_button.dart';
import 'package:dalalat_quran_light/features/quran/presentation/surah_list_view.dart';
import 'package:dalalat_quran_light/features/words/presentation/reference_view.dart';
import 'package:dalalat_quran_light/ui/articles_screen/articles_screen.dart';
import 'package:dalalat_quran_light/ui/read_full_sura_screen/read_full_sura_screen.dart';
import 'package:dalalat_quran_light/ui/settings_screen/setting_screen.dart';
import 'package:dalalat_quran_light/ui/tags_screen/tags_screen.dart';
import 'package:dalalat_quran_light/ui/video_screen/videos_screen.dart';
import 'package:dalalat_quran_light/utils/assets.dart';
import 'package:dalalat_quran_light/utils/constants.dart';
import 'package:dalalat_quran_light/utils/current_locales.dart';
import 'package:dalalat_quran_light/utils/open_app_store_link.dart';
import 'package:dalalat_quran_light/utils/text_styles.dart';
import 'package:dalalat_quran_light/utils/version.dart';
import 'package:dalalat_quran_light/widgets/splash_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class IntroScreen extends StatefulWidget {
  static var id = '/IntroScreen';

  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  String centerViewImage = '';
  int centerViewImageStage = 1;
  @override
  void initState() {
    Version.checkVersions();
    WakelockPlus.enable();

    Get.find<SimilarWordController>().getSimilarWords();
    Get.find<CorrectWordController>().getCorrectWords();
    // getPermissionRequest();
    super.initState();
    _centerView();
  }

  @override
  Widget build(BuildContext context) {
    // pr('database deleted');
    // deleteDatabase('dlalat_qurann.db');
    // pr('sharedPreferences cleared');
    // serviceLocator<SharedPreferences>().clear();
    var itemSize = (MediaQuery.of(context).size.width - 80) / 3;
    var scHeight = Get.height;
    var scWidth = Get.width;
    if (isMobileScreen()) {
      return Stack(
        children: [
          SplashBackground(
            childWidget: Container(
              // padding: EdgeInsets.only(top: itemSize / 3),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, right: 10),
                      child: NotificationsButton(),
                    ),
                  ),

                  Image.asset(logoSmall, width: 40, height: 40),
                  Text(
                    'app_name'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: scHeight / 40,
                      fontFamily: 'Almarai',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'introText'.tr,
                    style: TextStyle(
                      color: const Color(0xFFF5B45E),
                      fontSize: isArabic() ? scHeight / 70 : scHeight / 50,
                      fontFamily: 'Almarai',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 70),
                  Transform.translate(
                    offset: Offset(0, 0),
                    child: Transform.scale(
                      scale: 1.2,
                      child: Stack(
                        children: [
                          _buildCenterView(width: scHeight / 2.8, height: scHeight / 2.3),
                          Positioned(
                            left: itemSize,
                            top: 20,
                            child: Container(
                              color: Colors.blue.withOpacity(0.0),
                              width: itemSize,
                              height: itemSize - 20,
                              child: GestureDetector(
                                onTap: () {
                                  Get.toNamed(ChatScreen.id);
                                  // Get.toNamed(HomeSuraScreen.id);
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            left: 20,
                            top: itemSize - 30,
                            child: Container(
                              color: Colors.green.withOpacity(0.0),
                              width: itemSize - 20,
                              height: itemSize - 20,
                              child: GestureDetector(onTap: () => Get.to(const ArticlesScreen())),
                            ),
                          ),
                          Positioned(
                            left: 20,
                            bottom: itemSize - 15,
                            child: Container(
                              color: Colors.red.withOpacity(0.0),
                              width: itemSize - 20,
                              height: itemSize - 20,
                              child: GestureDetector(onTap: () => Get.to(const TagsScreen())),
                            ),
                          ),
                          Positioned(
                            left: itemSize,
                            bottom: 15,
                            child: Container(
                              color: Colors.yellow.withOpacity(0.0),
                              width: itemSize,
                              height: itemSize - 20,
                              child: GestureDetector(onTap: () => Get.to(SettingScreen())),
                            ),
                          ),
                          Positioned(
                            right: 20,
                            top: itemSize - 30,
                            child: Container(
                              color: Colors.blue.withOpacity(0.0),
                              width: itemSize - 20,
                              height: itemSize - 20,
                              child: GestureDetector(
                                onTap: () => Get.toNamed(ReadFullSuraScreen.id),
                              ),
                              // child: GestureDetector(onTap: () => Get.toNamed(RadioScreen.id)),
                            ),
                          ),
                          Positioned(
                            right: 20,
                            bottom: itemSize - 15,
                            child: Container(
                              color: Colors.orange.withOpacity(0.0),
                              width: itemSize - 20,
                              height: itemSize - 20,
                              child: GestureDetector(
                                onTap: () =>
                                    Get.to(const VideosScreen(), transition: Transition.fade),
                              ),
                            ),
                          ),
                          Positioned(
                            top: itemSize + 5,
                            bottom: itemSize + 5,
                            left: itemSize - 20,
                            right: itemSize - 20,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0),
                                shape: BoxShape.circle,
                              ),
                              width: itemSize,
                              height: itemSize - 20,
                              child: GestureDetector(
                                onTap: () {
                                  // Get.toNamed(HomeSuraScreen.id);
                                  Get.to(() => SurahListView());
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          QuestionAndResearchWidget(),
        ],
      );
    }

    return Builder(
      builder: (context) {
        double centerViewWidth = 50.vw;
        double centerViewHeight = 40.vh;
        return Stack(
          children: [
            SplashBackground(
              childWidget: Container(
                padding: EdgeInsets.only(top: 5.vh),
                child: Column(
                  children: [
                    Image.asset(logoSmall, width: 10.vw, height: 10.vw),
                    Text(
                      'app_name'.tr,
                      // '',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 35, fontFamily: 'Almarai'),
                    ),
                    SizedBox(height: 2.vh),
                    Text(
                      'introText'.tr,
                      style: TextStyle(
                        color: const Color(0xFFF5B45E),
                        fontSize: 25,
                        fontFamily: 'Almarai',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.vh),
                    Transform.scale(
                      scale: 1.4,
                      child: Stack(
                        children: [
                          _buildCenterView(width: centerViewWidth, height: centerViewHeight),
                          // Image.asset(centerViewImage, width: 50.vw, height: 40.vh, fit: BoxFit.fill),
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            child: Center(
                              child: Container(
                                color: Colors.blue.withOpacity(0.0),
                                width: 20.vw,
                                height: 10.vh,
                                child: GestureDetector(
                                  onTap: () {
                                    Get.toNamed(ChatScreen.id);
                                  },
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0.vw,
                            top: 10.vh,
                            child: Container(
                              color: Colors.green.withOpacity(0.0),
                              width: 20.vw,
                              height: 10.vh,
                              child: GestureDetector(onTap: () => Get.to(const ArticlesScreen())),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            bottom: 10.vh,
                            child: Container(
                              color: Colors.red.withOpacity(0.0),
                              width: 20.vw,
                              height: 10.vh,
                              child: GestureDetector(onTap: () => Get.to(const TagsScreen())),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Center(
                              child: Container(
                                color: Colors.yellow.withOpacity(0.0),
                                width: 20.vw,
                                height: 10.vh,
                                child: GestureDetector(onTap: () => Get.to(SettingScreen())),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0.vw,
                            top: 10.vh,
                            child: Container(
                              color: Colors.blue.withOpacity(0.0),
                              width: 20.vw,
                              height: 10.vh,
                              child: GestureDetector(
                                onTap: () => Get.toNamed(ReadFullSuraScreen.id),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 10.vh,
                            child: Container(
                              color: Colors.orange.withOpacity(0.0),
                              width: 20.vw,
                              height: 10.vh,
                              child: GestureDetector(
                                onTap: () =>
                                    Get.to(const VideosScreen(), transition: Transition.fade),
                              ),
                            ),
                          ),
                          Positioned(
                            top: centerViewHeight * 0.3,
                            bottom: centerViewHeight * 0.3,
                            left: centerViewWidth * 0.3,
                            right: centerViewWidth * 0.3,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0),
                                shape: BoxShape.circle,
                              ),
                              width: itemSize,
                              height: itemSize - 20,
                              child: GestureDetector(
                                onTap: () {
                                  // Get.toNamed(HomeSuraScreen.id);
                                  Get.to(() => SurahListView());
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            QuestionAndResearchWidget(),
          ],
        );
      },
    );
  }

  void _centerView() {
    centerViewImageStage = 1;
    Future.delayed(Duration(milliseconds: 3000), () {
      // centerViewImage = AssetsData.centerViewCenterB();
      centerViewImageStage = 2;
      if (mounted) {
        setState(() {});
      }
    });
    // centerViewImage = AssetsData.centerViewCenterA();
  }

  Widget _buildCenterView({required double width, required double height}) {
    return Stack(
      children: [
        Image.asset(
          isArabic() ? AssetsData.centerViewMain : AssetsData.centerViewMainEn,
          width: width,
          height: height,
        ),
        // if (centerViewImage == AssetsData.centerViewCenterA())
        if (centerViewImageStage == 1)
          Image.asset(
            AssetsData.centerViewCenterA(),
            width: width,
            height: height,
          ).animate().fadeOut(duration: 3000.ms, begin: 1, delay: 1000.ms),

        // if (centerViewImage == AssetsData.centerViewCenterB())
        if (centerViewImageStage == 2)
          Image.asset(
            AssetsData.centerViewCenterB(),
            width: width,
            height: height,
          ).animate().fade(duration: 2000.ms, begin: 0.3, end: 1, delay: 1000.ms),
      ],
    );
  }
}

class QuestionAndResearchWidget extends StatelessWidget {
  const QuestionAndResearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double size = isMobileScreen() ? 15.vw : 14.vw;
    double fontSize = 12;
    return Positioned(
      bottom: 3.vh,
      right: 0,
      left: 0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.vw),
        child: SizedBox(
          // width: double,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (false)
                GestureDetector(
                  onTap: () {
                    openAppStoreLink('inheritance');
                  },
                  child: Column(
                    children: [
                      Container(
                        height: size,
                        width: size,
                        alignment: Alignment.center,
                        child: Image.asset(AssetsData.inheritanceIcon, fit: BoxFit.cover),
                      ),
                      SizedBox(height: 5),
                      ArabicText("inheritance".tr, color: Colors.white, fontSize: fontSize),
                    ],
                  ),
                ),
              GestureDetector(
                onTap: () {
                  // Get.toNamed(ChatScreen.id);
                  // Get.toNamed(CompetitionsScreen.id);
                  // showDialog(
                  //   context: context,
                  //   builder: (_) {
                  //     return FeatureNotFinished();
                  //   },
                  // );
                  // openAppStoreLink();
                  // Navigator.of(context).pushNamed(GrammarRulesView.id);
                  // await serviceLocator<SharedPreferences>().setString(
                  //   ShPrefKey.token,
                  //   'YvBzAraEpsE99XUN0vZzifs3br9JDE0HIkUumSaX',
                  // );
                  // if (isSignedIn()) {
                  //   Get.to(() => TopicsScreen());
                  // } else {
                  //   Get.to(() => DiscussionsLoginScreen());
                  // }
                  // Navigator.of(context).pushNamed(RootsView.id);
                  Get.to(() => ReferenceView());
                },
                child: Column(
                  children: [
                    Container(
                      height: size,
                      width: size,
                      alignment: Alignment.center,
                      // child: Image.asset(AssetsData.inheritanceIcon, fit: BoxFit.cover),
                      child: Image.asset(AssetsData.grammar, fit: BoxFit.cover),
                    ),
                    SizedBox(height: 5),
                    // ArabicText('التقويم الأسلامي', color: Colors.white, fontSize: fontSize),
                    // ArabicText("قواعد لسانية", color: Colors.white, fontSize: fontSize),
                    // ArabicText("المجلس", color: Colors.white, fontSize: fontSize),
                    ArabicText("reference".tr, color: Colors.white, fontSize: fontSize),
                  ],
                ),
              ),
              if (false)
                GestureDetector(
                  onTap: () {
                    openAppStoreLink('calender');

                    // Navigator.of(context).pushNamed(CompetitionsScreen.id);
                    // // Navigator.of(context).pushNamed(GrammarRulesView.id);
                  },
                  child: Column(
                    children: [
                      Container(
                        height: size,
                        width: size,
                        alignment: Alignment.center,
                        child: Image.asset(AssetsData.islamicCalenderLogo, fit: BoxFit.cover),
                      ),
                      SizedBox(height: 5),
                      ArabicText("islamic_calendar".tr, color: Colors.white, fontSize: fontSize),
                    ],
                  ),
                ),

              GestureDetector(
                onTap: () {
                  // Navigator.of(context).pushNamed(CompetitionsScreen.id);
                  Navigator.of(context).pushNamed(GrammarRulesView.id);
                },
                child: Column(
                  children: [
                    Container(
                      height: size,
                      width: size,
                      alignment: Alignment.center,
                      child: Image.asset(AssetsData.researchIcon3, fit: BoxFit.cover),
                      // child: Image.asset(AssetsData.logoNav, fit: BoxFit.cover),
                      // child: Image.asset(AssetsData.logoSmall, fit: BoxFit.cover),
                    ),
                    SizedBox(height: 5),
                    ArabicText("قواعد لسانية", color: Colors.white, fontSize: fontSize),

                    // ArabicText("سؤالٌ وجواب", color: Colors.white, fontSize: fontSize),
                    // ArabicText("اسئلة تبحث عن اجوبه", color: Colors.white, fontSize: fontSize),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension Height on int {
  double get vh => this * (Get.height / 100);
  double get vw => this * (Get.width / 100);
}

bool isMobileScreen() {
  return Get.width < 600;
}
