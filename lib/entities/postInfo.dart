import 'package:pr0gramm/api/dtos/getItemsResponse.dart';
import 'package:pr0gramm/api/dtos/itemInfoResponse.dart';

class PostInfo {
  final Item item;
  final ItemInfoResponse info;

  PostInfo({this.item, this.info});
}