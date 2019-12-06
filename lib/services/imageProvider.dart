import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:pr0gramm/api/apiClient.dart';
import 'package:pr0gramm/entities/commonTypes/item.dart';

class ImageProvider {
  static ImageProvider _instance = ImageProvider._internal();

  ImageProvider._internal();

  factory ImageProvider() => _instance;

  static const thumbBaseUrl = "https://thumb.pr0gramm.com";
  static const imageBase = "https://img.pr0gramm.com";
  static const cacheThreshold = 150;

  final apiClient = ApiClient();
  static final cachedThumbs = Map<int, CachedImage>();
  static final cachedImages = Map<int, CachedImage>();

  Future<Uint8List> getThumb(Item item) async {
    if (cachedThumbs.containsKey(item.id)) return cachedThumbs[item.id].image;
    var response;

    try {
      response = await apiClient.client.get(
        "$thumbBaseUrl/${item.thumb}",
        options: Options(responseType: ResponseType.bytes),
      );

    } catch (e) {
      print(e);
      return null;
    }

    final cachedImage = CachedImage(
      image: Uint8List.fromList(response.data),
    );

    cachedThumbs[item.id] = cachedImage;
    return cachedImage.image;
  }

  Future<Uint8List> getImage(Item item) async {
    if (cachedImages.containsKey(item.id)) return cachedImages[item.id].image;
    var response;

    try {
      response = await apiClient.client.get(
        "$imageBase/${item.thumb}",
        options: Options(responseType: ResponseType.bytes),
      );
    } catch (e) {
      print(e);
      return null;
    }

    final cachedImage = CachedImage(
      image: Uint8List.fromList(response.data),
    );

    cachedImages[item.id] = cachedImage;
    return cachedImage.image;
  }

  Uint8List getThumbSync(Item item) {
    if (cachedThumbs.containsKey(item.id)) return cachedThumbs[item.id].image;

    return Uint8List(0);
  }
}

class CachedImage {
  final Uint8List image;
  final DateTime cachedDate;

  CachedImage({this.image}) : cachedDate = DateTime.now();
}
