import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:hurriyat_radio/analysis.dart';
import 'package:hurriyat_radio/models/analysis_model.dart';
import 'package:hurriyat_radio/news.dart';

class CategoryTab4Bloc extends ChangeNotifier {
  List<AnalysisModel> _data = [];
  List<AnalysisModel> get data => _data;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  int currentPage = 1;

  bool? _hasData;
  bool? get hasData => _hasData;

  Locale? localeLang;

  final _locales = {'en': 1, 'ps': 2, 'fa': 3, 'ar': 4};
  Future<List<AnalysisModel>> _getAnalysisList(String? category,
      [bool isFirst = true]) async {
    final Map<String, dynamic> queryParams = {
      'page': currentPage,
    };

    try {
      dio.Dio _dio = dio.Dio();

      var f = _locales[localeLang.toString()];

      String url = "https://hurriyat.net/api/analysis/$f";

      dio.Response response = await _dio.get(url, queryParameters: queryParams);

      currentPage = response.data['current_page'] as int;

      Analysis newresponse = Analysis.fromJson(response.data);

      _data = [..._data, ...newresponse.data];
      _isLoading = false;
      return newresponse.data;
    } on dio.DioException catch (e) {
      print("this is the main error" + e.error.toString());
      return [];
    }
  }

  Future getData(mounted, String category,
      [bool isFirst = true, Locale? locale]) async {
    if (locale != null) {
      localeLang = locale;
    }
    if (!isFirst) {
      currentPage += 1;
    } else {
      _data.clear();
    }

    await _getAnalysisList(category);
    notifyListeners();
  }

  setLoading(bool isloading) {
    _isLoading = isloading;
    notifyListeners();
  }

  onRefresh(mounted, String category) {
    _isLoading = true;
    //_snap.clear();
    _data.clear();
    // _lastVisible = null;
    getData(mounted, category);
    notifyListeners();
  }
}
