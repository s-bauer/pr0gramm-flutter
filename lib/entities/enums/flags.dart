import 'package:pr0gramm/entities/commonTypes/baseTypes/enum.dart';

class Flags extends Enum<int> {
  static Flags GUEST = Flags(1);
  static Flags SFW = Flags(9);
  static Flags NSFW = Flags(2);
  static Flags NSFL = Flags(4);
  static Flags All = Flags.SFW | Flags.NSFW | Flags.NSFL;

  Flags(int val) : super(val);

  Flags operator |(Flags other) {
    return Flags(value | other.value);
  }
}
