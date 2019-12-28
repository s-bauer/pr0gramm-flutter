import 'package:pr0gramm/entities/enums/feed_type.dart';
import 'package:pr0gramm/entities/enums/flags.dart';
import 'package:pr0gramm/entities/enums/promotion_status.dart';

class FeedDetails {
  final Flags flags;
  final PromotionStatus promoted;
  final String tags;
  final String name;

  FeedDetails({this.flags, this.promoted, this.tags, this.name});

  FeedDetails copyWith({
    Flags flags,
    PromotionStatus promoted,
    String tags,
    String name,
  }) {
    return FeedDetails(
      flags: flags ?? this.flags,
      promoted: promoted ?? this.promoted,
      tags: tags ?? this.tags,
      name: name ?? this.name,
    );
  }

  FeedDetails refresh() {
    return this;
  }

  factory FeedDetails.byFeedType(FeedType feedType) {
    final now = DateTime.now();
    final bust = (now.millisecond * 1000 + now.microsecond) / 1000000.0;

    switch (feedType) {
      case FeedType.RANDOMTOP:
        return RandomFeedDetails(
          flags: Flags.sfw,
          promoted: PromotionStatus.promoted,
          tags: "!-(x:random | x:$bust)",
          name: "Zufall Top",
        );

      case FeedType.RANDOMNEW:
        return RandomFeedDetails(
          flags: Flags.sfw,
          promoted: PromotionStatus.none,
          tags: "!-(x:random | x:$bust)",
          name: "Zufall Neu",
        );

      case FeedType.PUBLICTOP:
        return FeedDetails(
          flags: Flags.guest,
          promoted: PromotionStatus.promoted,
          tags: null,
          name: "Top",
        );

      case FeedType.PUBLICNEW:
        return FeedDetails(
          flags: Flags.guest,
          promoted: PromotionStatus.none,
          tags: null,
          name: "Neu",
        );

      case FeedType.TOP:
        return FeedDetails(
          flags: Flags.sfw,
          promoted: PromotionStatus.promoted,
          tags: null,
          name: "Top",
        );

      case FeedType.NEW:
      default:
        return FeedDetails(
          flags: Flags.sfw,
          promoted: PromotionStatus.none,
          tags: null,
          name: "Neu",
        );
    }
  }
}

class RandomFeedDetails extends FeedDetails {
  RandomFeedDetails({
    Flags flags,
    PromotionStatus promoted,
    String tags,
    String name,
  }) : super(
          flags: flags,
          promoted: promoted,
          tags: tags,
          name: name,
        );

  @override
  FeedDetails copyWith({
    Flags flags,
    PromotionStatus promoted,
    String tags,
    String name,
  }) {
    return RandomFeedDetails(
      flags: flags ?? this.flags,
      promoted: promoted ?? this.promoted,
      tags: tags ?? this.tags,
      name: name ?? this.name,
    );
  }

  @override
  RandomFeedDetails refresh() {
    final now = DateTime.now();
    final bust = (now.millisecond * 1000 + now.microsecond) / 1000000.0;
    final newTag = "!-(x:random | x:$bust)";

    return copyWith(tags: newTag);
  }
}
