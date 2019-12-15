
import 'package:pr0gramm/entities/enums/feed_type.dart';
import 'package:pr0gramm/entities/enums/flags.dart';
import 'package:pr0gramm/entities/enums/promotion_status.dart';

class FeedDetails {
  final Flags flags;
  final PromotionStatus promoted;
  final String tags;

  FeedDetails._internal({this.flags, this.promoted, this.tags});

  factory FeedDetails(FeedType feedType) {
    switch (feedType) {
      case FeedType.RANDOMTOP:
        final bust = DateTime.now().millisecond / 1000.0;
        return FeedDetails._internal(
            flags: Flags.sfw,
            promoted: PromotionStatus.promoted,
            tags: "!-(x:random | x:$bust)");

      case FeedType.RANDOMNEW:
        final bust = DateTime.now().millisecond / 1000.0;
        return FeedDetails._internal(
            flags: Flags.sfw,
            promoted: PromotionStatus.none,
            tags: "!-(x:random | x:$bust)");

      case FeedType.PUBLICTOP:
        return FeedDetails._internal(
            flags: Flags.guest, promoted: PromotionStatus.promoted, tags: null);

      case FeedType.PUBLICNEW:
        return FeedDetails._internal(
            flags: Flags.guest, promoted: PromotionStatus.none, tags: null);

      case FeedType.TOP:
        return FeedDetails._internal(
            flags: Flags.sfw, promoted: PromotionStatus.promoted, tags: null);

      case FeedType.NEW:
      default:
        return FeedDetails._internal(
            flags: Flags.sfw, promoted: PromotionStatus.none, tags: null);
    }
  }
}
