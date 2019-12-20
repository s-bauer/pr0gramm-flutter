import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:pr0gramm/api/api_client.dart';
import 'package:pr0gramm/api/dtos/item/item.dart';

class MyImageProvider {
  static MyImageProvider _instance = MyImageProvider._internal();

  MyImageProvider._internal();

  factory MyImageProvider() => _instance;

  static const thumbBaseUrl = "https://thumb.pr0gramm.com";
  static const imageBase = "https://img.pr0gramm.com";
  static const cacheThreshold = 150;

  final apiClient = ApiClient();

  String getThumbUrl(Item item) {
    return "$thumbBaseUrl/${item.thumb}";
  }

  Future<Uint8List> getThumb(Item item) async {
    final response = await apiClient.client.get(
      getThumbUrl(item),
      options: Options(responseType: ResponseType.bytes),
    );

    return Uint8List.fromList(response.data);
  }

  String getImageUrl(Item item) {
    return "$imageBase/${item.image}";
  }

  Future<Uint8List> getImage(Item item) async {
    final response = await apiClient.client.get(
      getImageUrl(item),
      options: Options(responseType: ResponseType.bytes),
    );

    return Uint8List.fromList(response.data);
  }
}
