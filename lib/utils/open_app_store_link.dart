import 'dart:io' show Platform;

import 'package:url_launcher/url_launcher.dart';

Future<void> openAppStoreLink(String appName) async {
  const apps = {
    'calender': {
      'ios': 'https://apps.apple.com/us/app/eternal-islamic-calendar/id6738862001',
      'android': 'https://play.google.com/store/apps/details?id=com.gaztec.islamic_calander',
    },
    'inheritance': {
      'ios': 'https://apps.apple.com/us/app/mirath/id6745787906',
      'android': 'https://play.google.com/store/apps/details?id=com.gaztec.inheritance',
    },
  };

  final url = Platform.isIOS ? apps[appName]!['ios'] : apps[appName]!['android'];

  if (await canLaunchUrl(Uri.parse(url!))) {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}
