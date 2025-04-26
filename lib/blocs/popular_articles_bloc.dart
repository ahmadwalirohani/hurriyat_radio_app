//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:hurriyat_radio/models/article.dart';
import 'package:hurriyat_radio/models/news_model.dart';
import 'package:dio/dio.dart' as dio;
import 'package:hurriyat_radio/news.dart';

class PopularBloc extends ChangeNotifier {
  List<dynamic> _data = [];
  List<dynamic> get data => _data;

  List featuredList = [];

  bool _hasData = true;
  bool get hasData => _hasData;
  Locale? localeLang;

  final _locales = {'en': 1, 'ps': 2, 'fa': 3, 'ar': 4};

  Future<List<NewsModel>> _getNewsList() async {
    try {
      dio.Dio _dio = dio.Dio();

      var f = _locales[localeLang.toString()];

      String url = "https://hurriyat.net/api/news/${f}";

      dio.Response response = await _dio.get(url);
      News newresponse = News.fromJson(response.data);
      _data = newresponse.data;
      featuredList = newresponse.data;
      return newresponse.data;
    } on dio.DioException catch (e) {
      print("this is the main error" + e.error.toString());
      return [];
    }
  }

  Future getData([Locale? locale = null]) async {
    if (locale != null) {
      localeLang = locale;
    }
    await _getNewsList();
    _hasData = true;
    notifyListeners();
  }

  onRefresh() {
    featuredList.clear();
    _data.clear();
    _hasData = true;
    getData();
    notifyListeners();
  }
}
