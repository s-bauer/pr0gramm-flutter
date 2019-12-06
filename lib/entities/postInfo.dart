import 'package:pr0gramm/api/dtos/itemInfoResponse.dart';
import 'package:pr0gramm/entities/commonTypes/item.dart';

class PostInfo {
  final Item item;
  final ItemInfoResponse info;

  PostInfo({this.item, this.info});
}