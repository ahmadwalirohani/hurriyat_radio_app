import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hurriyat_radio/models/weekly_model.dart';
import 'package:dio/dio.dart' as dio;
import 'package:hurriyat_radio/weekly.dart';

class WeeklyBloc extends ChangeNotifier {
  List<WeeklyModel> _data = [];
  List<WeeklyModel> get data => _data;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  int currentPage = 1;

  bool? _hasData;
  bool? get hasData => _hasData;

  String _popSelection = 'recent';
  String get popupSelection => _popSelection;
  Locale? localeLang;

  final _locales = {'en': 1, 'ps': 2, 'fa': 3, 'ar': 4};

  Future<List<WeeklyModel>> _getNewsList(String? category,
      [bool isFirst = true]) async {
    final Map<String, dynamic> queryParams = {
      'page': currentPage,
    };

    try {
      dio.Dio _dio = dio.Dio();

      var f = _locales[localeLang.toString()];

      String url = "https://hurriyat.net/api/weekly/$f";

print(url);
      dio.Response response = await _dio.get(url, queryParameters: queryParams);

      currentPage = response.data['current_page'] as int;

      Weekly newresponse = Weekly.fromJson(response.data);

      _data = [..._data, ...newresponse.data];
      _isLoading = false;
      return newresponse.data;
    } on dio.DioException catch (e) {
      print("this is the main error" + e.error.toString());
      return [];
    }
  }

  Future getData(mounted, String orderBy,
      [bool isFirst = true, Locale? locale]) async {
    if (locale != null) {
      localeLang = locale;
    }
    if (!isFirst) {
      currentPage += 1;
    } else {
      _data.clear();
    }

    await _getNewsList(orderBy);
    notifyListeners();
  }

  afterPopSelection(value, mounted, orderBy) {
    _popSelection = value;
    onRefresh(mounted, orderBy);
    notifyListeners();
  }

  setLoading(bool isloading) {
    _isLoading = isloading;
    notifyListeners();
  }

  onRefresh(mounted, orderBy) {
    _isLoading = true;
    //_snap.clear();
    _data.clear();
    // _lastVisible = null;
    getData(mounted, orderBy);
    notifyListeners();
  }
}
