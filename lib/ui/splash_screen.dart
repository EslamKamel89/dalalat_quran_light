import 'package:dalalat_quran_light/controllers/settings_controller.dart';
import 'package:dalalat_quran_light/ui/select_language_screen.dart';
import 'package:dalalat_quran_light/utils/constants.dart';
import 'package:dalalat_quran_light/widgets/splash_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import 'intro_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String id = "/SplashScreen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // SyncManager manager = Get.put(SyncManager());
  @override
  void initState() {
    _startApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var itemSize = (MediaQuery.of(context).size.width - 80) / 2.5;
    return SafeArea(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SplashBackground(
            childWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(logoMedium, height: itemSize),
                const SizedBox(height: 10),
                SizedBox(
                  width: itemSize - 15,
                  child: FittedBox(
                    child: Text(
                      'app_name'.tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: "Almarai",
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Positioned(
          //     top: 100,
          //     child: Obx(() =>
          //         manager.isLoading.value ? LoadingView() : SizedBox()))
        ],
      ),
    );
  }

  Future _startApp() async {
    final res = await DomainService.selectWorkingDomain();
    final settingController = Get.find<SettingsController>().setSelectedLocale(0);
    // Widget nextPage =
    //     GetStorage().read(language) != null  ? const IntroScreen() : SelectLanguageScreen();
    showLangSelector = res?['lang'] == 1;
    Widget nextPage = showLangSelector ? SelectLanguageScreen() : IntroScreen();
    Get.offAll(nextPage);
    // Future.delayed(const Duration(seconds: 2), () {
    //   Widget nextPage =
    //       GetStorage().read(language) != null || true
    //           ? const IntroScreen()
    //           : SelectLanguageScreen();
    //   Get.offAll(nextPage);
    // });
  }
}

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SpinKitPouringHourGlassRefined(color: Colors.white),
        SizedBox(height: 10),
        Material(
          color: Colors.transparent,
          child: Text(
            ' برجاء الانتظار\nجار تحديث البيانات',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Almarai',
              color: Colors.white,
              wordSpacing: 3,
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }
}
