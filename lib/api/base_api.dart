import 'package:dio/dio.dart';

import 'api_client.dart';

class BaseApi {
  final apiClient = ApiClient();

  Dio get client => apiClient.client;
}
