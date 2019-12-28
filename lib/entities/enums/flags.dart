import 'package:pr0gramm/entities/base_types/enum.dart';

class Flags extends Enum<int> {
  static Flags guest = Flags(1);
  static Flags sfw = Flags(9);
  static Flags nsfw = Flags(2);
  static Flags nsfl = Flags(4);
  static Flags all = Flags.sfw | Flags.nsfw | Flags.nsfl;

  Flags(int val) : super(val);

  Flags operator |(Flags other) {
    return Flags(value | other.value);
  }
}
