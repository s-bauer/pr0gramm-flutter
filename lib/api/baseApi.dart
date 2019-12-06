import 'package:dio/dio.dart';
import 'package:pr0gramm/api/apiClient.dart';


class BaseApi {
  final apiClient = ApiClient();
  Dio get client => apiClient.client;
}