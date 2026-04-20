import 'package:dalalat_quran_light/features/our_work/models/app_info_model.dart';
import 'package:dalalat_quran_light/utils/assets.dart';

final List<AppInfo> apps = [
  AppInfo(
    title: "التقويم الإسلامي الأبدي",
    description:
        "إعادة هيكلة التقويم الهجري إلى نوعين: متزامن وقمري، بالاعتماد على دورة القمر الفعلية.",
    images: [
      AssetsData.islamicCalender1,
      AssetsData.islamicCalender2,
      AssetsData.islamicCalender3,
      AssetsData.islamicCalender4,
    ],
    appStoreUrl: "https://apps.apple.com/us/app/eternal-islamic-calendar/id6738862001",
    googlePlayUrl: "https://play.google.com/store/apps/details?id=com.gaztec.islamic_calander",
  ),
  AppInfo(
    title: "ميرات",
    description: """
ميراث هو أداة إرشادية وتعليمية لحساب الميراث،
من خلال نهج واضح يعتمد على خطوات متتابعة، يساعد تطبيق ميراث العائلات على فهم كيفية توزيع التركة وفقًا لمبادئ الشريعة الإسلامية الصحيحة، وذلك بعد سداد الديون وتنفيذ الوصايا.
""",
    images: [
      AssetsData.inheritance1,
      AssetsData.inheritance2,
      AssetsData.inheritance3,
      AssetsData.inheritance4,
      AssetsData.inheritance5,
      AssetsData.inheritance6,
    ],
    appStoreUrl: 'https://apps.apple.com/us/app/mirath/id6745787906',
    googlePlayUrl: 'https://play.google.com/store/apps/details?id=com.gaztec.inheritance',
  ),
];
