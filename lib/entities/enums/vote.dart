import 'package:pr0gramm/entities/commonTypes/baseTypes/enum.dart';

class Vote extends Enum<int> {
  static Vote down = Vote(-1);
  static Vote none = Vote(0);
  static Vote up = Vote(1);
  static Vote favorite = Vote(2);

  Vote(int val) : super(val);
}
