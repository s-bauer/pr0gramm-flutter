import 'package:pr0gramm/entities/baseTypes/enum.dart';

class ItemRange extends Enum<String> {
  static ItemRange newer = ItemRange("newer");
  static ItemRange older = ItemRange("older");
  static ItemRange around = ItemRange("around");
  static ItemRange end = ItemRange("end");
  static ItemRange start = ItemRange("id");

  ItemRange(String val) : super(val);
}
