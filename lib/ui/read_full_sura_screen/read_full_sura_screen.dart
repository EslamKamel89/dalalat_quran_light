import 'package:audioplayers/audioplayers.dart';
import 'package:dalalat_quran_light/controllers/read_full_surah_controller.dart';
import 'package:dalalat_quran_light/features/radio/presenation/radio_screen.dart';
import 'package:dalalat_quran_light/ui/home_sura_screen.dart';
import 'package:dalalat_quran_light/ui/intro_screen.dart';
import 'package:dalalat_quran_light/ui/read_full_sura_screen/widgets/new_ayas_spinner.dart';
import 'package:dalalat_quran_light/ui/read_full_sura_screen/widgets/new_suras_spinner.dart';
import 'package:dalalat_quran_light/ui/read_full_sura_screen/widgets/read_full_sura_audio_player.dart';
import 'package:dalalat_quran_light/ui/settings_screen/setting_screen.dart';
import 'package:dalalat_quran_light/utils/colors.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:dalalat_quran_light/widgets/quran_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReadFullSuraScreen extends StatefulWidget {
  const ReadFullSuraScreen({super.key});
  static String id = '/ReadFullSuraScreen';

  @override
  State<ReadFullSuraScreen> createState() => _ReadFullSuraScreenState();
}

class _ReadFullSuraScreenState extends State<ReadFullSuraScreen> {
  final TextEditingController _textController = TextEditingController(
    // text: "https://listen.radioking.com/radio/810226/stream/879041",
    // text: "https://stream.live.vc.bbcmedia.co.uk/bbc_world_service",
    text:
        "http://as-hls-ww-live.akamaized.net/pool_62063831/live/ww/bbc_radio_one_dance/bbc_radio_one_dance.isml/bbc_radio_one_dance-audio%3d96000.norewind.m3u8",
  );
  int currentIndex = 0;
  final bool showRadio = false;
  @override
  Widget build(BuildContext context) {
    if (!showRadio) {
      return Scaffold(
        backgroundColor: lightGray,
        appBar: QuranBar(
          'audio_recitations'.tr,
          backCallback: () {
            Get.offNamedUntil(IntroScreen.id, (_) => false);
          },
        ),
        body: QuranAudioWidget(),
      );
    }
    return Scaffold(
      backgroundColor: lightGray,
      appBar: QuranBar(
        'audio_recitations'.tr,
        backCallback: () {
          Get.offNamedUntil(IntroScreen.id, (_) => false);
        },
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(height: 5),
            TextFormField(controller: _textController),
            TabBar(
              indicatorColor: Colors.transparent,
              tabs: [
                TabButton(title: "القرآن الكريم", selected: currentIndex == 0),
                TabButton(title: "الراديو", selected: currentIndex == 1),
              ],
              onTap: (value) {
                currentIndex = value;
                setState(() {});
              },
            ),
            Expanded(
              child: currentIndex == 0
                  ? const QuranAudioWidget()
                  : StreamAudioPlayer(url: _textController.text),
            ),
          ],
        ),
      ),
    );
  }
}

class QuranAudioWidget extends StatefulWidget {
  const QuranAudioWidget({super.key});

  @override
  State<QuranAudioWidget> createState() => _QuranAudioWidgetState();
}

class _QuranAudioWidgetState extends State<QuranAudioWidget> {
  late ReadFullSurahController controller;
  late AudioPlayer audioPlayer;
  @override
  void initState() {
    controller = Get.put(ReadFullSurahController());
    pr('init state is called');
    controller.audioPlayer = AudioPlayer();
    audioPlayer = controller.audioPlayer;
    super.initState();
  }

  @override
  void dispose() {
    controller.clearAllData();
    pr('dispose is called');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const horizontalPadding = EdgeInsets.symmetric(horizontal: 10);
    return Builder(
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.only(),
          child: Column(
            children: [
              // Center(child: Image.asset(soundMedium, height: 100)),
              const SizedBox(height: 30),
              Padding(
                padding: horizontalPadding,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text('reciter'.tr, style: const TextStyle(fontFamily: 'Almarai')),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        margin: const EdgeInsets.only(left: 8, right: 8),
                        height: 50,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          color: Colors.white,
                        ),
                        child: const RecitersSpinner(),
                        // child: LanguageSpinner(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 35),
              Padding(
                padding: horizontalPadding,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text('choose_sura'.tr, style: const TextStyle(fontFamily: 'Almarai')),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        margin: const EdgeInsets.only(left: 8, right: 8),
                        height: 50,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          color: Colors.white,
                        ),
                        child: const NewSurasSpinner(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 35),
              Padding(
                padding: horizontalPadding,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text('choose_aya'.tr, style: const TextStyle(fontFamily: 'Almarai')),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        margin: const EdgeInsets.only(left: 8, right: 8),
                        height: 50,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          color: Colors.white,
                        ),
                        child: const NewAyasSpinner(),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GetBuilder<ReadFullSurahController>(
                builder: (_) {
                  return controller.selectedSuraModel == null
                      ? const SizedBox()
                      : const AudioPlayerFullSuraWidget();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
