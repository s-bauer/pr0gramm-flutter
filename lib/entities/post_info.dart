import 'package:pr0gramm/api/dtos/item/item_info.dart';
import 'package:pr0gramm/api/dtos/item/item.dart';

class PostInfo {
  final Item item;
  final ItemInfo info;

  PostInfo({this.item, this.info});
}