import 'package:flutter/material.dart';

class Config {
  final String appName = 'Hurriyat Radio';
  final String splashIcon = 'assets/images/splash.png';
  final String supportEmail = 'support@hurriyat.net';
  final String privacyPolicyUrl = 'https://www.hurriyet.net';
  final String ourWebsiteUrl = 'https://www.hurriyat.net';
  final String iOSAppId = '000000';

  //social links
  static const String facebookPageUrl = 'https://www.facebook.com/HurriyatRadiopashto';
  static const String youtubeChannelUrl = 'https://www.youtube.com/@Hurriyat-Radio';
  static const String twitterUrl = 'https://twitter.com/HurriyatPa';

  //app theme color
  final Color appColor = const Color.fromARGB(255, 56, 129, 254);

  //Intro images
  final String introImage1 = 'assets/images/slide1.png';
  final String introImage2 = 'assets/images/slide2.png';
  final String introImage3 = 'assets/images/slide3.png';

  //animation files
  final String doneAsset = 'assets/animation_files/done.json';

  //Language Setup
  final List<String> languages = ['English', 'Pashto', 'Arabic', 'Dari'];

  //initial categories - 4 only (Hard Coded : which are added already on your admin panel)
  final List initialCategories = [
    'Afghanistan',
    'Asia',
    'World',
    'analysis',
    'articles',
    'programs'
  ];
}
