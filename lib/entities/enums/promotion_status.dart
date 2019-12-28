import 'package:pr0gramm/entities/base_types/enum.dart';

class PromotionStatus<int> extends Enum<int> {
  static PromotionStatus none = PromotionStatus(0);
  static PromotionStatus promoted = PromotionStatus(1);

  PromotionStatus(int val) : super(val);
}
