import 'package:pr0gramm/entities/commonTypes/enum.dart';

class Flags extends Enum<int> {
  static Flags GUEST = Flags(1);
  static Flags SFW = Flags(9);
  static Flags NSFW = Flags(2);
  static Flags NSFL = Flags(4);
  static Flags All = Flags(15);

  Flags(int val) : super(val);
}
