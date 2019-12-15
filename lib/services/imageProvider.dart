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


  Future<Uint8List> getThumb(Item item) async {
    final response = await apiClient.client.get(
      "$thumbBaseUrl/${item.thumb}",
      options: Options(responseType: ResponseType.bytes),
    );

    final cachedImage = CachedImage(
      image: Uint8List.fromList(response.data),
    );

    return cachedImage.image;
  }

  Future<Uint8List> getImage(Item item) async {
    final response = await apiClient.client.get(
      "$imageBase/${item.thumb}",
      options: Options(responseType: ResponseType.bytes),
    );

    final cachedImage = CachedImage(
      image: Uint8List.fromList(response.data),
    );

    return cachedImage.image;
  }
}

class CachedImage {
  final Uint8List image;
  final DateTime cachedDate;

  CachedImage({this.image}) : cachedDate = DateTime.now();
}