import 'package:dalalat_quran_light/ui/about_app_screen.dart';
import 'package:dalalat_quran_light/utils/api_service/dio_consumer.dart';
import 'package:dalalat_quran_light/utils/constants.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:dalalat_quran_light/utils/servicle_locator.dart';
import 'package:dalalat_quran_light/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutButton extends StatefulWidget {
  const AboutButton({super.key});

  @override
  State<AboutButton> createState() => _AboutButtonState();
}

class _AboutButtonState extends State<AboutButton> {
  String? _aboutText;
  @override
  void initState() {
    _fetchAbout();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _aboutText == null
        ? SizedBox()
        : Column(
            children: [
              const SizedBox(height: 8),
              Container(
                decoration: const BoxDecoration(),
                margin: const EdgeInsets.only(bottom: 30),
                height: 60,
                width: Get.width / 1.5,
                child: PrimaryButton(
                  onPressed: () => Get.to(
                    AboutAppScreen(aboutText: _aboutText ?? ''),
                    transition: Transition.fadeIn,
                  ),
                  borderRadius: 15,
                  child: Stack(
                    children: [
                      Image.asset(toolBarBackImage, fit: BoxFit.cover, height: Get.height / 11),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(child: Image.asset(logoSmall, height: 20)),
                              Center(
                                child: Text(
                                  'app_name'.tr,
                                  textScaleFactor: 1.0,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Almarai',
                                    height: 1.5,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Center(
                            child: Text(
                              'about_app'.tr,
                              textScaleFactor: 1.0,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Almarai',
                                height: 1.5,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
  }

  Future _fetchAbout() async {
    final t = "_fetchAbout";
    String path = "${baseUrl()}about";
    final DioConsumer dio = serviceLocator<DioConsumer>();
    try {
      final response = await dio.get(path);
      pr(response, '$t - response');
      if (mounted) {
        setState(() {
          _aboutText = response['content'];
        });
      }
    } catch (e) {
      String errorMessage = e.toString();
      pr(errorMessage, t);
    }
  }
}
