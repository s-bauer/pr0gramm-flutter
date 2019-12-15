import 'package:pr0gramm/entities/commonTypes/baseTypes/enum.dart';

class ItemType extends Enum<int> {
  static ItemType item = ItemType(0);
  static ItemType comment = ItemType(1);
  static ItemType tag = ItemType(2);

  ItemType(int value) : super(value);
}