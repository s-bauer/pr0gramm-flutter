import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:pr0gramm/api/apiClient.dart';
import 'package:pr0gramm/api/dtos/getItemsResponse.dart';

class ImageProvider {
  static ImageProvider _instance = ImageProvider._internal();
  ImageProvider._internal();
  factory ImageProvider() => _instance;

  static const thumbBaseUrl = "https://thumb.pr0gramm.com";
  static const imageBase = "https://img.pr0gramm.com";
  static const cacheThreshold = 150;

  final apiClient = ApiClient();
  final cachedThumbs = Map<int, CachedImage>();
  final cachedImages = Map<int, CachedImage>();


  Future<Uint8List> getThumb(Item item) async {
    if(cachedThumbs.containsKey(item.id))
      return cachedThumbs[item.id].image;

    final response = await apiClient.client.get(
      "$thumbBaseUrl/${item.thumb}",
      options: Options(responseType: ResponseType.bytes),
    );

    final cachedImage = CachedImage(
      image: Uint8List.fromList(response.data),
    );

    cachedThumbs[item.id] = cachedImage;
    return cachedImage.image;
  }

  Future<Uint8List> getImage(Item item) async {
    if(cachedImages.containsKey(item.id))
      return cachedImages[item.id].image;

    final response = await apiClient.client.get(
      "$imageBase/${item.thumb}",
      options: Options(responseType: ResponseType.bytes),
    );

    final cachedImage = CachedImage(
      image: Uint8List.fromList(response.data),
    );

    cachedImages[item.id] = cachedImage;
    return cachedImage.image;
  }
}

class CachedImage {
  final Uint8List image;
  final DateTime cachedDate;

  CachedImage({this.image}) : cachedDate = DateTime.now();
}