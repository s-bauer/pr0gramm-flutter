import 'package:pr0gramm/entities/commonTypes/baseTypes/enum.dart';

class PromotionStatus<int> extends Enum<int> {
  static PromotionStatus None = PromotionStatus(0);
  static PromotionStatus Promoted = PromotionStatus(1);

  PromotionStatus(int val) : super(val);
}
