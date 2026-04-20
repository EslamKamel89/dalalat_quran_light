import 'package:dalalat_quran_light/models/language_model.dart';
import 'package:dalalat_quran_light/utils/api_service/dio_consumer.dart';
import 'package:dalalat_quran_light/utils/print_helper.dart';
import 'package:dalalat_quran_light/utils/servicle_locator.dart';
import 'package:get/get.dart';

const String logoSmall = "assets/images/logo_small.png";
const String logoMedium = "assets/images/logo_medium.png";

const googlePlayLink = 'https://play.google.com/store/apps/details?id=com.quaran.yourapp';
const appStoreLink = 'https://apps.apple.com/us/app/your-app-name/idXXXXXXXXX';

const String soundMedium = "assets/images/sound_medium.png";

const String soundIcon = 'assets/icons/ic_sound.png';

const String arabic = "assets/icons/saudi_arabia.png";
const String english = "assets/icons/united_kingdom.png";
const String french = "assets/icons/france.png";
const String spanish = "assets/icons/spain.png";
const String italy = "assets/icons/italy.png";
const String toolBarBackImage = 'assets/images/toolbar_image.png';
const String language = 'language';
const String reciterKey = 'reciterKey';
const String fontTypeKey = 'fontTypeKey';
const String audioPath = 'audioPath';
const String iconsPath = 'iconsPath';

const String KpageBg = "pageBg";
const String KnormalFontColor = "normalFontColor";
const String KtagWordsColor = "tagWordsColor";
const String KreadWordsColor = "readWordsColor";

String ayaLink = '${domainUrl()}public/storage/sounds/';

const String normal = 'normal';
const String bold = 'bold';
bool showLangSelector = false;
const String savedPage = "currentPage";
const String checkVideos = "hasVideos";

const String randomText =
    "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخرى إضافة إلى زيادة عدد الحروف التى يولدها التطبيق. إذا كنت تحتاج إلى عدد أكبر من الفقرات يتيح لك مولد النص العربى زيادة عدد الفقرات كما تريد، النص لن يبدو مقسما ولا يحوي أخطاء لغوية، مولد النص العربى مفيد لمصممي المواقع على وجه الخصوص، حيث يحتاج العميل فى كثير من الأحيان أن يطلع على صورة حقيقية لتصميم الموقع. ومن هنا وجب على المصمم أن يضع نصوصا مؤقتة على التصميم ليظهر للعميل الشكل كاملاً،دور مولد النص العربى أن يوفر على المصمم عناء البحث عن نص بديل لا علاقة له بالموضوع الذى يتحدث عنه التصميم فيظهر بشكل لا يليق. هذا النص يمكن أن يتم تركيبه على أي تصميم دون مشكلة فلن يبدو وكأنه نص منسوخ، غير منظم، غير منسق، أو حتى غير مفهوم. لأنه مازال نصاً بديلاً ومؤقتاً. هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخرى إضافة إلى زيادة عدد الحروف التى يولدها التطبيق.إذا كنت تحتاج إلى عدد أكبر من الفقرات يتيح لك مولد النص العربى زيادة عدد الفقرات كما تريد، النص لن يبدو مقسما ولا يحوي أخطاء لغوية، مولد النص العربى مفيد لمصممي المواقع على وجه الخصوص، حيث يحتاج العميل فى كثير من الأحيان أن يطلع على صورة حقيقية لتصميم الموقع.ومن هنا وجب على المصمم أن يضع نصوصا مؤقتة على التصميم ليظهر للعميل الشكل كاملاً،دور مولد النص العربى أن يوفر على المصمم عناء البحث عن نص بديل لا علاقة له بالموضوع الذى يتحدث عنه التصميم فيظهر بشكل لا يليق. هذا النص يمكن أن يتم تركيبه على أي تصميم دون مشكلة فلن يبدو وكأنه نص منسوخ، غير منظم، غير منسق، أو حتى غير مفهوم. لأنه مازال نصاً بديلاً ومؤقتاً  هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخرى إضافة إلى زيادة عدد الحروف التى يولدها التطبيق. إذا كنت تحتاج إلى عدد أكبر من الفقرات يتيح لك مولد النص العربى زيادة عدد الفقرات كما تريد، النص لن يبدو مقسما ولا يحوي أخطاء لغوية، مولد النص العربى مفيد لمصممي المواقع على وجه الخصوص، حيث يحتاج العميل فى كثير من الأحيان أن يطلع على صورة حقيقية لتصميم الموقع. ومن هنا وجب على المصمم أن يضع نصوصا مؤقتة على التصميم ليظهر للعميل الشكل كاملاً،دور مولد النص العربى أن يوفر على المصمم عناء البحث عن نص بديل لا علاقة له بالموضوع الذى يتحدث عنه التصميم فيظهر بشكل لا يليق. هذا النص يمكن أن يتم تركيبه على أي تصميم دون مشكلة فلن يبدو وكأنه نص منسوخ، غير منظم، غير منسق، أو حتى غير مفهوم. لأنه مازال نصاً بديلاً ومؤقتاً.";

bool isSmallScreen = Get.size.aspectRatio > 0.500;
const String ayahExplanationKey = 'ayahExplantion.';
const String wordTagKey = 'wordTag.';
const String tagsKey = 'tag.';
const String articlesKey = 'article.';
const String articleDetailsKey = 'articleDetails.';
const String tagDetailsKey = 'tagDetails.';
const String similarWordsKey = 'similarWords.';
const String correctWordsKey = 'correctWords.';

final List<LanguageModel> modes = [
  LanguageModel("arabic".tr, arabic, 0, 6, false, 'ar'),
  LanguageModel("English".tr, english, 1, 7, false, 'en'),
  // LanguageModel("French".tr, french, 2, 13, false, 'fr'),
  // LanguageModel("Spanish".tr, spanish, 3, 16, false, 'es'),
  // LanguageModel("italy".tr, italy, 4, 21, false, 'it'),
];

baseUrl() => "${domainUrl()}api/v1/";
// domainUrl() => "https://ioqs.org/control-panel/";
domainUrl() => DomainService.currentDomain;

class DomainService {
  static const _mainDomain = "https://ioqs.org/control-panel/";
  static const _backupDomain = "https://quran.safqauae.com/";
  static String currentDomain = _mainDomain;
  static final DioConsumer _dio = serviceLocator<DioConsumer>();
  static Future<Map<String, dynamic>?> selectWorkingDomain() async {
    final t = "selectWorkingDomain";
    // currentDomain = _backupDomain;
    // return;
    try {
      final response = await _dio.get("${baseUrl()}app-version");
      pr(response, '$t - response');
      if (response['maintenance_mode'] == 0) {
        currentDomain = _mainDomain;
      } else {
        currentDomain = _backupDomain;
      }
      return response;
    } catch (e) {
      String errorMessage = e.toString();
      pr(errorMessage, t);
      currentDomain = _backupDomain;
    }
    return null;
  }
}
