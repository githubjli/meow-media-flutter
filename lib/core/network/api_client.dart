import 'package:dio/dio.dart';

import '../config/app_config.dart';

class ApiClient {
  ApiClient({Dio? dio})
      : dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: AppConfig.apiBaseUrl,
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
              ),
            );

  final Dio dio;

  Future<Map<String, dynamic>> getJson(String path, {Map<String, dynamic>? queryParameters}) async {
    final response = await dio.get<dynamic>(path, queryParameters: queryParameters);
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return data;
    }
    throw const FormatException('Expected JSON object response.');
  }

  Future<List<dynamic>> getJsonList(String path, {Map<String, dynamic>? queryParameters}) async {
    final response = await dio.get<dynamic>(path, queryParameters: queryParameters);
    final data = response.data;
    if (data is List<dynamic>) {
      return data;
    }
    throw const FormatException('Expected JSON list response.');
  }
}
