import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
// import 'package:device_preview/device_preview.dart';
import 'package:dalalat_quran_light/db/database_helper.dart';
import 'package:dalalat_quran_light/features/chat/presentation/chat_screen.dart';
import 'package:dalalat_quran_light/features/grammer_rules/presentation/views/grammer_rules_view.dart';
import 'package:dalalat_quran_light/features/notifications/firebase.dart';
import 'package:dalalat_quran_light/features/radio/presenation/radio_screen.dart';
import 'package:dalalat_quran_light/features/words/presentation/roots_view.dart';
import 'package:dalalat_quran_light/ui/about_app_screen.dart';
import 'package:dalalat_quran_light/ui/add_comment.dart';
import 'package:dalalat_quran_light/ui/add_research.dart';
import 'package:dalalat_quran_light/ui/artice_details_screen.dart';
import 'package:dalalat_quran_light/ui/articles_screen/articles_screen.dart';
import 'package:dalalat_quran_light/ui/audio_recitations_screen.dart';
import 'package:dalalat_quran_light/ui/competition_screen.dart';
import 'package:dalalat_quran_light/ui/home_sura_screen.dart';
import 'package:dalalat_quran_light/ui/intro_screen.dart';
import 'package:dalalat_quran_light/ui/join_competition_screen.dart';
import 'package:dalalat_quran_light/ui/read_full_sura_screen/read_full_sura_screen.dart';
import 'package:dalalat_quran_light/ui/search_result_screen.dart';
import 'package:dalalat_quran_light/ui/select_language_screen.dart';
import 'package:dalalat_quran_light/ui/settings_screen/setting_screen.dart';
import 'package:dalalat_quran_light/ui/splash_screen.dart';
import 'package:dalalat_quran_light/ui/tag_details_screen.dart';
import 'package:dalalat_quran_light/ui/tags_screen/tags_screen.dart';
import 'package:dalalat_quran_light/ui/video_player_screen.dart';
import 'package:dalalat_quran_light/ui/video_screen/videos_screen.dart';
import 'package:dalalat_quran_light/utils/audio_folders.dart';
import 'package:dalalat_quran_light/utils/constants.dart';
import 'package:dalalat_quran_light/utils/current_locales.dart';
import 'package:dalalat_quran_light/utils/initialize_get_controllers.dart';
import 'package:dalalat_quran_light/utils/servicle_locator.dart';
import 'package:dalalat_quran_light/widgets/keyboard_dismiss_on_scroll.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServiceLocator();
  await GetStorage.init();
  DataBaseHelper.dataBaseInstance();
  // firebase
  await notificationsInit();
  GetStorage().read(KpageBg);
  GetStorage().read(KnormalFontColor);
  GetStorage().read(KtagWordsColor);
  log('Strorageeg ${GetStorage().read(KreadWordsColor)}');
  // await DataBaseHelper().initDb(); // Init DataBase
  await DataBaseHelper.dataBaseInstance().suraIndex();
  runApp(const DlalatQuran());
}

class DlalatQuran extends StatefulWidget {
  static final AudioPlayer mainAudioPlayer = AudioPlayer();

  const DlalatQuran({super.key});

  @override
  State<DlalatQuran> createState() => _DlalatQuranState();
}

class _DlalatQuranState extends State<DlalatQuran> {
  @override
  void initState() {
    initializeGetController();
    super.initState();
    initializeNotifications();
  }

  @override
  Widget build(BuildContext context) {
    AudioFolders().checkStoragePermission();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Update

    return GetMaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          foregroundColor: Colors.white, // 2
        ),
      ),
      // locale: GetStorage().read(language) != null ? Locale(GetStorage().read(language)) : Get.deviceLocale,
      locale: const Locale('ar'),
      translations: CurrentLocales(),
      debugShowCheckedModeBanner: false,
      title: 'دلالات القرآن',
      home: const SplashScreen(),
      getPages: [
        GetPage(name: SelectLanguageScreen.id, page: () => SelectLanguageScreen()),
        GetPage(name: SplashScreen.id, page: () => const SplashScreen()),
        GetPage(name: IntroScreen.id, page: () => const IntroScreen()),
        GetPage(name: ArticlesScreen.id, page: () => const ArticlesScreen()),
        GetPage(name: ArticleDetailsScreen.id, page: () => const ArticleDetailsScreen()),
        // GetPage(
        //   name: VideoCategoriesScreen.id,
        //   page: () => VideoCategoriesScreen(),
        // ),
        GetPage(name: TagsScreen.id, page: () => const TagsScreen()),
        GetPage(name: TagDetailsScreen.id, page: () => const TagDetailsScreen()),
        GetPage(name: SettingScreen.id, page: () => SettingScreen()),
        GetPage(
          name: AboutAppScreen.id,
          page: () => const AboutAppScreen(aboutText: ''),
        ),
        // GetPage(
        //   name: VideoLibraryScreen.id,
        //   page: () => VideoLibraryScreen(),
        // ),
        GetPage(name: AudioRecitationsScreen.id, page: () => AudioRecitationsScreen()),
        GetPage(
          name: VideoPlayerScreen.id,
          page: () => const VideoPlayerScreen(videoId: ""),
        ),
        GetPage(name: HomeSuraScreen.id, page: () => const HomeSuraScreen()),
        GetPage(name: SearchResultScreen.id, page: () => SearchResultScreen()),
        GetPage(name: AddCommentView.id, page: () => const AddCommentView()),
        GetPage(name: AddResearchView.id, page: () => const AddResearchView()),
        GetPage(name: RadioScreen.id, page: () => const RadioScreen()),
        GetPage(name: CompetitionsScreen.id, page: () => const CompetitionsScreen()),
        GetPage(name: JoinCompetitonView.id, page: () => JoinCompetitonView()),
        GetPage(name: VideosScreen.id, page: () => const VideosScreen()),
        GetPage(name: ReadFullSuraScreen.id, page: () => const ReadFullSuraScreen()),
        GetPage(name: ChatScreen.id, page: () => const ChatScreen()),
        GetPage(name: GrammarRulesView.id, page: () => const GrammarRulesView()),
        // GetPage(
        //   name: AudioPlayerScreen.id,
        //   page: () => const AudioPlayerScreen(),
        // ),
        GetPage(name: RootsView.id, page: () => const RootsView()),
      ],
      builder: (context, child) {
        if (child == null) return SizedBox();
        return KeyboardDismissOnScroll(child: child);
      },
    );
  }
}

/*

iPhone 6.9" Display > iPhone 16 Pro Max 
iPhone 6.5" Display > iPhone 11 Pro Max 
iPad 13" Display > iPad Pro 13-inch (M4) 
iPad 11" Display > iPad Pro (11-inch)

 */
