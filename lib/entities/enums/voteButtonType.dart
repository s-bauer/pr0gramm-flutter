import 'package:pr0gramm/entities/baseTypes/enum.dart';
import 'package:pr0gramm/entities/enums/vote.dart';

class VoteButtonType extends Enum<int> {
  static VoteButtonType down = VoteButtonType(-1);
  static VoteButtonType up = VoteButtonType(1);
  static VoteButtonType favorite = VoteButtonType(2);

  VoteButtonType(int val) : super(val);
  Vote toVote() => Vote(value);
}
