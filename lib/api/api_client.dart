import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class ApiClient {
  static const baseUrl = "https://pr0gramm.com/api";
  static final ApiClient _instance = ApiClient._internal();

  CookieJar jar = CookieJar();
  final Dio client = Dio(BaseOptions(baseUrl: baseUrl));

  factory ApiClient() {
    return _instance;
  }

  List<Cookie> getCookies() {
    return jar.loadForRequest(Uri.parse(baseUrl));
  }

  ApiClient._internal() {
    client.interceptors.add(CookieManager(jar));

    (client.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
//      client.findProxy = (url) {
//        return "PROXY 192.168.11.10:8888";
//      };

      client.badCertificateCallback = (cert, host, port) => Platform.isAndroid;
    };
  }

  void setToken(String token, String meToken) {
    final cookie = Cookie("pp", token);
    final meCookie = Cookie("me", meToken);
    jar.saveFromResponse(Uri.parse(baseUrl), [cookie, meCookie]);
  }

  void logout() {
    jar = CookieJar();
  }
}
