import 'package:dio/dio.dart';

import 'apiClient.dart';

class BaseApi {
  final apiClient = ApiClient();
  Dio get client => apiClient.client;
}