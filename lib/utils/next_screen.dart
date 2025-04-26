import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hurriyat_radio/models/news_model.dart';
import 'package:hurriyat_radio/pages/analysis_details.dart';
import 'package:hurriyat_radio/pages/article2_details.dart';
import 'package:hurriyat_radio/pages/article_details.dart';
import 'package:hurriyat_radio/pages/video_article_details.dart';
import 'package:hurriyat_radio/pages/video_details_card.dart';
import 'package:hurriyat_radio/pages/weekly_details.dart';

import '../models/notification.dart';
// import '../pages/custom_notification_details.dart';
// import '../pages/post_notification_details.dart';

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreeniOS(context, page) {
  Navigator.push(context, CupertinoPageRoute(builder: (context) => page));
}

void nextScreenCloseOthers(context, page) {
  Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (context) => page), (route) => false);
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenPopup(context, page) {
  Navigator.push(
    context,
    MaterialPageRoute(fullscreenDialog: true, builder: (context) => page),
  );
}

void navigateToDetailsScreen(context, dynamic article, String? heroTag,
    [bool is_video = false]) {
  if (is_video) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => VideoArticleDetails(data: article)),
    );
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ArticleDetails(
                data: article,
                tag: heroTag,
              )),
    );
  }
}

void navigateToVideoDetailsScreen(context, dynamic article, String? heroTag,
    [bool is_video = false]) {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => VideoDetailsCard(
              title: article.title,
              host: article.host,
              info: article.description,
              videoUrl: article.video_link,
              //tag: heroTag,
            )),
  );
}

void navigateToWeeklyDetailsScreen(context,dynamic document) {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => DocumentDetailScreen(document : document)),
  );
}


void navigateToAnalysisDetailsScreen(context, dynamic article, String? heroTag,
    [bool is_video = false]) {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => AnalysisDetails(
              data: article,
              tag: heroTag,
            )),
  );
}

void navigateToArticleDetailsScreen(context, dynamic article, String? heroTag,
    [bool is_video = false]) {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => Article2Details(
              data: article,
              tag: heroTag,
            )),
  );
}

void navigateToDetailsScreenByReplace(
    context, NewsModel article, String? heroTag, bool? replace) {
  if (replace == null || replace == false) {
    navigateToDetailsScreen(context, article, heroTag);
  } else {
    if (false == 'video') {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) => VideoArticleDetails(data: article)),
      // );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ArticleDetails(
                  data: article,
                  tag: heroTag,
                )),
      );
    }
  }
}

void navigateToNotificationDetailsScreen(
    context, NotificationModel notificationModel) {
  // if (notificationModel.postId == null) {
  //   nextScreen(context,
  //       CustomNotificationDeatils(notificationModel: notificationModel));
  // } else {
  //   nextScreen(
  //       context, PostNotificationDetails(postID: notificationModel.postId!));
  // }
}
