import 'package:pr0gramm/entities/commonTypes/baseTypes/enum.dart';

class Vote extends Enum<int> {
  static Vote Down = Vote(-1);
  static Vote None = Vote(0);
  static Vote Up = Vote(1);
  static Vote Favorite = Vote(2);

  Vote(int val) : super(val);
}
