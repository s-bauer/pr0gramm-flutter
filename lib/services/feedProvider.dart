import 'package:pr0gramm/entities/commonTypes/flags.dart';
import 'package:pr0gramm/entities/commonTypes/item.dart';
import 'package:pr0gramm/entities/commonTypes/promotionStatus.dart';
import 'package:pr0gramm/entities/postInfo.dart';
import 'package:pr0gramm/services/itemProvider.dart';
import 'package:pr0gramm/services/linkedPostInfoProvider.dart';

class FeedProvider {
  final FeedType feedType;
  final FeedDetails feedDetails;
  final ItemProvider _itemProvider;
  final LinkedPostInfoProvider linkedPostInfoProvider;

  FeedProvider({this.feedType})
      : feedDetails = new FeedDetails(feedType),
        _itemProvider = new ItemProvider(new FeedDetails(feedType)),
        linkedPostInfoProvider =
            new LinkedPostInfoProvider(new FeedDetails(feedType));

  Future<Item> getItem(int index) => _itemProvider.getItem(index);

  Future<PostInfo> getItemWithInfo(int index) =>
      _itemProvider.getItemWithInfo(index);
}

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
            flags: Flags.SFW,
            promoted: PromotionStatus.Promoted,
            tags: "!-(x:random | x:$bust)");

      case FeedType.RANDOMNEW:
        final bust = DateTime.now().millisecond / 1000.0;
        return FeedDetails._internal(
            flags: Flags.SFW,
            promoted: PromotionStatus.None,
            tags: "!-(x:random | x:$bust)");

      case FeedType.TOP:
        return FeedDetails._internal(
            flags: Flags.SFW, promoted: PromotionStatus.Promoted, tags: null);

      case FeedType.NEW:
      default:
        return FeedDetails._internal(
            flags: Flags.SFW, promoted: PromotionStatus.Promoted, tags: null);
    }
  }
}

enum FeedType {
  TOP,
  NEW,
  RANDOMTOP,
  RANDOMNEW,
}
