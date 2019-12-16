import 'package:pr0gramm/entities/enums/feed_type.dart';
import 'package:pr0gramm/entities/enums/flags.dart';
import 'package:pr0gramm/entities/enums/promotion_status.dart';

class FeedDetails {
  final Flags flags;
  final PromotionStatus promoted;
  final String tags;
  final String name;

  FeedDetails._internal({this.flags, this.promoted, this.tags, this.name});

  factory FeedDetails(FeedType feedType) {
    final bust = DateTime.now().millisecond / 1000.0;

    switch (feedType) {
      case FeedType.RANDOMTOP:
        return FeedDetails._internal(
          flags: Flags.sfw,
          promoted: PromotionStatus.promoted,
          tags: "!-(x:random | x:$bust)",
          name: "Zufall Top",
        );

      case FeedType.RANDOMNEW:
        return FeedDetails._internal(
          flags: Flags.sfw,
          promoted: PromotionStatus.none,
          tags: "!-(x:random | x:$bust)",
          name: "Zufall Neu",
        );

      case FeedType.PUBLICTOP:
        return FeedDetails._internal(
          flags: Flags.guest,
          promoted: PromotionStatus.promoted,
          tags: null,
          name: "Top",
        );

      case FeedType.PUBLICNEW:
        return FeedDetails._internal(
          flags: Flags.guest,
          promoted: PromotionStatus.none,
          tags: null,
          name: "Neu",
        );

      case FeedType.TOP:
        return FeedDetails._internal(
          flags: Flags.sfw,
          promoted: PromotionStatus.promoted,
          tags: null,
          name: "Top",
        );

      case FeedType.NEW:
      default:
        return FeedDetails._internal(
          flags: Flags.sfw,
          promoted: PromotionStatus.none,
          tags: null,
          name: "Neu",
        );
    }
  }
}
