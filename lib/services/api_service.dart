// lib/api_service.dart
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<dynamic>> fetchData(String url) async {
    try {
      final response = await _dio.get("https://hurriyat.net/api/${url}");
      return response.data; // Assuming the response data is a list
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
}
